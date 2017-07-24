PRO file_select, event
  COMMON filePick, files
  files = dialog_pickfile(/multiple_files)
END

PRO tlm_event, event
  COMMON Plot, handles
  COMMON draw, draw
  IF (handles.np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  
  case event.INDEX of
    0 : t=mechPlot1()
    1 : t=mechPlot2()
    2 : t=mechPlot3()
    3 : t=mechPlot4()
    4 : t=mechPlot5()
    5 : t=mechPlot6()
    6 : t=powerPlot1()
    7 : t=powerPlot2()
    8 : t=currentPlot1()
    9 : t=currentPlot2()
    10 : t=currentPlot3()
    11 : t=currentPlot4()
  endcase
    
  ; transform the variable t, which is the newest time being plotted in days since NASA epoch
  ; to an actual caendar date by adding the NASA epoch in days since julian time epoch to t
  caldat, Double(t+handles.epoch), Month, Day, Year, Hour, Minute, Second
  ; date mm-dd-yyyy. use strcompress to remove whitespaces
  date = strcompress( string(Month)+'/'+string(Day)+'/'+string(year), /REMOVE_ALL) ; /REMOVE_ALL specifies to remove all spaces, not just one  
  ; time HH:MM:SS. Must take out fractions from Sec for displaying with uint
  time = strcompress(string(Hour)+':'+string(Minute)+':'+string(uint(Second)))  

  WIDGET_CONTROL, handles.date, SET_VAL='Date: '+date ; make the date appear in the listbx
  WIDGET_CONTROL, handles.time, SET_VAL='Time: '+time ; make the time appear in the listbox
  
  
  handles.np = 1
END

PRO sci_event, event
  COMMON Plot, handles
  COMMON draw, draw
  
  IF (handles.np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  
  case event.INDEX of
    0 : t=versionPlot()
    1 : t=contPlot()
  endcase
  
  ; transform the variable t, which is the newest time being plotted in days since NASA epoch 
  ; to an actual caendar date by adding the NASA epoch in days since julian time epoch to t
  caldat, Double(t+handles.epoch), Month, Day, Year, Hour, Minute, Second
  date = strcompress( string(Month)+'/'+string(Day)+'/'+string(year), /REMOVE_ALL) ; /REMOVE_ALL specifies to remove all spaces, not just one  
  ; time HH:MM:SS. Must take out fractions from Sec for displaying with uint
  time = strcompress(string(Hour)+':'+string(Minute)+':'+string(uint(Second)))  

  WIDGET_CONTROL, handles.date, SET_VAL='Date: '+date ; make the date appear in the listbx
  WIDGET_CONTROL, handles.time, SET_VAL='Time: '+time ; make the time appear in the listbox
  
  handles.np = 1
END

PRO MW_Window, GROUP=GROUP, BLOCK=block
  COMMON Plot, handles
  COMMON clearer, graphicWin
  COMMON draw, draw
  IF N_ELEMENTS(block) EQ 0 THEN block=0
  Window = WIDGET_BASE(TITLE = "OMPS TLM Panel",/column)
  Main = WIDGET_BASE(Window, TITLE = "ATMS Channel Counts",/row, /ALIGN_CENTER)
  Left = WIDGET_BASE(Main, TITLE = "Left",/column, /ALIGN_CENTER)
  Right = WIDGET_BASE(Main, TITLE = "Right",/column, /ALIGN_CENTER)
  Datetime = WIDGET_BASE(Left, TITLE = "Right",/row, /ALIGN_CENTER)
    scidTxt = WIDGET_TEXT(DateTime, VALUE='SC ID:', SCR_XSIZE=96)
    dateTxt = WIDGET_TEXT(DateTime, VALUE='Date:', SCR_XSIZE=96)
    timeTxt = WIDGET_TEXT(DateTime, VALUE='Time:', SCR_XSIZE=96)
  SelectStatus = WIDGET_BASE(Left, TITLE = "Right",/row, /ALIGN_CENTER)
  Select = WIDGET_BASE(SelectStatus, TITLE = "Right",/column)
    button_labels = ['MEB A On', 'MEB B On', 'Nadir Prof On', 'Nadir TC On', 'Limb On', 'CAL MECH On', 'TEC On', 'Side A On']
    buttons = CW_BGROUP(Select, button_labels, /exclusive, /COLUMN, /FRAME, /RETURN_index, /NO_RELEASE)
  Status = WIDGET_BASE(SelectStatus, TITLE = "Right",/column)
    ompsCurrTxt = WIDGET_TEXT(Status, VALUE='OMPS Current')
    tecCurrTxt = WIDGET_TEXT(Status, VALUE='TEC Current')
    mebTempTxt = WIDGET_TEXT(Status, VALUE='MEB Temp')
    nadirTempTxt = WIDGET_TEXT(Status, VALUE='Nadir Temp')
    limbCurrTxt = WIDGET_TEXT(Status, VALUE='Limb Current')
    label = WIDGET_TEXT(Status, VALUE='...')
  Slide = WIDGET_BASE(Left, TITLE = "Right",/column)
    label = WIDGET_LABEL(Slide, VALUE='Position Sliders')
    slide1 = WIDGET_SLIDER(Slide, SCR_XSIZE=288)
    slide2 = WIDGET_SLIDER(Slide, SCR_XSIZE=288)
  Plot = WIDGET_BASE(Right, TITLE = "Right",/column)
    draw = WIDGET_WINDOW(Plot, xsize=850, ysize=550)
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
      'Current - Limb Phase B Motor Drive Current']
    drop = WIDGET_DROPLIST(Tlm, VALUE=tlm_labels)
  Sci = WIDGET_BASE(CalPar, TITLE = "Right",/column)
    label = WIDGET_LABEL(Sci, VALUE='Science')
    sci_labels = ['Sci Test - RDR Version', 'Cont']
    drop = WIDGET_DROPLIST(Sci, VALUE=sci_labels)
  selectFile=WIDGET_BUTTON(CalPar, VALUE='Select RDR Files')
  Playback = WIDGET_BASE(CalPar, TITLE = "Playback",/column)
    label = WIDGET_LABEL(Playback, VALUE='Playback')
    pback_labels = ['None', '1X', '2X', '5X', '10X', '20X', '50X', '100X']
    drop = WIDGET_DROPLIST(Playback, VALUE=pback_labels)

  np=0

  epoch = julday(01, 01, 1958) ; This line converts the NASA epoch of 01-01-1958 to days since the epoch of the julian calendar

  ; create a struct to handle all of the widget IDs and other values if an object needs to be changed
  handles = create_struct('scid', scidTxt, 'date', dateTxt, 'time', timeTxt, 'limbCurr', limbCurrTxt, $
    'ompsCurr', ompsCurrTxt, 'tecCurr', tecCurrTxt,'mebTemp', mebTempTxt, 'nadirTemp',  nadirTempTxt, $
    'np', np, 'epoch', epoch  )

  WIDGET_CONTROL, Window, /REALIZE
  XMANAGER, 'MW_Window', Plot, /NO_BLOCK
  WIDGET_CONTROL, draw, GET_VALUE = graphicWin
  graphicWin.SELECT
  
  
  XManager, "MW_Window", Tlm, EVENT_HANDLER = "tlm_event", /no_block
  XManager, "MW_Window", Sci, EVENT_HANDLER = "sci_event", /no_block
  XManager, "MW_Window", selectFile, EVENT_HANDLER = "file_select", /no_block
end
