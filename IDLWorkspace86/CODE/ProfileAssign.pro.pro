protofilename="F:/Paleon/Plaeoraster1.tif"
IOPEN, protofilename, paleoveg1, GEOTIFF=Geokeys
;paleoveg2=rotate(paleoveg1, 7)
;write_tiff, "F:/Paleon/Paleoraster2", paleoveg1, /float, GEOTIFF=Geokeys
;write_tiff, "F:/Paleon/Paleoraster2", paleoveg2, /float,GEOTIFF=Geokeys
;infilename="F:/Paleon/Paleoraster2"
DAT=fltarr(46,141,174)
;IOPEN, infilename, paleoveg, GEOTIFF=Geokeys
DATflipA=fltarr(46,141,174)
paleoveg=paleoveg1
for k = 0,46-1 do begin
  for i = 0,141-1 do begin
    for j = 0,174-1 do begin
      case Paleoveg[i,j] of
        0: DAT[k,i,j]=0
        12: DAT[k,i,j]=Crop[k]
        14: DAT[k,i,j]=Mosaic[k]
        1: DAT[k,i,j]=Evgreen[k]
        4: DAT[k,i,j]=Decid[k]
        5: DAT[k,i,j]=Mixed[k]
        else:DAT[k,i,j]=0
      endcase
    endfor
    endfor
     DATflipA[k,*,*]= rotate(reform(dat[k,*,*]),7)
    endfor
    filename='C:\Users\Rocha Lab\Desktop\HistoricAlbedo.tif'
    WRITE_TIFF,filename,datflipA,/float, GEOTIFF=Geokeys, orientation=7
   end

  
   ;if(Paleoveg[i,j]EQ 12)then DAT[k,i,j]=Crop[i] else
   ;if(Paleoveg[i,j]EQ 14)then DAT[k,i,j]=Mosaic[i] else
   ;if(Paleoveg[i,j]EQ 1)then DAT[k,i,j]=Evgreen[i] else
   ;if(Paleoveg[i,j]EQ 4)then DAT[k,i,j]=Decid[i] else
   ;if(Paleoveg[i,j]EQ 5)then DAT[k,i,j]=Mixed[i] else DAT[k,i,j]=0