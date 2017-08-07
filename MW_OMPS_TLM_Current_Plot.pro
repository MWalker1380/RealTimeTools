;Mike Walker

;Launch Plots for Temperature -----
function currentPlot1, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Nadir Phase A Motor Drive Current'
  xLabel = 'Current'
  
  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  
  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 625, 2, header)
  p2=plotVsTime( times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function currentPlot2, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Nadir Phase B Motor Drive Current'
  xLabel = 'Current'

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 627, 2, header)
  p3=plotVsTime( times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function currentPlot3, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Limb Phase A Motor Drive Current'
  xLabel = 'Current'

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 629, 2, header)
  p4=plotVsTime( times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function currentPlot4, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Limb Phase B Motor Drive Current'
  xLabel = 'Current'

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 631, 2, header)
  p5=plotVsTime( times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function voltagePlot1, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  COMMON mainLabel, mainLabel
  COMMON xLabel, xLabel
  file = files
  mainLabel = 'Voltage-Resolver Electronics + 12V'
  xLabel = 'Voltage'

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 804, 2, header)
  p2=plotVsTime( times, values, mainLabel, xLabel)
  return, times[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END