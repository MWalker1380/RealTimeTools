;Mike Walker

function mechPlot1
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files
  
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  
  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 928, 2, header)
  p1=plotVsTime( times, values, 'Nadir Diffuser Move Destination', 'Time (Seconds Elapsed)', 'Position')
END

function mechPlot2
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 938, 2, header)
  p2=plotVsTime( times, values, 'Nadir Diffuser Motor Position', 'Time (Seconds Elapsed)', 'Step Counts')
END

function mechPlot3
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 940, 1, header)
  p3=plotVsTime( times, values, 'Nadir Diffuser Position ID', 'Time (Seconds Elapsed)', 'Position')
END

function mechPlot4
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 950, 2, header)
  p4=plotVsTime( times, values, 'Limb Diffuser Move Destination', 'Time (Seconds Elapsed)', 'Position')
END

function mechPlot5
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 960, 2, header)
  p5=plotVsTime( times, values, 'Limb Diffuser Motor Position', 'Time (Seconds Elapsed)', 'Step Counts')
END

function mechPlot6
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 962, 1, header)
  p6=plotVsTime( times, values, 'Limb Diffuser Position ID', 'Time (Seconds Elapsed)', 'Position')
END