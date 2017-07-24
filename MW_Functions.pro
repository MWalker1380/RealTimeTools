;Mike Walker

;Get an array of granule data -----
function getGranule, rdrType, granuleID, file
    str = STRING('/All_Data/') + rdrType + STRING('/RawApplicationPackets_') +$
      STRTRIM(STRING(granuleID), 1)
    toReturn = h5_getdata(file, str)
  return, toReturn
end

;Get number of apids in the given granule -----
function numApidsGran, granule
  return, swap_endian(ulong(granule[36:39],0))
end

;Get the number of packets received -----
function numPackets, granule
  return, swap_endian(ulong(granule[100:103],0))
end

;Get the apid of a given packet -----
function getHeader, file, rdrType, granule, packetNum
  index = packetIndex(rdrType, file, granule, packetNum)
  return, granule[index:index+1]
end

;Get an array of a parameter from an rdr file -----
function getParam, files, rdrType, maxGran, indexInPacket, parByteSize, header
  toReturn = List()
  foreach element, files do begin
    for granNum=0,maxGran do begin
      granule = getGranule(rdrType, granNum, element)
      numPackets = numPackets(granule)
      temp = MAKE_ARRAY(numPackets)
      for packetNum=1, numPackets do begin
        head = getHeader(element, rdrType, granule, packetNum)
        if header[0] eq head[0] and header[1] eq head[1] then begin
          index = packetIndex(rdrType, element, granule, packetNum)
          if parByteSize eq 1 then value = swap_endian(byte(granule[index+indexInPacket:index+indexInPacket+parByteSize-1],0))
          if parByteSize eq 2 then value = swap_endian(uint(granule[index+indexInPacket:index+indexInPacket+parByteSize-1],0))
          if parByteSize eq 4 then value = swap_endian(ulong(granule[index+indexInPacket:index+indexInPacket+parByteSize-1],0))
          toReturn.Add, value
        endif
      endfor
    endfor
  endforeach
  return, toReturn.ToArray(TYPE='ULONG')
end

;Get an array of time values from an rdr file -----
function getTimes, file, rdrType, maxGranNum, indexInPacket, header
  adding = List()
    days = getParam(file, rdrType, maxGranNum, indexInPacket, 2, header)
    milliseconds = getParam(file, rdrType, maxGranNum, indexInPacket+2, 4, header)
    microseconds = getParam(file, rdrType, maxGranNum, indexInPacket+6, 2, header)
    days_arr = MAKE_ARRAY(days.LENGTH, /DOUBLE)
    days_arr[*]=DOUBLE(days[*])+DOUBLE(milliseconds[*]/(8.64e+7))+DOUBLE(microseconds[*]/(8.64e+10))
    adding.Add, DOUBLE(days_arr[*])
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
    AND (granule[trackerIndex+17+(packetNum-1)*24] eq 255) $
    AND (granule[trackerIndex+18+(packetNum-1)*24] eq 255) $
    AND (granule[trackerIndex+19+(packetNum-1)*24] eq 255) then index = -1
  if index gt granule.LENGTH then index = -1
  return, index
end

;Create 2D plot of a parameter over time ------
function plotVsTime, times, data, mtitl, ytitl
  labDate = label_date(date_format=['%H:%I:%S']) ; generate placeholder for label date format
  tdiff = DOUBLE((DOUBLE(MAX(times[*]))-DOUBLE(MIN(times[*])))/7)
  ddiff = DOUBLE((DOUBLE(MAX(data[*]))-DOUBLE(MIN(data[*])))/7)
    
  p = plot(times,data,xrange=[DOUBLE(MIN(times[*])),DOUBLE(MAX(times)$
    +tdiff)],yrange=[DOUBLE(MIN(data)-ddiff),DOUBLE(MAX(data)+ddiff)], $
    title= mtitl, xtitle='Time (HH:MM:SS)', ytitle=ytitl, xtickformat='LABEL_DATE', /CURRENT)
  
  a = p.axes[0] ; retrieve x-axis axes object
  a.text_orientation = 45.0 ; set orientation to 45 degrees
   
end

;Create 3D plot of a two parameters over time ------
function plotVsTime3D, times, data1, data2, mtitl, xtitl, ytitl, ztitl
  tdiff = DOUBLE((DOUBLE(MAX(times[*]))-DOUBLE(MIN(times[*])))/7)
  ddiff1 = DOUBLE((DOUBLE(MAX(data1[*]))-DOUBLE(MIN(data1[*])))/7)
  ddiff2 = DOUBLE((DOUBLE(MAX(data2[*]))-DOUBLE(MIN(data2[*])))/7)
  p = plot3D(times[*],data1[*], data2[*],xrange=[DOUBLE(MIN(times[*])-tdiff),$
    DOUBLE(MAX(times[*])+tdiff)],yrange=[DOUBLE(MIN(data1[*])-ddiff1),DOUBLE(MAX(data1[*])+ddiff1)], $
    zrange=[DOUBLE(MIN(data2[*])-ddiff2),DOUBLE(MAX(data2[*])+ddiff2)], title= mtitl, xtitle=xtitl,$
    ytitle=ytitl, ztitle=ztitl, /CURRENT)
end