#lang racket

(provide logo fofao trofeu)

(define logo "
▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄
░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░

 ▄▄   █▀▀ ▄▀█ █░█ █▀▀ █▀█ █▄░█ ▄▀█   █▀▄ █▀▀   █▀█ █░░ ▄▀█ ▀█▀ ▄▀█ █▀█   ▄▄
 ░░   █▄▄ █▀█ ▀▄▀ ██▄ █▀▄ █░▀█ █▀█   █▄▀ ██▄   █▀▀ █▄▄ █▀█ ░█░ █▀█ █▄█   ░░

▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄
░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░")

(define fofao "
::**FVVVVFFIIFIIIFFIFFFFFVVVVFVVVFVVVFFVVVVVVV$VVFFFFFFFFFFFVVIV$V$$$$$$$F*:::::::::::::::::::::::::
:*IFVVVVFFIIIIIFFFIIFFVVVVFFFVVFVFVVVV$$VVVV$$$FFFFIVFFFFIFFFVVFV$$$$$$$$$$V*:::::::::::::::::::::::
IIVVFFFFFIIFFFIIIIFVVFFFFFFVVFFFVVV$$$VVV$$$$VVFVVVFVVFVFFIFVFVVVF$$$$$$$$$$$V*:::::::::::::::::::::
IVVFFFFFFFFFFIFFFVVFFIIFFVFFIVVVVVVFFFV$$VV$VVVV$VVVVFFVFVFIFVVVVVF$$$$$$V$$$$$F*:::::::::::::::::::
FVFFFFFFFFFFIFVVVFIIIVVFFIFVV$VFVFIFV$VVFVVVVVVVVFFVVIVVVVVVFVFV$$$V$$$$$$$V$$$M$*::::::::::::::::::
VFFFFIIFFIFFV$VFIIIIVFFFFF$$$VIFFFVVVVFVVVFVVV$FVIVVVIFVVVVVVVVFV$$VF$$$$$$$$V$$$$I:::::::::::::::::
FFFFIFVFIIVVVFIIIVFFIIFFV$VFFIIFFFVVFFVFFVVV$$FVFF$FVFFVF$$FVF$VVV$$V$$$$$$MM$$$$$MV*:::::::::::::::
FFIIFVFIFVFVVFFFVFFIIIIF$VFFFIIVFVVFVFFFFVV$$VF$IF$FVFFVV$$VFVV$$FVM$$$V$$$$MMM$$$$MV*::::::::::::::
FIIV$VFVVFVVFVVVFVFIIIFVVIIFFIVFVVVVFFFFFVVVVF$$IFVVIFVVV$$$F$V$$$VMM$$$$$$M$$MMM$$$$V*:::::::::::::
FFFVFFVVVVVVV$VVVFIIIIVFIIVFFFFVVVFFIIIVVVVVVV$VIF$VIFVF$M$$VVVV$$VMM$$MV$$MM$$MMM$$$$V*::::::::::::
FFFVFVVVVVV$VVVVVFIIIFIIVVIFIV$VVFFVVVVV$VVFF$$VIV$VFF$$$MM$$VV$$$$MM$$M$V$$MMM$MMMMMMM$*:::::::::::
FFVFFFVVFF$$VVFFFFIIIIIV$FFIV$VVVVVVVFV$$VFV$$VFF$V$$V$$$$$$$$$$$$$MMMMMM$MMMMMMMMMMMM$$*:::::::::::
FVIFFVFFFV$FVFFFIFIIIIV$FVFFVFFVVVVVV$$$VFV$$VVVVV$$$$$$MM$$$$$$$$$$$MNMMMMMMNMMMMMMMM$$*:::::::::::
FFFFVVFFF$VVVFVIVFIFFVVVFVVVVFVVVFVV$$$$VFVVV$$VV$$$$$$$$$$$$$$$$$$$$$MMNNMMMMMMMMMM$$M$F:::::::::::
VIFVVFVFVVFVVFFVVIFVFVFFVVF$VVVV$V$$$$$VFIIIFVFFFVVVVVV$$$$MMMM$$MM$$$MNNNNMMNMMMM$MMM$$$*::::::::::
VFVVFV$FVVFVFFF$VFVFVFVVVFV$VV$V$F$$$VVFFFFFFFFFFI**IIV$MMMM$$$$V$$M$$$MNMNNMMMM$$M$$MM$II::::::::::
FVVVF$VVVVFVFFV$FVVFFIVFVVV$V$$$$$$$$$VVVVVVVVVI**:::***V$$VFFFFVVVVVVV$$MMNNMMMM$$M$$MMI:::::::::::
FVVVV$VVVVVIVF$$FVFFII$FVVVVV$$$VV$$VV$$$VIFFFF*::...::**IFFVFIIIIIIFFFFVV$MMNMMM$$$M$$M$*::::::::::
FVVVV$FVFVFFVF$V$$VFFF$I$V$VVV$VFVVFI*********::...:::::**IIFVFI*****IIIIIIFV$$MMM$$$M$$$$*:::::::::
FVFVVVFVI$IFV$$F$MVIVFVFV$VVVVVIII**::::::::::...::..:::::**FVVVII*****IIIIIIIIFV$$$V$$$VF*:::::::::
FVF$VFFVFVIV$$$F$$FFVFVF$$FVII****:::::.::::......:::....::**V$$VI********IIIIIIIIFV$$$$$VI:::::::::
FVV$VFVVVVFVV$$F$$FFVF$VVFFFF*::::::.`.:::......:*:......::**F$VFIII************IIIFV$$$$$V*::::::::
VVV$$FVVVVFVV$VF$$FFVFVVFIVVF:.:::....::.`....:*:....:::::**FV$$F**II**:*********IIIFVV$$$$V*:::::::
$VV$VFVFVVFFF$VFVVIFVI*IFFVF*::......:.``.:**I*:`...::::**IFV$$$FIIV$V**:****I***IIIFFV$$$$$F:::::::
VV$$FF$FVVVFV$VIIIFII:::**I:........:.``.:*IVI..`.::***FVVV$MM$$FIFV$$VI*::***II*IIIFVV$$$$$$*::::::
FV$$VFVFVFVFV$I**FI:...............:.`..:*IFVI:..:**IV$$VIF$$M$VVV$$M$VI*******IIIIFVVV$$$$$$V::::::
VVFVVF$FVFVFVI:.*F:...............::....:*IV$V****FV$$$$IFVV$$$$$$MM$FI***I*****IIFFVVV$$$$$$$*:::::
FVFVFFVFVVVFI:.:I*...............::....:**I$$$FIIFV$$$VI*****IV$$$M$FI****I******IFVVVV$$$M$$$I:::::
FVFVFFVFVVFI*..*F:...............::.::::*IV$V$$VIIII**::**IIFFV$$$M$F******I*****IFVVV$$$$MMMV$*::::
FVF$FFVFVVFI*..IF...........`....::::::**F$VF$MV**::::***IIIFV$$$$MMVI****III:**IIFVV$$$$$M$MIV*::::
FVV$IIFF$VFI:.:FI.......`..`....::::::**F$$FV$M$I**::*****IFV$$$$$MMVI****IF****IFVV$$$$$MM$$I::::::
FVVVFFVF$VFF:.:II.............::::::***IV$FIV$M$F***:****IFV$$$$$$$M$II*IIIF***IIFVVV$VV$MM$VI::::::
F$VVFVVI$VFV::::::..........::::::****IV$VIV$$M$F********IIFVVV$$$$M$FIIIIFI*IIIVVVVVV$MM$$MI*::::::
VVVVFV$IV$FV*:::::::::..::::::::*****IV$$IFV$$MMVI********IIFV$$$$M$MVFIFVFIIFFVVVVV$MMMM$M$V**:::::
V$VVFV$FV$VVF::::::::::::::::******IFV$$VF$$$$M$VFI*****IFFFV$$$$M$$VFFVVVVVV$$$$$MMMNMMMMMMMM$$VII*
V$VVVV$VV$VF$I::::::::::::::*****IIFVV$$V$$$$$$$$VVFIIIFVVV$$$$$$$FIFV$MMMMMMMMNNMMMMMMNMMMMMMMMMMM$
VV$$FV$VV$$VV$V***************IIIFVV$$$$$$$$$$$$$$$FIIFFVFVVVVFVVFVV$$$$$MMMNNNMMMNNNNNNNNMMMMMMMMMM")

(define trofeu "
            .............---            
       .....:..::::::::::///-....       
      `:.`..:-:::::::::::///-.`.:`      
       :.  `:-:::://///::///`  .:       
       -:   -:-:://////:://:   :-       
        --` `:-:::////::///` `--        
         .--.-:::::::::://-.--.         
            ``.-:::::::/:.``            
                `.-:/-.`                
                  `:/`                  
                  -::-                  
               `.-:::/--.               
            +sooooooooooooy+            
            os--------::::ys            
           `shsoooosssssssds`           
           /////++++++++++++/")