
Albfile=read_tiff('F:/TenYearAvgAlbedo.tif')
MegalistWarm=List()
LCtest=read_tiff("F:/Majority80LC.tif")


for g = 13,42-1 do begin
  
AlbDate=Albfile[g,*,*]
Alb=reform(AlbDate,6794,2223)
RejectCount=0

Crops=[]
Mosaic=[]
Decid=[]
Mixed=[]
Evgreen=[]
Other=[]


foreach element, LCtest, index do begin
  if Alb[index] lt 1 then begin
    case element of
      12:Crops=[Crops,Alb[index]]
      14:Mosaic=[Mosaic,Alb[index]]
      4:Decid=[Decid,Alb[index]]
      5:Mixed=[Mixed,Alb[index]]
      1:Evgreen=[Evgreen,Alb[index]]
      else:Other=[Other,Alb[index]]
    endcase
    endif else begin
      RejectCount=RejectCount+1
    endelse
  if index mod 100000 eq 0 then print, index  ;Counter to monitor progress
endforeach
Yearlist=List(Crops,Mosaic,Decid,Mixed,Evgreen)
MegalistWarm.add, Yearlist
endfor

;This section creates profiles for each land cover type and writes to CSV

CropsProf=[]
MosaicProf=[]
DecidProf=[]
MixedProf=[]
EvgreenProf=[]

for i = 0, 12-1 do begin

  CropsProf=[CropsProf,mean(megalist[i,0])]
  ;print, mean(megalist[i,0])
  MosaicProf=[MosaicProf,mean(megalist[i,1])]
  DecidProf=[DecidProf, mean(megalist[i,2])]
  MixedProf=[MixedProf, mean(megalist[i,3])]
  EvgreenProf=[EvgreenProf,mean(megalist[i,4])]

endfor

ProfileArray=transpose([[Cropsprof],[MosaicProf],[Decidprof],[MixedProf],[EvgreenProf]])
filenameresult='F:/WarmProfiles'+strtrim(reject,2)+'.csv'
headerresult=['Crops','Mosiac','Deciduous','MixedForest','Evergreen']
write_csv, filenameresult, ProfileArray, header=headerresult

end