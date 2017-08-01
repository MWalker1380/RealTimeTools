;Mike Walker

;Launch plots for Power -----
; APID 
function powerPlot1, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32
  
  number_grans = 0


  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch ; add epoch to convert to IDL's epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 193, 1, header)
  p2 = plotVsTime(times, values, 'Nadir CCD Power Status', 'Power')
  return, x1[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function powerPlot2, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files
  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 300, 1, header)
  p2=plotVsTime( times, values, 'Limb CCD Power Status', 'Power')
  return, x2[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END