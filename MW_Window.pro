PRO file_select, event
  COMMON filePick, files
  files = dialog_pickfile(/multiple_files)
END

PRO tlm_event, event
  COMMON Plot, np, epoch
  COMMON draw, draw
  IF (np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  
  case event.INDEX of
    0 : p=mechPlot1()
    1 : p=mechPlot2()
    2 : p=mechPlot3()
    3 : p=mechPlot4()
    4 : p=mechPlot5()
    5 : p=mechPlot6()
    6 : p=powerPlot1()
    7 : p=powerPlot2()
    8 : p=currentPlot1()
    9 : p=currentPlot2()
    10 : p=currentPlot3()
    11 : p=currentPlot4()
  endcase
  np = 1
END

PRO sci_event, event
  COMMON Plot, np, epoch
  COMMON draw, draw
  IF (np eq 1) THEN BEGIN
    COMMON clearer, graphicWin
    graphicWin.ERASE
  END
  IF (event.INDEX EQ 0) THEN p=versionPlot()
  IF (event.INDEX EQ 1) THEN p=contPlot()
  np = 1
END

PRO MW_Window, GROUP=GROUP, BLOCK=block
  COMMON Plot, np, epoch
  COMMON clearer, graphicWin
  COMMON draw, draw
  IF N_ELEMENTS(block) EQ 0 THEN block=0
  Window = WIDGET_BASE(TITLE = "OMPS TLM Panel",/column)
  Main = WIDGET_BASE(Window, TITLE = "ATMS Channel Counts",/row, /ALIGN_CENTER)
  Left = WIDGET_BASE(Main, TITLE = "Left",/column, /ALIGN_CENTER)
  Right = WIDGET_BASE(Main, TITLE = "Right",/column, /ALIGN_CENTER)
  Datetime = WIDGET_BASE(Left, TITLE = "Right",/row, /ALIGN_CENTER)
    label = WIDGET_TEXT(DateTime, VALUE='SC ID:', SCR_XSIZE=96)
    label = WIDGET_TEXT(DateTime, VALUE='Date:', SCR_XSIZE=96)
    label = WIDGET_TEXT(DateTime, VALUE='Time:', SCR_XSIZE=96)
  SelectStatus = WIDGET_BASE(Left, TITLE = "Right",/row, /ALIGN_CENTER)
  Select = WIDGET_BASE(SelectStatus, TITLE = "Right",/column)
    button_labels = ['MEB A On', 'MEB B On', 'Nadir Prof On', 'Nadir TC On', 'Limb On', 'CAL MECH On', 'TEC On', 'Side A On']
    buttons = CW_BGROUP(Select, button_labels, /exclusive, /COLUMN, /FRAME, /RETURN_index, /NO_RELEASE)
  Status = WIDGET_BASE(SelectStatus, TITLE = "Right",/column)
    label = WIDGET_TEXT(Status, VALUE='OMPS Current')
    label = WIDGET_TEXT(Status, VALUE='TEC Current')
    label = WIDGET_TEXT(Status, VALUE='MEB Temp')
    label = WIDGET_TEXT(Status, VALUE='Nadir Temp')
    label = WIDGET_TEXT(Status, VALUE='Limb Current')
    label = WIDGET_TEXT(Status, VALUE='...')
  Slide = WIDGET_BASE(Left, TITLE = "Right",/column)
    label = WIDGET_LABEL(Slide, VALUE='Position Sliders')
    slide1 = WIDGET_SLIDER(Slide, SCR_XSIZE=288)
    slide2 = WIDGET_SLIDER(Slide, SCR_XSIZE=288)
  Plot = WIDGET_BASE(Right, TITLE = "Right",/column)
    draw = WIDGET_WINDOW(Plot, xsize=850, ysize=500)
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

  WIDGET_CONTROL, Window, /REALIZE
  XMANAGER, 'MW_Window', Plot, /NO_BLOCK
  WIDGET_CONTROL, draw, GET_VALUE = graphicWin
  graphicWin.SELECT
  
  np=0
  
  epoch = julday(01, 01, 1958) ; This line converts the NASA epoch of 01-01-1958 to days since the epoch of the julian calendar 
  
  XManager, "MW_Window", Tlm, EVENT_HANDLER = "tlm_event", /no_block
  XManager, "MW_Window", Sci, EVENT_HANDLER = "sci_event", /no_block
  XManager, "MW_Window", selectFile, EVENT_HANDLER = "file_select", /no_block
end
