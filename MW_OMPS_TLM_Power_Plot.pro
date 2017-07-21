;Mike Walker

;Launch plots for Power -----
; APID 
function powerPlot1
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32
  
  number_grans = 0

  x1=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y1=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 193, 1, header)
  p1=plotVsTime( x1, y1, 'Nadir CCD Power Status', 'Time (Seconds Elapsed)', 'Power')
END

function powerPlot2
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32

  number_grans = 0

  x2=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y2=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 300, 1, header)
  p2=plotVsTime( x2, y2, 'Limb CCD Power Status', 'Time (Seconds Elapsed)', 'Power')
END