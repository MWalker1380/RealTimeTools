;Mike Walker

function mechPlot1, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files
  
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 928, 2, header)
  p1=plotVsTime( times, values, 'Nadir Diffuser Move Destination', 'Position')
  return, x1[-1] ;return the last element in the time vector for the date and time box in the OMPS GUIv
END

function mechPlot2, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 938, 2, header)
  p2=plotVsTime( times, values, 'Nadir Diffuser Motor Position', 'Step Counts')
  return, x2[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI

END

function mechPlot3, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 940, 1, header) 
  p3=plotVsTime( times, values, 'Nadir Diffuser Position ID', 'Position ID')
  return, x3[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot4, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 950, 2, header)
  p4=plotVsTime( times, values, 'Limb Diffuser Move Destination', 'Position ID')
  return, x4[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot5, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 960, 2, header)
  p5=plotVsTime( times, values, 'Limb Diffuser Motor Position', 'Step Counts')
  return, x5[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function mechPlot6, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 962, 1, header)
  p6=plotVsTime( times, values, 'Limb Diffuser Position ID', 'Position')
  return, x6[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END