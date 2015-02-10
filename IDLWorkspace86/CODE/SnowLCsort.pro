
Snowtest=read_tiff("F:/Snow4.tif")
;replace with ead no snow albedo if that is of interest
LCtest=read_tiff("F:/AllAgreedLC.tif")

Crops=[]
Mosaic=[]
Decid=[]
Mixed=[]
Evgreen=[]
Other=[]
Bad=[]
Count=0L
Probcount=0L

;for k = 0, 12-1 do begin
  ;snowtrail=snowtest[k,*,*]
  snowimage=Snowtest[0,*,*]
  snow=reform(snowimage,6794,2223)
  foreach element, LCtest, index do begin
    if snow[index] lt 1 then begin
    case element of
      9999:Count=Count+1
      12:Crops=[Crops,Snow[index]]
      14:Mosaic=[Mosaic,Snow[index]]
      4:Decid=[Decid,Snow[index]]
      5:Mixed=[Mixed,Snow[index]]
      1:Evgreen=[Evgreen,Snow[index]]
      else:Other=[Other,Snow[index]]
    endcase
    endif else begin
      Probcount=Probcount+1
    endelse
    if index mod 100000 eq 0 then print, index
  endforeach
;endfor
end
