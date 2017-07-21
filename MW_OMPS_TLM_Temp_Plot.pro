;Mike Walker

;Launch Plots for Temperature -----
PRO MW_OMPS_TLM_Temp_PLOT
  COMMON filePick, files
  file = files
  
  header = MAKE_ARRAY(2, /LONG)
  header[0]=10
  header[1]=32
  
  number_grans = 0
  
  x2=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y2=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 641, 2, header)
  p2=plotVsTime( x2, y2, 'Temperature - Limb Housing', 'Time (Seconds Elapsed)', 'Temperature')
  
  x3=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y3=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 643, 2, header)
  p3=plotVsTime( x3, y3, 'Temperature - Limb Sun Side', 'Time (Seconds Elapsed)', 'Temperature')
  
  x4=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y4=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 645, 2, header)
  p4=plotVsTime( x4, y4, 'Temperature - Limb Dark Side', 'Time (Seconds Elapsed)', 'Temperature')
  
  x5=getTimes(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 6, header)
  y5=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 643, 2, header)
  z5=getParam(file, 'OMPS-TELEMETRY-RDR_All', number_grans, 645, 2, header)
  p5=plotVsTime3D( x5, y5, z5, 'Temperature - Limb vs Dark Sides', 'Time (Seconds Elapsed)',$
     'Temperature - Limb Sun Side', 'Temperature - Limb Dark Side')
END