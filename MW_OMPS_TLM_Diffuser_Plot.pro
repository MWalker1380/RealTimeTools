;Mike Walker

function mechPlot1, epoch
  COMMON filePick, files
  file = files
  
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  
  x1=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y1=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 928, 2, header)
  p1=plotVsTime( x1, y1, 'Nadir Diffuser Move Destination', 'Position')
  return, x1[-1] ;return the last element in the time vector for the date and time box in the OMPS GUIv
END

function mechPlot2, epoch
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x2=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y2=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 938, 2, header)
  p2=plotVsTime( x2, y2, 'Nadir Diffuser Motor Position', 'Step Counts')
  return, x2[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot3, epoch
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x3=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y3=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 940, 1, header) 
  p3=plotVsTime( x3, y3, 'Nadir Diffuser Position ID', 'Position ID')
  return, x3[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot4, epoch
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x4=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y4=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 950, 2, header)
  p4=plotVsTime( x4, y4, 'Limb Diffuser Move Destination', 'Position ID')
  return, x4[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot5, epoch
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x5=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y5=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 960, 2, header)
  p5=plotVsTime( x5, y5, 'Limb Diffuser Motor Position', 'Step Counts')
  return, x5[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot6, epoch
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x6=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y6=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 962, 1, header)
  p6=plotVsTime( x6, y6, 'Limb Diffuser Position ID', 'Position')
  return, x6[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END