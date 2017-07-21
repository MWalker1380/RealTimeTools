;this differs from Tool.pro in that CW_PDMENU replaced with WIDGET_BUTTON
; CW_P does not allow de-sense and behaves awkwardly. Good for ATMS channel count
; but too cumbersome here
;
PRO Tool2_event, event

COMMON Toolblock, workdir

; when a widget is touched, put its user value into eventuval
WIDGET_CONTROL, event.id, GET_UVALUE = eventuval
;WIDGET_CONTROL, event.id, GET_VALUE = eventval

print, 'retrieved event Uvalue ', eventuval

; establish path to documentation on Win or Unix file systems. Unix includes Linux or Mac

if !version.os_family eq 'unix' then begin
  reader = 'xreader '
  docsdir = workdir+'/Docs/'
  ; general docs -- the wildcards just save typing here but must be unique in directory
  mdfcbF = '*NPP*.pdf &'
  j1cthF = '*COMM*.pdf &'
  rdrF = '*CDFCB*.pdf &'
  ; instrument specific docs
  atmsOps = 'ATMS/*Ops*.pdf &'
  crisOps = 'CrIS/*Ops*.pdf &'
  ompsOps = 'OMPS/*Ops*.pdf &'
  viirOps = 'VIIRS/*Ops*.pdf &'
  atmsSpc = 'ATMS/*28300*.pdf &'
  
  case eventuval of
    
    'ACC' : LW_PLOT_ATMS
    'OmpsTlmPower' : MW_OMPS_TLM_Power_Plot
    'OmpsTlmTemp' : MW_OMPS_TLM_Temp_Plot
    'OmpsTlmMotorCurrent' : MW_OMPS_TLM_Current_Plot
    'OmpsSciTest' : MW_OMPS_SCI_Power_Plot
    'AOM' : spawn, reader+docsdir+atmsOps
    'AIS' : spawn, reader+docsdir+atmsSpc
    
    'COM' : spawn, reader+docsdir+crisOps
    'OOM' : spawn, reader+docsdir+ompsOps
    'VOM' : spawn, reader+docsdir+viirOps
    
    'QUIT' : WIDGET_CONTROL, event.top, /DESTROY
    
    'NMDFCB' : spawn, reader+docsdir+mdfcbF
    'J1CTHB': spawn, reader+docsdir+j1cthF
    'RDR' : spawn, reader+docsdir+rdrF
    
  endcase
  

  
endif else begin ;assuming this is Windows
  reader = '"c:\Program Files <x86>\Adobe\Reader 11.0\Reader\AcroRd32" '
  docsdir = workdir+'\Docs\'
  ; general docs -- the wildcards just save typing here but must be unique in directory
  mdfcbF = 'MDFCB.pdf /n /s'
  j1cthF = '*COMM*.pdf'
  rdrF = '*CDFCB*.pdf'
  ; instrument specific docs
  atmsOps = 'ATMS/*Ops*.pdf'
  crisOps = 'CrIS/*Ops*.pdf'
  ompsOps = 'OMPS/*Ops*.pdf'
  viirOps = 'VIIRS/*Ops*.pdf'
  atmsSpc = 'ATMS/*28300*.pdf'
  
  case eventuval of

    'ACC' : LW_PLOT_ATMS
    'OmpsTlmPower' : MW_OMPS_TLM_Power_Plot
    'OmpsTlmTemp' : MW_OMPS_TLM_Temp_Plot
    'OmpsTlmMotorCurrent' : MW_OMPS_TLM_Current_Plot
    'OmpsSciTest' : MW_OMPS_SCI_Power_Plot
    'AOM' : spawn, reader+docsdir+atmsOps
    'AIS' : spawn, reader+docsdir+atmsSpc, /nowait, /noshell

    'COM' : spawn, reader+docsdir+crisOps
    'OOM' : spawn, reader+docsdir+ompsOps
    'VOM' : spawn, reader+docsdir+viirOps

    'QUIT' : WIDGET_CONTROL, event.top, /DESTROY

    'NMDFCB' : spawn, reader+docsdir+mdfcbF
    'J1CTHB': spawn, reader+docsdir+j1cthF, /nowait, /noshell
    'RDR' : spawn, reader+docsdir+rdrF, /nowait, /noshell

  endcase
  
   
endelse






END

;;;;;;;;

PRO Tool2, GROUP=GROUP, BLOCK=block

COMMON Toolblock, workdir

; these lines are from Xmng_tmpl
  IF(XRegistered("Tool") NE 0) THEN RETURN   ;only one instance of
  ;the Tool widget
  ;is allowed.  If it is
  ;already managed, do
  ;nothing and return

  IF N_ELEMENTS(block) EQ 0 THEN block=0

; this is selected from xlsfonts to get a large font. Platform specific so alter for ops.
widget_control, default_font='9x15bold'

base = WIDGET_BASE(Title='JPSS Instrument Telemetry Tools', /column); MBAR=bar)

button_base = WIDGET_BASE(base,/row, /frame)

; add Uvalues to buttons to integrate into the event handler
; 
; ATMS menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

ATMS_menu = WIDGET_BUTTON(button_base, Value='ATMS', /Menu) 

A_btn1 = WIDGET_BUTTON(ATMS_menu, Value='APID Time Series', /menu)
  A_1a = WIDGET_BUTTON(A_btn1, Value='channel counts', Uvalue='ACC')
  A_1b = WIDGET_BUTTON(A_btn1, Value='voltages',sensitive=0)
  A_1c = WIDGET_BUTTON(A_btn1, Value='temperatures',sensitive=0)
  A_1d = WIDGET_BUTTON(A_btn1, Value='scan motor current',sensitive=0)
A_btn2 = WIDGET_BUTTON(ATMS_menu, Value='Perceptive Parameters', /menu)
  A_2a = WIDGET_BUTTON(A_btn2, Value='NEDT',sensitive=0)
  A_2b = WIDGET_BUTTON(A_btn2, Value='gain',sensitive=0)
  A_2c = WIDGET_BUTTON(A_btn2, Value='scan angle errors',sensitive=0)
A_btn3 = WIDGET_BUTTON(ATMS_menu, Value='References', /menu)
  A_3a = WIDGET_BUTTON(A_btn3, Value='Instrument Spec', Uvalue='AIS')
  A_3b = WIDGET_BUTTON(A_btn3, Value='Ops Manual', Uvalue='AOM')
  A_3c = WIDGET_BUTTON(A_btn3, Value='Test Proc',sensitive=0)

   
; CrIS menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

CrIS_menu = WIDGET_BUTTON(button_base, Value='CrIS', /Menu) 

C_btn1 = WIDGET_BUTTON(CrIS_menu, Value='APID Time Series', /menu)
  C_1a = WIDGET_BUTTON(C_btn1, Value='bus current', sensitive=0)
  C_1b = WIDGET_BUTTON(C_btn1, Value='power',sensitive=0)
  C_1c = WIDGET_BUTTON(C_btn1, Value='stage 3/4 cooler temp',sensitive=0)
  C_1d = WIDGET_BUTTON(C_btn1, Value='SSM temp',sensitive=0)
C_btn2 = WIDGET_BUTTON(CrIS_menu, Value='Perceptive Parameters', /menu)
  C_2a = WIDGET_BUTTON(C_btn2, Value='NEDN',sensitive=0)
  C_2b = WIDGET_BUTTON(C_btn2, Value='DA tilt',sensitive=0)
C_btn3 = WIDGET_BUTTON(CrIS_menu, Value='References', /menu)
  C_3a = WIDGET_BUTTON(C_btn3, Value='Instrument Spec', sensitive=0)
  C_3b = WIDGET_BUTTON(C_btn3, Value='Ops Manual', Uvalue='COM')
  C_3c = WIDGET_BUTTON(C_btn3, Value='Test Proc',sensitive=0)



; OMPS menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

OMPS_menu = WIDGET_BUTTON(button_base, Value='OMPS', /Menu)
O_btn1 = WIDGET_BUTTON(OMPS_menu, Value='APID Time Series', /menu)
  O_1a = WIDGET_BUTTON(O_btn1, Value='TLM power', Uvalue='OmpsTlmPower')
  O_1b = WIDGET_BUTTON(O_btn1, Value='TLM diffuser mechanism',sensitive=0)
  O_1c = WIDGET_BUTTON(O_btn1, Value='TLM thermo cooler',sensitive=0)
  O_1d = WIDGET_BUTTON(O_btn1, Value='TLM motor current', Uvalue='OmpsTlmMotorCurrent')
  O_1e = WIDGET_BUTTON(O_btn1, Value='SCI power', sensitive=0)
  O_1f = WIDGET_BUTTON(O_btn1, Value='SCI diffuser mechanism',sensitive=0)
  O_1g = WIDGET_BUTTON(O_btn1, Value='SCI thermo cooler',sensitive=0)
  O_1h = WIDGET_BUTTON(O_btn1, Value='SCI motor current',sensitive=0)
  O_1e = WIDGET_BUTTON(O_btn1, Value='SCI test', Uvalue='OmpsSciTest')
  O_1i = WIDGET_BUTTON(O_btn1, Value='xTLM temperature', Uvalue='OmpsTlmTemp')
O_btn2 = WIDGET_BUTTON(OMPS_menu, Value='Perceptive Parameters', /menu)
  O_2a = WIDGET_BUTTON(O_btn2, Value='noise',sensitive=0)
  O_2b = WIDGET_BUTTON(O_btn2, Value='full well',sensitive=0)
  O_2c = WIDGET_BUTTON(O_btn2, Value='dark current',sensitive=0)
O_btn3 = WIDGET_BUTTON(OMPS_menu, Value='References', /menu)
  O_3a = WIDGET_BUTTON(O_btn3, Value='Instrument Spec', sensitive=0)
  O_3b = WIDGET_BUTTON(O_btn3, Value='Ops Manual', Uvalue='OOM')
  O_3c = WIDGET_BUTTON(O_btn3, Value='Test Proc',sensitive=0)
  

; VIIRS menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

VIIRS_menu = WIDGET_BUTTON(button_base, Value='VIIRS', /Menu)

V_btn1 = WIDGET_BUTTON(VIIRS_menu, Value='APID Time Series', /menu)
  V_1a = WIDGET_BUTTON(V_btn1, Value='TBD', sensitive=0)
  V_1b = WIDGET_BUTTON(V_btn1, Value='TBD',sensitive=0)
V_btn2 = WIDGET_BUTTON(VIIRS_menu, Value='Perceptive Parameters', /menu)
  V_2a = WIDGET_BUTTON(V_btn2, Value='SNR',sensitive=0)
  V_2b = WIDGET_BUTTON(V_btn2, Value='dark noise',sensitive=0)
  V_2c = WIDGET_BUTTON(V_btn2, Value='gain',sensitive=0)
  V_2d = WIDGET_BUTTON(V_btn2, Value='RTA pointing stability',sensitive=0)
  V_2e = WIDGET_BUTTON(V_btn2, Value='HAM pointing stability',sensitive=0)
  V_2f = WIDGET_BUTTON(V_btn2, Value='scan variations',sensitive=0)
V_btn3 = WIDGET_BUTTON(VIIRS_menu, Value='References', /menu)
  V_3a = WIDGET_BUTTON(V_btn3, Value='Instrument Spec', sensitive=0)
  V_3b = WIDGET_BUTTON(V_btn3, Value='Ops Manual', Uvalue='VOM')
  V_3c = WIDGET_BUTTON(V_btn3, Value='Test Proc',sensitive=0)


; bus menu  vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

SC_menu = WIDGET_BUTTON(button_base, Value='Spacecraft', /Menu) ;Mark set this title 5 Apr

S_btn1 = WIDGET_BUTTON(SC_menu, Value='APID Time Series', /menu)
  S_1a = WIDGET_BUTTON(S_btn1, Value='power', sensitive=0)
  S_1b = WIDGET_BUTTON(S_btn1, Value='voltages',sensitive=0)
  S_1c = WIDGET_BUTTON(S_btn1, Value='temperatures',sensitive=0)
S_btn2 = WIDGET_BUTTON(SC_menu, Value='Perceptive Parameters', /menu)
  S_2a = WIDGET_BUTTON(S_btn2, Value='TBD',sensitive=0)
  S_2b = WIDGET_BUTTON(S_btn2, Value='TBD',sensitive=0)
S_btn3 = WIDGET_BUTTON(SC_menu, Value='References', /menu)
  S_3a = WIDGET_BUTTON(S_btn3, Value='Instrument Spec', sensitive=0)
  S_3b = WIDGET_BUTTON(S_btn3, Value='Test Proc',sensitive=0)

; docs menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


Doc_menu = WIDGET_BUTTON(button_base, Value='Refs', /Menu)
D_btn1 = WIDGET_BUTTON(Doc_menu, Value='NPP MDFCB', Uvalue='NMDFCB')
D_btn2 = WIDGET_BUTTON(Doc_menu, Value='JPSS-1 CMD TLM HB', Uvalue='J1CTHB')
D_btn3 = WIDGET_BUTTON(Doc_menu, Value='IDPS RDR spec', Uvalue='RDR')

; tools menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

;Tool_menu = WIDGET_BUTTON(button_base, Value='CATs', /Menu)
CAT_btn = WIDGET_BUTTON(button_base, Value='CAT', Uvalue='CAT', sensitive=0)

; application control menu vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

;Control_menu = WIDGET_BUTTON(bar, Value='LogOff', /Menu)
Q_btn = WIDGET_BUTTON(button_base, Value='Quit', Uvalue='QUIT')

; add window for JPSS image

picwin = WIDGET_WINDOW(base, xsize=520, ysize=520) ;these values are picked based on length of menu bar

WIDGET_CONTROL, base, /REALIZE

; set the working directory for Tool files depending on platform

workdir = (!version.os_family eq 'windows') ? 'C:\TLM-Tool' : 'C:\TLM-Tool'

; set the draw window current and draw to it

widget_control, picwin, get_value=picID

picID.Select

fname = FILEPATH('300pxJPSSBlueLogo.png', root_dir= workdir)
;fname = FILEPATH('300pxJPSSBlueLogo.png')
im = image(fname, /CURRENT)

;widget_control, /hourglass

XMANAGER, "Tool2", base, GROUP_LEADER = GROUP, /NO_BLOCK

END

;!P.font = 0
;device, set_font = '8x13'
; list fonts with xlsfonts
