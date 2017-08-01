;Mike Walker

;Launch Plots for Temperature -----
function currentPlot1, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files
  
  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  
  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 625, 2, header)
  p2=plotVsTime( times, values, 'Nadir Phase A Motor Drive Current', 'Current')
  return, x2[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function currentPlot2, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 627, 2, header)
  p3=plotVsTime( times, values, 'Nadir Phase B Motor Drive Current', 'Current')
  return, x3[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function currentPlot3, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 629, 2, header)
  p4=plotVsTime( times, values, 'Limb Phase A Motor Drive Current', 'Current')
  return, x4[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function currentPlot4, epoch
  COMMON filePick, files
  COMMON times, times
  COMMON values, values
  file = files

  ;Specify first bytes of a packet
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32

  number_grans = 0

  times=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header) + epoch
  values=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 631, 2, header)
  p5=plotVsTime( times, values, 'Limb Phase B Motor Drive Current', 'Current')
  return, x5[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END