;Mike Walker

;Get an array of granule data form the h5 file -----
function getGranule, rdrType, granuleID, file
    str = STRING('/All_Data/') + rdrType + STRING('/RawApplicationPackets_') +$
      STRTRIM(STRING(granuleID), 1)
     
    toReturn = h5_getdata(file, str)
  return, toReturn
end

;Get number of apids in the given granule from the static header -----
function numApidsGran, granule
  return, swap_endian(ulong(granule[36:39],0))
end

;Get the number of packets received from the static header -----
function numPackets, granule
  return, swap_endian(ulong(granule[100:103],0))
end

;Get the apid and version number of a given packet. APID is 11 bits, so it runs inot the bits of the version number -----
function getHeader, file, rdrType, granule, packetNum
  index = packetIndex(rdrType, file, granule, packetNum)
  return, granule[index:index+1]
end

;Get an array of a parameter from an rdr file -----
function getParam, files_tmp, rdrType, maxGran, indexInPacket, parByteSize, header, type=t, v=v ; V for verbose
  if ~ keyword_set(t) then t = 'ULONG' 
  if ~ keyword_set(v) then v = 0 ;not verbose
  toReturn = List()
  bitStart = round(8D*(indexInPacket MOD 1D)) ; start bits
  bitSize = round(8D*(parByteSize MOD 1D))
  ; Extract only the filenames pertaining to the desired telemtry/science. Otherwise h5_getdata will crash when it can't find the specific submodule in the file
  files =  files_tmp[where(files_tmp.IndexOf( (rdrType.IndexOf('TELEMETRY') gt -1 ? 'ROLPT' : 'RNSCA') ) gt -1)]
 ; print, bitStart, ' ', bitSize
  foreach element, files do begin
    for granNum=0,maxGran do begin
      granule = getGranule(rdrType, granNum, element)
      numPackets = numPackets(granule)
      for packetNum=0, numPackets do begin
        head = getHeader(element, rdrType, granule, packetNum)
        if header[0] eq head[0] and header[1] eq head[1] then begin ; check that the packet were are looking at is for the correct apid
          
          headerOffset = 20; byte size of primary + secondary + OMPS header
          first2bytes = head.tobits() ; get the first 16 bits 
          if first2bytes[4] eq 0 then headerOffset = 10 ; If secondaryHeaderflag == 0 , adjust the offset
          
          index = packetIndex(rdrType, element, granule, packetNum) + headerOffset

          
          if bitSize + bitStart ne 0 then begin ; If there are bits involved
            value = swap_endian(byte(granule[index+floor(indexInPacket):index+floor(indexInPacket)+ceil(parByteSize)-1])) ; take slightly too much data
            value = value.tobits() ; extract 8 bits from each byte
            value = value[bitStart:bitStart+bitSize-1] ; extract our data, but it is still a bit array.
            ; IDL has no good way that I know of to convert back to base ten int so I made my own naive implementation
            pows = 2^[value.length-1:1] ; powers of 2
            value = uint(total(pows * value)) ; multiply the powers by the bits to get back to base ten
                     
          endif else begin
            if t eq 'ULONG' || t eq 'UINT' || t eq 'BYTE' then begin ; If the values are signed
              
              case parByteSize of
                1 : value = swap_endian(byte(granule[index+indexInPacket:index+indexInPacket+parByteSize-1],0)) ; uint8
                2 : value = swap_endian(uint(granule[index+indexInPacket:index+indexInPacket+parByteSize-1], 0)) ;uint16
                4 : value = swap_endian(ulong(granule[index+indexInPacket:index+indexInPacket+parByteSize-1],0)) ;uint32
              endcase
              
            endif else begin
              case parByteSize of
                1 : value = swap_endian(granule[index+indexInPacket:index+indexInPacket+parByteSize-1]) ; int8 is default in IDL
                2 : value = swap_endian(fix(granule[index+indexInPacket:index+indexInPacket+parByteSize-1])) ; int16
                4 : value = swap_endian(long(granule[index+indexInPacket:index+indexInPacket+parByteSize-1],0)) ; int32
              endcase
            endelse
            
            ;testing
            if v then begin
             b = value[-1].tobits()
             print, 't = ' + t + ', num bits per val => ' + string(b.length)
            endif
          endelse
          toReturn.Add, value
        
        endif
      endfor
    endfor
  endforeach
  return, toReturn.ToArray(TYPE=t)
end

;Get an array of time values from an rdr file -----
function getTimes, file, rdrType, maxGranNum, indexInPacket, header

  headerOffset = 20; Byte size of header. We need it here to subtract, since getparams adds this offset

  adding = List()
  days = getParam(file, rdrType, maxGranNum, indexInPacket - headerOffset, 2, header)
  milliseconds = getParam(file, rdrType, maxGranNum, indexInPacket+2 - headerOffset, 4, header, t='ULONG64')
  microseconds = getParam(file, rdrType, maxGranNum, indexInPacket+6 - headerOffset, 2, header)
  days_arr = MAKE_ARRAY(days.LENGTH, /DOUBLE)
  days_arr=DOUBLE(days)+DOUBLE(milliseconds/(8.64e+7))+DOUBLE(microseconds/(8.64e+10))
  adding.Add, DOUBLE(days_arr)
  toReturn = adding.ToArray(TYPE='DOUBLE')
  return, toReturn ; return time since 01-01-1958 in days (and a fraction for less than a day)
end



;Get the starting index of a packet -----
function packetIndex, rdrType, file, granule, packetNum
  trackerIndex = swap_endian(ulong(granule[44:47],0))
  packetstart = swap_endian(ulong(granule[48:51],0))
  index = packetStart + swap_endian(ulong(granule[trackerIndex+16+(packetNum-1)*24:$
    trackerIndex+19+(packetNum-1)*24],0))
  if (granule[trackerIndex+16+(packetNum-1)*24] eq 255) $
    && (granule[trackerIndex+17+(packetNum-1)*24] eq 255) $
    && (granule[trackerIndex+18+(packetNum-1)*24] eq 255) $
    && (granule[trackerIndex+19+(packetNum-1)*24] eq 255) then index = -1
  if index gt granule.LENGTH then index = -1
  return, index
end



;Create 2D plot of a parameter over time ------
function plotVsTime, times, data, mtitl, ytitl
  labDate = label_date(date_format=['%H:%I:%S']) ; generate placeholder for label date format
  tdiff = DOUBLE((DOUBLE(MAX(times))-DOUBLE(MIN(times)))/7)
  ddiff = DOUBLE((DOUBLE(MAX(data))-DOUBLE(MIN(data)))/7)
    
  p = plot(times,data,xrange=[DOUBLE(MIN(times)),DOUBLE(MAX(times)$
    +tdiff)],yrange=[DOUBLE(MIN(data)-ddiff),DOUBLE(MAX(data)+ddiff)], $
    title= mtitl, ytitle=ytitl, xtickformat='LABEL_DATE', thick=3, color='Blue', $
    position=[0.2,0.1,0.99,0.9], /CURRENT)
  
  a = p.axes[0] ; retrieve x-axis axes object
  a.text_orientation = 45.0 ; set orientation to 45 degrees
   
end

;Create 3D plot of a two parameters over time ------
function plotVsTime3D, times, data1, data2, mtitl, xtitl, ytitl, ztitl
  tdiff = DOUBLE((DOUBLE(MAX(times))-DOUBLE(MIN(times)))/7)
  ddiff1 = DOUBLE((DOUBLE(MAX(data1))-DOUBLE(MIN(data1)))/7)
  ddiff2 = DOUBLE((DOUBLE(MAX(data2))-DOUBLE(MIN(data2)))/7)
  p = plot3D(times,data1, data2,xrange=[DOUBLE(MIN(times)-tdiff),$
    DOUBLE(MAX(times)+tdiff)],yrange=[DOUBLE(MIN(data1)-ddiff1),DOUBLE(MAX(data1)+ddiff1)], $
    zrange=[DOUBLE(MIN(data2)-ddiff2),DOUBLE(MAX(data2)+ddiff2)], title= mtitl, xtitle=xtitl,$
    ytitle=ytitl, ztitle=ztitl, /CURRENT)
end