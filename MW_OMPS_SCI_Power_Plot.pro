;Mike Walker

;Launch plots for Power -----
function versionPlot, epoch
  COMMON filePick, files
  file = files

  ;Specify first bytes of a packet
  headera = MAKE_ARRAY(2, /BYTE)
  headera[0]=10
  headera[1]=49
  
  headerb = MAKE_ARRAY(2, /BYTE)
  headerb[0]=2
  headerb[1]=49
  
  number_grans = 0

  x1=getTimes(file, 'OMPS-NPSCIENCE-RDR_All', 0, 6, headera) + epoch
  y1=getParam(file, 'OMPS-NPSCIENCE-RDR_All', 0, 16, 2, headera)
  ;x1=getTimes(file, 'OMPS-NPDIAGNOSTIC-RDR_All', number_grans, 6, header)
  ;y1=getParam(file, 'OMPS-NPDIAGNOSTIC-RDR_All', number_grans, 119, 2, header)
  p1=plotVsTime( x1, y1, 'OMPS-Science Data Grab Test', 'Version number of the RDR')
  return, x1[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END

function contPlot, epoch
  COMMON filePick, files
  file = files

  ;Specify first bytes of a packet
  headera = MAKE_ARRAY(2, /BYTE)
  headera[0]=10
  headera[1]=49

  headerb = MAKE_ARRAY(2, /BYTE)
  headerb[0]=2
  headerb[1]=49

  number_grans = 0

  x1=getTimes(file, 'OMPS-NPSCIENCE-RDR_All', 0, 6, headera) + epoch
  y1=getParam(file, 'OMPS-NPSCIENCE-RDR_All', 0, 25, 1, headera)
  ;x1=getTimes(file, 'OMPS-NPDIAGNOSTIC-RDR_All', number_grans, 6, header)
  ;y1=getParam(file, 'OMPS-NPDIAGNOSTIC-RDR_All', number_grans, 119, 2, header)
  p1=plotVsTime( x1, y1, 'OMPS-Science Data Grab Test', 'Version number of the RDR')
  
  return, x1[-1] ;return the last element in the time vector for the date and time box in the OMPS GUI
END