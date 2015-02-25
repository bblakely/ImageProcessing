
Snowtest=read_tiff("F:/NoSnow75.tif") ;the file containing albedos classified as EITHER snowy or not; these come from the SnowSort procedure
;replace with no snow albedo if that is of interest

LCtest=read_tiff("F:/Majority80LC.tif") ;The landcover file


DisagreeCount=0L ;Pixels left out due to disagreement in LC type between MODIS years
FillCount=0L     ;Pixels left out for QC

Megalist=List()
for k = 0, 12-1 do begin
  snowimage=snowtest[k,*,*]
  ;snowimage=Snowtest[0,*,*]
  snow=reform(snowimage,6794,2223)
 
  ;New empty vectors for each image
  Crops=[]
  Mosaic=[]
  Decid=[]
  Mixed=[]
  Evgreen=[]
  Other=[]
  Bad=[]
 
  foreach element, LCtest, index do begin
    if snow[index] lt 1 then begin  ;make sure the albedo image value is an albedo and not a fill
    case element of
      9999:DisagreeCount=DisagreeCount+1
      12:Crops=[Crops,Snow[index]]
      14:Mosaic=[Mosaic,Snow[index]]
      4:Decid=[Decid,Snow[index]]
      5:Mixed=[Mixed,Snow[index]]
      1:Evgreen=[Evgreen,Snow[index]]
      else:Other=[Other,Snow[index]]
    endcase
    endif else begin
      FillCount=FillCount+1
    endelse
    if index mod 100000 eq 0 then print, index  ;Counter to monitor progress
  endforeach
  Yearlist=List(Crops,Mosaic,Decid,Mixed,Evgreen)
  Megalist.add, Yearlist
endfor


;This section creates profiles for each land cover type from 'megalist' and writes to CSV

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
filenameresult='F:/Profiles'+strtrim(disagreecount,2)+'.csv'
headerresult=['Crops','Mosiac','Deciduous','MixedForest','Evergreen']
write_csv, filenameresult, ProfileArray, header=headerresult

end
