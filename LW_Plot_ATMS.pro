; This program reads in a series of ATMS Science RDRs into memory, ready for plotting
; main routine extracts plottable data, and then calls plot GUI

;; variables are not available at the command line. Must debug in separate files

PRO PlotCountsATMS_ev, event

  COMMON ATMSblock, daysec, counts, n_files

  WIDGET_CONTROL, event.id, GET_VALUE = eventval    ;find the value. ANother option is get_uvalue
  
  IF N_ELEMENTS(eventval) EQ 0 THEN RETURN
  
;  widget_control, /hourglass

  print, "eventval", eventval
  
  etype = size(eventval,/type)
  
  print, 'type', etype
  
  ; since eventval can be string or integer, need to treat separately to avoid typing error
  
  if etype eq 2 then begin
  
   CASE eventval OF
    
    0: begin
         c = counts[0,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 1 Counts'
       end
    1: begin
         c = counts[1,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 2 Counts'
       end
    2: begin
         c = counts[2,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 3 Counts'
       end
    3: begin
         c = counts[3,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 4 Counts'
       end
    4: begin
         c = counts[4,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 5 Counts'
       end
    5: begin
         c = counts[5,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 6 Counts'
       end
    6: begin
         c = counts[6,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 7 Counts'
       end
    7: begin
         c = counts[7,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 8 Counts'
       end
    8: begin
         c = counts[8,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 9 Counts'
       end
    9: begin
         c = counts[9,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 10 Counts'
       end
    10: begin
         c = counts[10,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 11 Counts'
       end
    11: begin
         c = counts[11,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 12 Counts'
       end
    12: begin
         c = counts[12,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 13 Counts'
       end
    13: begin
         c = counts[13,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 14 Counts'
       end
    14: begin
         c = counts[14,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 15 Counts'
       end
    15: begin
         c = counts[15,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 16 Counts'
       end
    16: begin
         c = counts[16,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 17 Counts'
       end
    17: begin
         c = counts[17,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 18 Counts'
       end
    18: begin
         c = counts[18,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 19 Counts'
       end
    19: begin
         c = counts[19,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 20 Counts'
       end
    20: begin
         c = counts[20,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 21 Counts'
       end
    21: begin
         c = counts[21,*,*,*]                ;pull out channel of interest
         tit = 'ATMS: Time Series: Channel 22 Counts'
       end

   ENDCASE

   dsv = daysec[*]                    ; make plottable vector of time array
   cv = c[*]                        ; make plottable vector of counts array
   p = scatterplot(dsv,cv,xrange=[dsv[0],dsv[0]+(0.0056*n_files)], $ ;plot range assumes all granules in a file are plotted
       title= tit, xtitle='day fraction (0.001 = 1.4 min)')
  endif
   
   if etype eq 7 then begin
    
     CASE eventval OF

       'DONE': WIDGET_CONTROL, event.top, /DESTROY
     
     ENDCASE
    
   endif

END ;============= end of PlotCounts event handling routine task =============


;PRO PlotCounts2, param, GROUP = GROUP, BLOCK=block

PRO PlotCountsATMS

  COMMON ATMSblock, daysec, counts, n_files

  ;*** If PlotCounts can have multiple copies running, then delete the following
  ;*** line and the comment for it.  Often a common block is used that prohibits
  ;*** multiple copies of the widget application from running.  In this case,
  ;*** leave the following line intact.

  IF(XRegistered("PlotCountsATMS") NE 0) THEN RETURN    ;only one instance of
  ;the PlotCounts widget
  ;is allowed.  If it is
  ;already managed, do
  ;nothing and return

  IF N_ELEMENTS(block) EQ 0 THEN block=0

  PCbase = WIDGET_BASE(TITLE = "ATMS Channel Counts",/column) ;create the main base

  label = WIDGET_LABEL(PCbase, VALUE='Choose an ATMS Channel') ; add label to base

  button_labels = ['Ch. 1', 'Ch. 2', 'Ch. 3', 'Ch. 4', 'Ch. 5', 'Ch. 6', 'Ch. 7', $
                   'Ch. 8', 'Ch. 9', 'Ch. 10', 'Ch. 11', 'Ch. 12', 'Ch. 13', 'Ch. 14', $
                   'Ch. 15', 'Ch. 16', 'Ch. 17', 'Ch. 18', 'Ch. 19', 'Ch. 20', $
                   'Ch. 21', 'Ch. 22']

  ;state_vals = [0, 1, 26

  ; one call to CW_BGROUP replaces 22 calls to WIDGET_BUTTON. The value returned is the index
  buttons = CW_BGROUP(PCbase, button_labels, /exclusive, /COLUMN, /FRAME, /RETURN_index, /NO_RELEASE) ;add buttons to base
  ;BUTTON_UVALUE = state_vals)

  button1 = WIDGET_BUTTON(PCbase, UVALUE = 'DONE', VALUE = 'DONE') ;add done button to base

  WIDGET_CONTROL, PCbase, /REALIZE   ;create the widgets


  XManager, "PlotCountsATMS", PCbase, $      ;register the widgets
    EVENT_HANDLER = "PlotCountsATMS_ev", /no_block ;, $  ;with the XManager
  ; GROUP_LEADER = GROUP, $     ;and pass through the
  ; NO_BLOCK=(NOT(FLOAT(block)))    ;group leader if this
                                    ;routine is to be
                                    ;called from some group
                                    ;leader.


END ;==================== end of PlotCounts =======================

; start main routine to extract data from Science RDRs

PRO LW_Plot_ATMS

; the ATMS-Sci RDR contains 4 science related APIDs:
;   APID 515 Cal
;   APID 528 Science
;   APID 530 HotCal
;   APID 531 Eng H&S
;   
; Each RDR contains 15 granules. Each granule contains 12 scans = 32 seconds at 8/3 sec per scan
;   APID 528 = 62B, 1/scan * 104 beam positions => 1248 packets = 77376B. Some granules have only 1247 packets
;   APID 515 = 444B, 1/8sec => 4 packets = 1776B
;   APID 531 = 162B, 1/3scans => 4 packets = 648B
;   APID 530 = 48B, 1/scan => 12 packets = 576B
;   
; A Science granule is 12 scans. A granule is variably 111104 or 111042 B
;   for each granule, the RDR static header is 72B
;   apidList 4x32B = 128B
;   528 trackers 1248x24B = 29952B
;   515 trackers 4x24B = 96B
;   531 trackers 4x24B = 96B
;   530 trackers 12x24B = 288B
;    ====> the granule header adds to 30632B. Yet the first APID seems to always start on 30782.
;       for some reason, there is an extra 96B in the granule header, since most packets are 111104B long
;
; the ATMS-Sci RDR also contains the S/C diary APID 11
;   the diary timespan is not coincident with the instrument, but overextends it on both ends
;   the diary is under a separate tag in the RDR from the ATMS APIDs
;   Each RDR contains 24 diary granules
;   APID 11 = 71B, produced 1/sec => 32 packets = 2272B

; be careful to compile this module first, since it will set param. THen compile PlotCounts
COMMON ATMSblock, daysec, counts, n_files

; pick a set of ATMS Science RDRs
Files=dialog_pickfile(/multiple_files)

n_files=n_elements(Files)

print, n_files

; check if the user cancels the dialog (from Mike on stackexchange)
if (n_files eq 1 && Files[0] eq '') then n_files = 0

; time the run
clock_id = tic()

grans = bytarr(111104,15,n_files)

; these byte arrays that hold the packets are indexed by byte-of-packet, packet per granule, granule per RDR file, RDR file
;   increased array size from nromal because packet finding algorithm counts packet fragments
packet528 = bytarr(62,1259,15,n_files)
packet515 = bytarr(444,5,15,n_files)
packet531 = bytarr(162,5,15,n_files)
packet530 = bytarr(48,16,15,n_files)


; this array contains the APID ID, grans index of the 10, and size of APID. 
; if no APID ID is found, the value is left zero; if no expected size was found, the value is left zero
; The value 2000 is set to a value larger than num10. reduce the value to improve performance
apidSeq = lonarr(3,3000,15,n_files)

; define the variables constituting each packet: first index is size of field, second is APID count per granule,
;   thrid is granule count per RDR, 4th is RDR file count
header515 = bytarr(6,5,15,n_files)
day515 = uintarr(1,5,15,n_files)
sec515 = ulonarr(1,5,15,n_files)
msc515 = uintarr(1,5,15,n_files)

header528 = bytarr(6,1259,15,n_files) ;increased array size from 1248 because packet finding algorithm counts packet fragments
day528 = uintarr(1,1259,15,n_files)
sec528 = ulonarr(1,1259,15,n_files)
msc528 = uintarr(1,1259,15,n_files)
daysec = fltarr(1,1259,15,n_files)
angC = uintarr(1,1259,15,n_files)
ang = fltarr(1,1259,15,n_files)
errf = bytarr(2,1259,15,n_files)
counts = uintarr(22,1259,15,n_files)


;RDR structure names are discovered from help and H5_browser




; on my machine this data read takes about 1.0 sec
;GranParse = H5_PARSE(File, /READ_DATA)
;packets[0,0] = GranParse.ALL_DATA.ATMS_TELEMETRY_RDR_ALL.RAWAPPLICATIONPACKETS_0._DATA[200:361]
;packets[0,1] = GranParse.ALL_DATA.ATMS_TELEMETRY_RDR_ALL.RAWAPPLICATIONPACKETS_0._DATA[362:523]
;packets[0,2] = GranParse.ALL_DATA.ATMS_TELEMETRY_RDR_ALL.RAWAPPLICATIONPACKETS_0._DATA[524:685]
;packets[0,3] = GranParse.ALL_DATA.ATMS_TELEMETRY_RDR_ALL.RAWAPPLICATIONPACKETS_0._DATA[686:847]

for m = 0, n_files - 1 do begin  ; loop over RDR files

 ; print,Files[m]

; since IDL loops first on left index, these commands read the granule into grans starting at byte 0
; for a single H5 RDR, h5_getdata runs 1000x faster than h5_parse. See how it scales
 grans[0,0,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_0')
 grans[0,1,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_1')
 grans[0,2,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_2')
 grans[0,3,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_3')
 grans[0,4,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_4')
 grans[0,5,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_5')
 grans[0,6,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_6')
 grans[0,7,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_7')
 grans[0,8,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_8')
 grans[0,9,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_9')
 grans[0,10,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_10')
 grans[0,11,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_11')
 grans[0,12,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_12')
 grans[0,13,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_13')
 grans[0,14,m] = h5_getdata(Files[m], '/All_Data/ATMS-SCIENCE-RDR_All/RawApplicationPackets_14')
 
; <begin logic taken from RDR-info-3.pro
 
  for k=0,14 do begin  ;this loops on granules in the RDR
  
    nele=n_elements(grans[*,k,m])

    ind10 = where(grans[*,k,m] eq 10B)

    num10 = n_elements(ind10)


    ; this loop and following lines sets the APID ID and granule index
    for i=0,(num10-2) do begin

      if (grans[ind10[i]+1,k,m] eq 16B) then apidSeq[0,i,k,m]=528L ; first two bytes of 528 packet are 10 16

      if (grans[ind10[i]+1,k,m] eq 3B) then apidSeq[0,i,k,m]=515L ; first two bytes of 515 packet are 10 03

      if (grans[ind10[i]+1,k,m] eq 18B) then apidSeq[0,i,k,m]=530L ; first two bytes of 530 packet are 10 18

      if (grans[ind10[i]+1,k,m] eq 19B) then apidSeq[0,i,k,m]=531L ; first two bytes of 531 packet are 10 19

      apidSeq[1,i,k,m]=ind10[i]

    endfor

    ; handle last element
    
    if (ind10[num10-1] lt nele-1) then begin
    
      if (grans[ind10[num10-1]+1,k,m] eq 16B) then apidSeq[0,num10-1,k,m]=528L
      if (grans[ind10[num10-1]+1,k,m] eq 3B) then apidSeq[0,num10-1,k,m]=515L
      if (grans[ind10[num10-1]+1,k,m] eq 18B) then apidSeq[0,num10-1,k,m]=530L
      if (grans[ind10[num10-1]+1,k,m] eq 19B) then apidSeq[0,num10-1,k,m]=531L
    
    endif
    
    apidSeq[1,num10-1,k,m]=ind10[num10-1]


    ; this routine provides packet lengths and leaves non-APID 10s at zero
    ; a prev version was based on examining subsequent APIDs. This version proceeds by expected length, which requires a separate "if" per APID
    ; current logic allows skipping one or two APID headers randomly occuring in a data payload, but this is not robust 
    ;   to guarding against if a fragment of an APID is sent and the next APID happens to have a header in the payload
    ;    this will increase the number of APIDs counted. One mitigation is to increase array size
    for i=0,num10-4 do begin

      if (apidSeq[0,i,k,m] eq 528) then begin
        if ( ( (apidSeq[0,i+1,k,m] ne 0) and (apidSeq[1,i+1,k,m] eq apidSeq[1,i,k,m] + 62L) ) or $
          ( (apidSeq[0,i+2,k,m] ne 0) and (apidSeq[1,i+2,k,m] eq apidSeq[1,i,k,m] + 62L) ) or $
          ( (apidSeq[0,i+3,k,m] ne 0) and (apidSeq[1,i+3,k,m] eq apidSeq[1,i,k,m] + 62L) ) ) then apidSeq[2,i,k,m]=62L 
      endif

      if (apidSeq[0,i,k,m] eq 515) then begin
        if ( ( (apidSeq[0,i+1,k,m] ne 0) and (apidSeq[1,i+1,k,m] eq apidSeq[1,i,k,m] + 444L) ) or $
          ( (apidSeq[0,i+2,k,m] ne 0) and (apidSeq[1,i+2,k,m] eq apidSeq[1,i,k,m] + 444L) ) or $
          ( (apidSeq[0,i+3,k,m] ne 0) and (apidSeq[1,i+3,k,m] eq apidSeq[1,i,k,m] + 444L) ) ) then apidSeq[2,i,k,m]=444L
      endif

      if (apidSeq[0,i,k,m] eq 530) then begin
        if ( ( (apidSeq[0,i+1,k,m] ne 0) and (apidSeq[1,i+1,k,m] eq apidSeq[1,i,k,m] + 48L) ) or $
          ( (apidSeq[0,i+2,k,m] ne 0) and (apidSeq[1,i+2,k,m] eq apidSeq[1,i,k,m] + 48L) ) or $
          ( (apidSeq[0,i+3,k,m] ne 0) and (apidSeq[1,i+3,k,m] eq apidSeq[1,i,k,m] + 48L) ) ) then apidSeq[2,i,k,m]=48L
      endif

      if (apidSeq[0,i,k,m] eq 531) then begin
        if ( ( (apidSeq[0,i+1,k,m] ne 0) and (apidSeq[1,i+1,k,m] eq apidSeq[1,i,k,m] + 162L) ) or $
          ( (apidSeq[0,i+2,k,m] ne 0) and (apidSeq[1,i+2,k,m] eq apidSeq[1,i,k,m] + 162L) ) or $
          ( (apidSeq[0,i+3,k,m] ne 0) and (apidSeq[1,i+3,k,m] eq apidSeq[1,i,k,m] + 162L) ) ) then apidSeq[2,i,k,m]=162L
      endif

    endfor

    ; the logic for the last few array elements is imperfect but saves a few lines compared to above
    if (apidSeq[0,num10-3,k,m] ne 0) then begin
      if (apidSeq[0,num10-2,k,m] ne 0) then apidSeq[2,num10-3,k,m] = apidSeq[1,num10-2,k,m]-apidSeq[1,num10-3,k,m] else $
        if (apidSeq[0,num10-1,k,m] ne 0) then apidSeq[2,num10-3,k,m] = apidSeq[1,num10-1,k,m]-apidSeq[1,num10-3,k,m] else $
        apidSeq[2,num10-3,k,m] = nele - apidSeq[1,num10-3,k,m]
    endif

    if (apidSeq[0,num10-2,k,m] ne 0) then begin
      if (apidSeq[0,num10-1,k,m] ne 0) then apidSeq[2,num10-2,k,m] = apidSeq[1,num10-1,k,m]-apidSeq[1,num10-2,k,m] else $
        apidSeq[2,num10-2,k,m] = nele - apidSeq[1,num10-2,k,m]
    endif

    if (apidSeq[0,num10-1,k,m] ne 0) then apidSeq[2,num10-1,k,m] = nele - apidSeq[1,num10-1,k,m]


  endfor ;looop on granules

endfor ; loop on RDR files

; <end logic taken from RDR-info-3.pro


; now populate binary packet arrays, indexed by byte in packet, packet in granule, granule in RDR, and RDR

for m = 0, n_files - 1 do begin  ; loop over RDR files

  for k=0,14 do begin  ;this loops on granules
    
    ; pull out the index of apidSeq that contain the desired APID packets
    p528 = where((apidSeq[0,*,k,m] eq 528)and(apidSeq[2,*,k,m] eq 62)) ; array size 1248
    p515 = where((apidSeq[0,*,k,m] eq 515)and(apidSeq[2,*,k,m] eq 444)) ; array size 4
    p530 = where((apidSeq[0,*,k,m] eq 530)and(apidSeq[2,*,k,m] eq 48)) ; array size 12
    p531 = where((apidSeq[0,*,k,m] eq 531)and(apidSeq[2,*,k,m] eq 162)) ; array size 4

    ; we need this because sometimes the array sizes are short a packet
    n528 = n_elements(p528)
    n515 = n_elements(p515)
    n530 = n_elements(p530)
    n531 = n_elements(p531)
    
    ; populate binary packet arrays
    for i=0, n528-1 do packet528[0,i,k,m] = grans[apidSeq[1,p528[i],k,m]:apidSeq[1,p528[i],k,m]+61L,k,m]
    for i=0, n515-1 do packet515[0,i,k,m] = grans[apidSeq[1,p515[i],k,m]:apidSeq[1,p515[i],k,m]+443L,k,m]
    for i=0, n530-1 do packet530[0,i,k,m] = grans[apidSeq[1,p530[i],k,m]:apidSeq[1,p530[i],k,m]+47L,k,m]
    for i=0, n531-1 do packet531[0,i,k,m] = grans[apidSeq[1,p531[i],k,m]:apidSeq[1,p531[i],k,m]+161L,k,m]

    
    for i=0, n515-1 do begin  ; this loops on 515 packets per granule

      ; read the first 6B of the CCSDS header into the header array starting at byte 0
      header515[0,i,k,m]=packet515[0:5,i,k,m]

      ;read the next 2B of the CCSDS secondary header (days) as uint
      day515[0,i,k,m]=uint(packet515[6:7,i,k,m],0)

      ; read the next 4B of the CCSDS secondary header (milliseconds of the day) as ulong
      sec515[0,i,k,m]=ulong(packet515[8:11,i,k,m],0)

      ; read the next 2B of the CCSDS secondary header (microseconds of the millisecond) as uint
      msc515[0,i,k,m]=uint(packet515[12:13,i,k,m],0)
      
    endfor ; loop on 515
    
    for i=0, n528-1 do begin  ; this loops on 528 packets per granule

      ; read the first 6B of the CCSDS header into the header array starting at byte 0
      header528[0,i,k,m]=packet528[0:5,i,k,m]

      ;read the next 2B of the CCSDS secondary header (days) as uint
      day528[0,i,k,m]=uint(packet528[6:7,i,k,m],0)

      ; read the next 4B of the CCSDS secondary header (milliseconds of the day) as ulong
      sec528[0,i,k,m]=ulong(packet528[8:11,i,k,m],0)

      ; read the next 2B of the CCSDS secondary header (microseconds of the millisecond) as uint
      msc528[0,i,k,m]=uint(packet528[12:13,i,k,m],0)
      
      ; read the next 2B of the angle counts as uint
      angC[0,i,k,m]=uint(packet528[14:15,i,k,m],0)
      
      ; read the next 2B of the error flags
      errf[0,i,k,m]=packet528[16:17,i,k,m]
      
      ; read counts for 22 channels
      for j=0,21 do counts[j,i,k,m]= uint(packet528[18+2*j:19+2*j,i,k,m],0)
     
    endfor ;loop on packets

    
  endfor ;looop on granules
  
endfor ; loop on RDR files

; now reverse byte order of multi-byte numbers since IDPS is big endian
day515 = swap_endian(day515)
sec515 = swap_endian(sec515)
msc515 = swap_endian(msc515)
day528 = swap_endian(day528)
sec528 = swap_endian(sec528)
msc528 = swap_endian(msc528)
angC = swap_endian(angC)
counts = swap_endian(counts)

; vectorized conversion of angle counts to degrees
ang = 5.493e-3*angC

;vectorized conversion of day and msec to fractional day
day0 = day528[0]
daysec = (day528 - day0)+ (sec528/8.64e7)

; remove zeroes from daysec
;nz = daysec[where(daysec ne 0.0)]



; print elapsed time
t = toc(clock_id)
print, t, format='(%"time: %0.6f sec")'

print, 'all done'
;print, day


PlotCountsATMS

end