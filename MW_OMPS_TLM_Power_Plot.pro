;Mike Walker

;Launch plots for Power -----
; APID 
function powerPlot1, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Nadir CCD Power Status'
  xLabel = 'Power'

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32
  
  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch ; add epoch to convert to IDL's epoch
    
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 193, 1, header)
  
  p2 = plotVsTime(times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function powerPlot2, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Limb CCD Power Status'
  xLabel = 'Power'
  
  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 300, 1, header)
  p2=plotVsTime( times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END