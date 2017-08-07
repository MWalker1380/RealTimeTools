PRO file_select, event
  COMMON filePick, files
  
  dir = dialog_pickfile(TITLE="Choose h5 directory", /DIRECTORY)
  files = file_search(filepath('*.h5', root=dir))
  files = files(sort(files)) ; sorting the files sorts them based on start time in ascending order, so that our plots and text boxes will be correct
END

function clearPlots
  COMMON Plotter, np, epoch
  COMMON draw, draw
  IF (np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  np = 1
END

PRO pback_event, event
  COMMON Plotter, np, epoch
  COMMON filePick, files
  COMMON draw, draw
  COMMON speed, speed
  COMMON times, times
  COMMON values, values
  COMMON cycle, cycle

  case event.INDEX of
    0 : speed = -1
    1 : speed = 1
    2 : speed = 2
    3 : speed = 3
    4 : speed = 4
    5 : speed = 5
  endcase

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  c = clearPlots()
  cycle = 0
  playing
END

PRO tlm_event, event
  COMMON Plot, handles
  COMMON draw, draw
  COMMON filePick, files
  IF (handles.np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  
  case event.INDEX of
    0 : t=mechPlot1(handles.epoch)
    1 : t=mechPlot2(handles.epoch)
    2 : t=mechPlot3(handles.epoch)
    3 : t=mechPlot4(handles.epoch)
    4 : t=mechPlot5(handles.epoch)
    5 : t=mechPlot6(handles.epoch)
    6 : t=powerPlot1(handles.epoch)
    7 : t=powerPlot2(handles.epoch)
    8 : t=currentPlot1(handles.epoch)
    9 : t=currentPlot2(handles.epoch)
    10 : t=currentPlot3(handles.epoch)
    11 : t=currentPlot4(handles.epoch)
    12 : t=voltagePlot1(handles.epoch)
  endcase
    
  ; transform the variable t, which is the newest time being plotted in days since NASA epoch
  ; to an actual caendar date by adding the NASA epoch in days since julian time epoch to t
  caldat, Double(t), Month, Day, Year, Hour, Minute, Second
  ; date mm-dd-yyyy. use strcompress to remove whitespaces
  date = strcompress( string(Month)+'/'+string(Day)+'/'+string(year), /REMOVE_ALL) ; /REMOVE_ALL specifies to remove all spaces, not just one  
  ; time HH:MM:SS. Must take out fractions from Sec for displaying with uint
  time = strcompress(string(Hour)+':'+string(Minute)+':'+string(uint(Second)))  

  WIDGET_CONTROL, handles.date, SET_VAL='Date: '+date ; make the date appear in the listbx
  WIDGET_CONTROL, handles.time, SET_VAL='Time: '+time ; make the time appear in the listbox
  
  blah = pop_omps_tlm_boxes(handles, files) ; populate text box values. See below. return blah so IDL wont yell about a syntax error. blah is unused

  handles.np = 1
END

PRO sci_event, event
  COMMON Plot, handles
  COMMON draw, draw
  COMMON filePick, files

  
  IF (handles.np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  
  case event.INDEX of
    0 : t=versionPlot(handles.epoch)
    1 : t=contPlot(handles.epoch)
  endcase
  
  ; transform the variable t, which is the newest time being plotted in days since NASA epoch 
  ; to an actual caendar date by adding the NASA epoch in days since julian time epoch to t
  caldat, Double(t), Month, Day, Year, Hour, Minute, Second
  date = strcompress( string(Month)+'/'+string(Day)+'/'+string(year), /REMOVE_ALL) ; /REMOVE_ALL specifies to remove all spaces, not just one  
  ; time HH:MM:SS. Must take out fractions from Sec for displaying with uint
  time = strcompress(string(Hour)+':'+string(Minute)+':'+string(uint(Second)))  

  WIDGET_CONTROL, handles.date, SET_VAL='Date: '+date ; make the date appear in the listbx
  WIDGET_CONTROL, handles.time, SET_VAL='Time: '+time ; make the time appear in the listbox
  blah = pop_omps_tlm_boxes(handles, files) ; populate text box values. See below. return blah so IDL wont yell about a syntax error. blah is unused

  handles.np = 1
END

function pop_omps_tlm_boxes, handles, files_tmp
  ; Populate text boxes with useule omps telemetry points
  
  
    files =  files_tmp[where(files_tmp.IndexOf('RNSCA') gt -1)] ; only take science files

    file = files[-1] ; take the last file. They are sorted, so this will be the newest. All of these tlm points populate a text box so we want one point, not a vector
    
    ; *******************
    ; Many of these parameters specify S16, but they are only correct when I read them in as U16. Why? I do not know
    ; ********************
    
    ;;;;;;;;; OMPS Instrument TELEMTRY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; dummy header for function
    header = MAKE_ARRAY(2, /BYTE)
    header[0]=10
    header[1]=49
    
    maxgran = 0 ; index of maximum granule to decom. In this case theres just one (i=0
    byteSize = 2 ; 16 bit signed int = 2 byte signed int
    
    indexInPacket = 141 ; index in packet in bytes. From OMPS xml database
    nadirProfTemp = getParam(file,'OMPS-NPSCIENCE-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    nadirProfTemp=nadirProfTemp[-1]; get single newest point
    
    indexInPacket = 143 ; index in packet in bytes. From OMPS xml database
    nadirTCTemp = getParam(file,'OMPS-NPSCIENCE-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    nadirTCTemp=nadirTCTemp[-1] ; get single newest point

    
    indexInPacket = 131 ; index in packet in bytes. From OMPS xml database
    npHtrPwr = getParam(file,'OMPS-NPSCIENCE-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    npHtrPwr=npHtrPwr[-1] ; get single newest point   
      
    indexInPacket = 137 ; index in packet in bytes. From OMPS xml database
    tcHtrPwr = getParam(file,'OMPS-NPSCIENCE-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    tcHtrPwr=tcHtrPwr[-1] ; get single newest point
    indexInPacket = 111  ; index in packet in bytes. From OMPS xml database
    sbcBrdTemp = getParam(file,'OMPS-NPSCIENCE-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    sbcBrdTemp = sbcBrdTemp[-1] ; get single newest point. 
       
    indexInPacket = 99 ; index in packet in bytes. From OMPS xml database
    ledCurr = getParam(file,'OMPS-NPSCIENCE-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    ledCurr = ledCurr[-1] ; get single newest point. I will use this as an index below
    

    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OMPS HK (APID 544) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    files =  files_tmp[where(files_tmp.IndexOf('ROLPT') gt -1)] ; only take HK files

    file = files[-1] ; take the last file. They are sorted, so this will be the newest. All of these tlm points populate a text box so we want one point, not a vector

    
    header[0]=10
    header[1]=32 
    
    bytesize = 2
    
    indexInPacket = 626 ; index in packet in bytes. From OMPS xml database
    tecCurr = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='UINT') ; get the newest points
    tecCurr = tecCurr[-1] ; get single newest point

    indexInPacket = 30 ; index in packet in bytes. From OMPS xml database
    byteSize = 1 ; This one is only one byte
    modeI = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='BYTE') ; get the newest points
    modeI = modeI[-1] ; get single newest point
    
    
    indexInPacket = 202 ; index in packet in bytes. From OMPS xml database
    byteSize = 1D/8D ; Single bit
    ccdStatusI = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='BYTE') ; get the newest points
    ccdStatusI = ccdStatusI[-1] ; get single newest point

    indexInPacket = 305 ; index in packet in bytes. From OMPS xml database
    lCcdStatusI = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='BYTE') ; get the newest points
    lCcdStatusI = lCcdStatusI[-1] ; get single newest point
    
    indexInPacket = 930D + 3D/8D ; index in packet in bytes. From OMPS xml database
    lTecI = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='BYTE') ; get the newest points
    lTecI = lTecI[-1] ; get single newest point
    
    indexInPacket = 930D + 4D/8D ; index in packet in bytes. From OMPS xml database
    nTecI = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='BYTE') ; get the newest points
    nTecI = nTecI[-1] ; get single newest point
    
    indexInPacket = 930D + 5D/8D ; index in packet in bytes. From OMPS xml database
    tcTecI = getParam(file,'OMPS-TELEMETRY-RDR_All', maxgran , indexInPacket, byteSize, header, type='BYTE') ; get the newest points
    tcTecI = tcTecI[-1] ; get single newest point
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GUI update ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    deg = '°' ;ASCII degree symbol. IDL appends an Angstrom to the front for some reaseon, sao take that out
    
    modeArr = ['OTHER', 'BOOT', 'SAFE_HOLD' , 'DECON' ,'OPERATE'] ; THis will be used to check the OMPS mode since the actual value is of {0,1}, not {A,B}
    statusArr = ['OFF', 'ON']
    ; enArr = ['DISABLED', 'ENABLED']
    
    ; Add the (calibrated) perecptive parameters. The coefficients are hard-coded here, but they can be accessed from the databases in a future implementation
    
    ; TELEM
    WIDGET_CONTROL, handles.nProfTxt, SET_VAL='NP CCD T: '+strcompress(string(float((58.05D) - (0.0238D)*double(nadirProfTemp))),/REMOVE_ALL)+' ' + deg.substring(1)+'C'
    WIDGET_CONTROL, handles.nTCTxt, SET_VAL='TC CCD T: '+strcompress(string(float((58.05D)-(0.0238D)*double(nadirTCTemp))), /REMOVE_ALL)+' ' + deg.substring(1)+'C'
    WIDGET_CONTROL, handles.npPwrTxt, SET_VAL='NP Htr Pwr: '+strcompress(string(float( (0.0000000576D)*double(npHtrPwr)^2)), /REMOVE_ALL)+' W'
    WIDGET_CONTROL, handles.tcPwrTxt, SET_VAL='TC Htr Pwr: '+strcompress(string(float( (0.0000000576D)*double(tcHtrPwr)^2)), /REMOVE_ALL)+' W'
    WIDGET_CONTROL, handles.ledCurrTxt, SET_VAL='Cal LED Current: '+strcompress(string(float( (0.006125D)*double(ledCurr))), /REMOVE_ALL)+' mA'
    
    ; HK
    WIDGET_CONTROL, handles.tecTxt, SET_VAL='TEC Current: '+strcompress(string(round( (0.00123D)*double(tecCurr))), /REMOVE_ALL)+' A'
    WIDGET_CONTROL, handles.modeTxt, SET_VAL='OMPS Mode: '+ modeArr[modeI]
    WIDGET_CONTROL, handles.ccdStatusTxt, SET_VAL='Nadir CCD Pwr: '+ statusArr[ccdStatusI]
    WIDGET_CONTROL, handles.lCcdStatusTxt, SET_VAL='Limb CCD Pwr: '+ statusArr[lCcdStatusI]
    WIDGET_CONTROL, handles.lTecTxt, SET_VAL='Limb TEC Pwr: '+ statusArr[lTecI]
    WIDGET_CONTROL, handles.nTecTxt, SET_VAL='Nadir TEC Pwr: '+ statusArr[nTecI]
    WIDGET_CONTROL, handles.tcTecTxt, SET_VAL='TC TEC Pwr: '+ statusArr[tcTecI]

    
    
end

PRO MW_Window, GROUP=GROUP, BLOCK=block
  COMMON Plot, handles
  COMMON Plotter, np, epoch
  COMMON clearer, graphicWin
  COMMON draw, draw
  IF N_ELEMENTS(block) EQ 0 THEN block=0
 
  Window = WIDGET_BASE(TITLE = "OMPS TLM Panel",/column)
  
  Main = WIDGET_BASE(Window, TITLE = "ATMS Channel Counts",/row, /ALIGN_CENTER)
  
  Left = WIDGET_BASE(Main, TITLE = "Left",/column, /ALIGN_TOP)
 
  Right = WIDGET_BASE(Main, TITLE = "Right",/column, /ALIGN_CENTER)
  
  Datetime = WIDGET_BASE(Left, TITLE = "Right",/row, /ALIGN_CENTER)
    dateTxt = WIDGET_TEXT(DateTime, VALUE='Date:', SCR_XSIZE=250)
    timeTxt = WIDGET_TEXT(DateTime, VALUE='Time:', SCR_XSIZE=250)
  
  SelectStatus = WIDGET_BASE(Left, TITLE = "Right",/row, /ALIGN_Left)
  
  Select = WIDGET_BASE(SelectStatus, TITLE = "Right",/column)
    modeTxt = WIDGET_TEXT(Select, VALUE='OMPS Mode', SCR_XSIZE=250)
    ccdStatusTxt = WIDGET_TEXT(Select, VALUE='Nadir CCD Pwr', SCR_XSIZE=250)
    lCcdStatusTxt = WIDGET_TEXT(Select, VALUE='Limb CCD Pwr', SCR_XSIZE=250)
    lTecTxt = WIDGET_TEXT(Select, VALUE='Limb TEC Pwr  ', SCR_XSIZE=250)
    nTecTxt = WIDGET_TEXT(Select, VALUE='Nadir TEC Pwr ', SCR_XSIZE=250)
    tcTecTxt = WIDGET_TEXT(Select, VALUE='TC TEC Pwr ', SCR_XSIZE=250)

  Status = WIDGET_BASE(SelectStatus, TITLE = "Right",/column)
    npPwrTxt = WIDGET_TEXT(Status, VALUE='NP Htr Pwr', SCR_XSIZE=250)
    tcPwrTxt = WIDGET_TEXT(Status, VALUE='TC Htr Pwr', SCR_XSIZE=250)
    nProfTxt = WIDGET_TEXT(Status, VALUE='NP CCD T', SCR_XSIZE=250)
    nTCTxt = WIDGET_TEXT(Status, VALUE='TC CCD T', SCR_XSIZE=250)
    tecTxt = WIDGET_TEXT(Status, VALUE='TEC Current', SCR_XSIZE=250)

    ledCurrTxt = WIDGET_TEXT(Status, VALUE='Cal LED Current', SCR_XSIZE=250)
    
  ;Slide = WIDGET_BASE(Left, TITLE = "Right",/column)
   ; label = WIDGET_LABEL(Slide, VALUE='Position Sliders')
   ; slide1 = WIDGET_SLIDER(Slide, SCR_XSIZE=288)
    
  Plot = WIDGET_BASE(Right, TITLE = "Right",/column)
    draw = WIDGET_WINDOW(Plot, xsize=800, ysize=500)
    
  CalPar = WIDGET_BASE(Right, TITLE = "Right",/row, /ALIGN_CENTER)
  
  Cal = WIDGET_BASE(CalPar, TITLE = "Right",/column)
    label = WIDGET_LABEL(Cal, VALUE='Data Type')
    button_labels = ['Raw', 'Calibrated']
    buttons = CW_BGROUP(Cal, button_labels, /exclusive, /COLUMN, /FRAME, /RETURN_index, /NO_RELEASE)
    
  Tlm = WIDGET_BASE(CalPar, TITLE = "Right",/column)
    label = WIDGET_LABEL(Tlm, VALUE='Telemetry')
    tlm_labels = ['Diffuser Mech - Nadir Diffuser Move Destination', 'Diffuser Mech - Nadir Diffuser Motor Position',$
      'Diffuser Mech - Nadir Diffuser Position ID', 'Diffuser Mech - Limb Diffuser Move Destination', 'Diffuser Mech - Limb Diffuser Motor Position'$
      , 'Diffuser Mech - Limb Diffuser Position ID', 'Power - Nadir CCD Power Status', 'Power - Limb CCD Power Status',$
      'Current - Nadir Phase A Motor Drive Current', 'Current - Nadir Phase B Motor Drive Current', 'Current - Limb Phase A Motor Drive Current',$
      'Current - Limb Phase B Motor Drive Current', 'Voltage-Resolver Electronics + 12V']
    drop = WIDGET_DROPLIST(Tlm, VALUE=tlm_labels)
  
  Sci = WIDGET_BASE(CalPar, TITLE = "Right",/column)
    label = WIDGET_LABEL(Sci, VALUE='Science')
    sci_labels = ['Sci Test - RDR Version', 'Cont']
    drop = WIDGET_DROPLIST(Sci, VALUE=sci_labels)
 
  selectFile=WIDGET_BUTTON(CalPar, VALUE='Select RDR Files')
  
  Playback = WIDGET_BASE(CalPar, TITLE = "Playback",/column)
    label = WIDGET_LABEL(Playback, VALUE='Playback')
    pback_labels = ['None', '1X', '2X', '3X', '4X', '5X']
    drop = WIDGET_DROPLIST(Playback, VALUE=pback_labels)

  np=0

 ; This line converts the NASA epoch of 01-01-1958 to days since the epoch of the julian calendar
 ; It seems that IDL uses inclusive ranges (maybe?), as an extra day needs to be removed for the date to be correct
  epoch = double(julday(01, 01, 1958) - 1) 

  ; create a struct to handle all of the widget IDs and other values if an object needs to be changed
  handles = create_struct('date', dateTxt, 'time', timeTxt, $
    'npPwrTxt', npPwrTxt, 'tcPwrTxt', tcPwrTxt, 'nProfTxt', nProfTxt, 'lCcdStatusTxt',lCcdStatusTxt , $
    'np', np, 'epoch', epoch, 'modeTxt', modeTxt, 'nTCTxt', nTCTxt, $
    'ledCurrTxt', ledCurrTxt, 'lTecTxt', lTecTxt, 'nTecTxt', nTecTxt, $
    'tcTecTxt', tcTecTxt, 'tecTxt', tecTxt, 'ccdStatusTxt', ccdStatusTxt)

  WIDGET_CONTROL, Window, /REALIZE
  XMANAGER, 'MW_Window', Plot, /NO_BLOCK
  WIDGET_CONTROL, draw, GET_VALUE = graphicWin
  graphicWin.SELECT
  
  np = 0
  
  XManager, "MW_Window", Tlm, EVENT_HANDLER = "tlm_event", /no_block
  XManager, "MW_Window", Sci, EVENT_HANDLER = "sci_event", /no_block
  XManager, "MW_Window", Playback, EVENT_HANDLER = "pback_event", /no_block
  XManager, "MW_Window", selectFile, EVENT_HANDLER = "file_select", /no_block
end

PRO playing, id, userData
  ;Common Parameters
  COMMON Plotter, np, epoch
  COMMON draw, draw
  COMMON speed, speed
  COMMON times, times
  COMMON values, values
  COMMON cycle, cycle
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel

  ;Start plotting if a speed has been selected
  if speed ne -1 then begin
    COMPILE_OPT IDL2
    ;Clear existing plots
    c = clearPlots()
    ;Plot given set of value and their times, depending on which iteration of the data set (cycle)
    p1=plotVsTime( times[0:cycle], values[0:cycle], mainLabel, xLabel)
    ;Increase cycle for next call
    cycle++
    ;If not yet through all values, call another plot in 5/speed seconds
    if cycle lt times.LENGTH then id = Timer.Set(5/speed, 'playing')
  end
END

;3431543