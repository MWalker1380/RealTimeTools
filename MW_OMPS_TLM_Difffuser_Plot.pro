;Mike Walker

function mechPlot1
  COMMON filePick, files
  file = files
  
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  
  x1=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y1=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 928, 2, header)
  p1=plotVsTime( x1, y1, 'Nadir Diffuser Move Destination', 'Time (Seconds Elapsed)', 'Position')
END

function mechPlot2
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x2=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y2=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 938, 2, header)
  p2=plotVsTime( x2, y2, 'Nadir Diffuser Motor Position', 'Time (Seconds Elapsed)', 'Step Counts')
END

function mechPlot3
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x3=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y3=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 940, 1, header)
  p3=plotVsTime( x3, y3, 'Nadir Diffuser Position ID', 'Time (Seconds Elapsed)', 'Position')
END

function mechPlot4
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x4=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y4=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 950, 2, header)
  p4=plotVsTime( x4, y4, 'Limb Diffuser Move Destination', 'Time (Seconds Elapsed)', 'Position')
END

function mechPlot5
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x5=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y5=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 960, 2, header)
  p5=plotVsTime( x5, y5, 'Limb Diffuser Motor Position', 'Time (Seconds Elapsed)', 'Step Counts')
END

function mechPlot6
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  x6=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y6=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 962, 1, header)
  p6=plotVsTime( x6, y6, 'Limb Diffuser Position ID', 'Time (Seconds Elapsed)', 'Position')
END