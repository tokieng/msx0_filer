1 ' TINY-FILER 2023   Copyright (c) 2023 tokieng, MIT license
10 ' get files
11 COLOR1,1,1:SCREEN0:WIDTH80:FILES"*.BAS"
14 DEFINT A-Z:DIM FD(12):RT=0 ' for get file name after turbo-off
15 _TURBO ON(RT,FD())
20 '   FL$()=file list, BS()=sprite no, BX(),BY()=position, BE()=enabled(status), BK()=alter key char-code, BM=num of buttons, NM=num of files
21 DEFINT A-Z:DIM FL$(8),BS(5),BX(5),BY(5),BE(5),BK(5):BM=4:NM=0
22 FI=0:FOR I=0 TO 7:FL$(I)="":NEXT I
30 FOR Y=0 TO 23:FOR X=0 TO 80-13 STEP 13
40 F$="":FOR XX=0 TO 11:F$=F$+CHR$(VPEEK(Y*80+X+XX)):NEXT XX
50 IF F$="            " THEN X=80:Y=24:NEXT X,Y:GOTO 100
60 FL$(FI)=FL$(FI)+F$:NM=NM+1:IF LEN(FL$(FI))>244 THEN FI=FI+1
70 NEXT X,Y
100 ' init
110 SCREEN 1,3:COLOR15,1,1:CL=0:TP=0
120 FOR I=0 TO BM: READ BS(I), BX(I), BY(I), BK(I):NEXT I
130 S1$="":S2$="":S3$="":S4$=""
140 '   sprite 0=UP, 1=DOWN, 2=GO, 3=NG
150 FOR I=0 TO 15:READ A$:B$=CHR$(VAL("&B"+LEFT$(A$,8))):S1$=S1$+B$:S3$=B$+S3$:B$=CHR$(VAL("&B"+RIGHT$(A$,8))):S2$=S2$+B$:S4$=B$+S4$:NEXT I
160 SPRITE$(0)=S1$+S2$:SPRITE$(1)=S3$+S4$
170 FOR J=2 to 3
180 S1$="":S2$="":FOR I=0 TO 15:READ A$:B$=CHR$(VAL("&B"+LEFT$(A$,8))):S1$=S1$+B$:B$=CHR$(VAL("&B"+RIGHT$(A$,8))):S2$=S2$+B$:NEXT I:SPRITE$(J)=S1$+S2$
190 NEXT J
200 ' print list
210 PUT SPRITE 0,(BX(0),BY(0)),11,0:PUT SPRITE 1,(BX(1),BY(1)),11,1:PUT SPRITE 2,(BX(2),BY(2)),13,2
220 CLS:LM=22:FOR I=0 TO LM-1:NI=TP+I:GOSUB1200:PRINT "  ";F$
230 IF (TP+I) >= NM-1 THEN I=24:NEXT I ELSE NEXT I
240 BE(0)=1:BE(1)=1:BE(2)=1:BE(3)=0:BE(4)=0
300 ' cursor
301 '   BC=before cursor pos, CL=cursor index, TP=top offset
310 LOCATE 0,BC:PRINT" ";:BC=CL-TP
320 LOCATE 0,CL-TP:PRINT">";
330 GOSUB 1000:IF BT=0 THEN CL=CL-1 ELSE IF BT=1 THEN CL=CL+1 ELSE IF BT=2 THEN 2000
340 IF CL<0 THEN CL=0 ELSE IF CL>=NM THEN CL=NM-1
350 IF CL<TP THEN TP=TP-1:NI=CL:GOSUB1200:PRINTCHR$(27);"H";CHR$(27);"L  ";F$;CHR$(13);CHR$(10);"  "; ELSE IF TP+LM=<CL THEN TP=TP+1:NI=CL:GOSUB1200:LOCATE0,21:PRINT "  ";CHR$(13);CHR$(10);"  ";F$
360 GOTO 300
1000 ' wait button press, return BT
1010 IN$=INKEY$:IF IN$="e" OR IN$="q" THEN END
1020 IF IN$<>"" THEN FOR I=0 TO BM:IF BE(I)<>0 AND ASC(IN$)=BK(I) THEN BT=I:RETURN ELSE NEXT I
1030 IF PAD(4)=0 THEN 1010
1040 X=PAD(5):Y=PAD(6)
1050 MG=8:BT=-1
1060 FOR I=0 TO BM:IF BE(I)<>0 AND BX(I)-MG<=X AND X<=BX(I)+32+MG AND BY(I)-MG<=Y AND Y<=BY(I)+32+MG THEN BT=I:GOSUB 1100:NEXT I ELSE NEXT I
1070 IF BT<>-1 THEN TIME=0:FOR I=0 TO 1:I=-(TIME>5):NEXT I:RETURN ELSE 1010
1100 ' button clicked
1110 RETURN
1200 ' get file name from NI, return F$
1210 FI=NI\21:LF=NI MOD 21
1220 F$=MID$(FL$(FI),LF*12+1,12):RETURN
2000 ' file selected
2010 PUT SPRITE 0,(0,209),0,0:PUT SPRITE 1,(0,209),0,0:PUT SPRITE 2,(0,209),0,0
2020 PUT SPRITE 0,(BX(3),BY(3)),13,BS(3):PUT SPRITE 1,(BX(4),BY(4)),15,BS(4)
2030 CLS:LOCATE0,6:NI=CL:GOSUB1200:PRINT F$;": Run?(y/n)"
2040 BE(0)=0:BE(1)=0:BE(2)=0:BE(3)=1:BE(4)=1:GOSUB 1000:IF BT=3 THEN 2100 ELSE 200
2100 ' load basic program
2110 FOR I=0 TO 11:FD%(I)=ASC(MID$(F$,I+1,1)):NEXT I:RT=1
2120 _TURBO OFF
2130 IF RT=0 THEN SCREEN1:END ' for end command while turbo-on
2140 F$="":FOR I=0 TO 11:F$=F$+CHR$(FD%(I)):NEXT I
2150 SCREEN1:RUN F$
2160 END
4000 ' button position (id, X, Y, alt-key-code)
4010 DATA 0,200,20,30,  1,200,90,31,  2,160,140,32,  2,48,100,121,  3,176,100,110
5000 ' up-down button data
5010 DATA 1111111111111111
5020 DATA 1000000000000001
5030 DATA 1000000110000001
5040 DATA 1000000110000001
5050 DATA 1000001111000001
5060 DATA 1000001111000001
5070 DATA 1000011111100001
5080 DATA 1000011111100001
5090 DATA 1000111111110001
5100 DATA 1000111111110001
5110 DATA 1001111111111001
5120 DATA 1001111111111001
5130 DATA 1011111111111101
5140 DATA 1011111111111101
5150 DATA 1000000000000001
5160 DATA 1111111111111111
5200 ' GO button data
5210 DATA 1111111111111111
5220 DATA 1111111111111111
5230 DATA 1100000110000011
5240 DATA 1101111110111011
5250 DATA 1101111110111011
5260 DATA 1101111110111011
5270 DATA 1101111110111011
5280 DATA 1101000110111011
5290 DATA 1101110110111011
5300 DATA 1101110110111011
5310 DATA 1101110110111011
5320 DATA 1101110110111011
5330 DATA 1101110110111011
5340 DATA 1100000110000011
5350 DATA 1111111111111111
5360 DATA 1111111111111111
5600 ' NO button
5610 DATA 1111111111111111
5620 DATA 1000000000000001
5630 DATA 1010000101111101
5640 DATA 1010000101000101
5650 DATA 1011000101000101
5660 DATA 1011000101000101
5670 DATA 1010100101000101
5680 DATA 1010100101000101
5690 DATA 1010010101000101
5700 DATA 1010010101000101
5710 DATA 1010001101000101
5720 DATA 1010001101000101
5730 DATA 1010000101000101
5740 DATA 1010000101111101
5750 DATA 1000000000000001
5760 DATA 1111111111111111
6000 DATA 255,128,129,129,131,131,135,135,143,143,159,159,191,191,128,255
6010 DATA 225,  1,129,129,193,193,225,225,241,241,249,249,253,253,  1,255
6020 DATA 225,225,193,223,223,223,223,209,221,221,221,221,221,193,255,255
6030 DATA 255,128,161,161,177,177,169,169,165,165,163,163,161,161,128,255
