;Mike Walker

;Launch plots for Power -----
; APID 
function powerPlot1, epoch
  COMMON filePick, files
  file = files

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32
  
  number_grans = 0

  x1=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch ; add epoch to convert to IDL's epoch
    
  y1=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 193, 1, header)
  
  p2 = plotVsTime(x1, y1, 'Nadir CCD Power Status', 'Power')
  return, x1[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function powerPlot2, epoch
  COMMON filePick, files
  file = files
  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32

  number_grans = 0

  x2=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  y2=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 300, 1, header)
  p2=plotVsTime( x2, y2, 'Limb CCD Power Status', 'Power')
  return, x2[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END