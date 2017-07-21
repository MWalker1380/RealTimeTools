;Mike Walker

;Launch plots for Power -----
; APID 
PRO MW_Test
  file = dialog_pickfile()

  header = MAKE_ARRAY(2, /BYTE)
  header[0]=10
  header[1]=32

  x1=getTimes(file, 'OMPS-TELEMETRY-RDR_All', 151, 6, header)*86400
  y1=getParam(file, 'OMPS-TELEMETRY-RDR_All', 151, 193, 1, header)
  p1=plotVsTime( x1, y1, 'Nadir CCD Power Status', 'Seconds Elapsed', 'Power')
END