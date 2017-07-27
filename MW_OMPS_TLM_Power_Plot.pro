;Mike Walker

;Launch plots for Power -----
; APID 
function powerPlot1
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32
  
  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 193, 1, header)
  p1=plotVsTime( times, values, 'Nadir CCD Power Status', 'Time (Seconds Elapsed)', 'Power')
END

function powerPlot2
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 300, 1, header)
  p2=plotVsTime( times, values, 'Limb CCD Power Status', 'Time (Seconds Elapsed)', 'Power')
END