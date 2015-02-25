

CropsProf=[]
;make_array(12,value=0)
MosaicProf=[]
;make_array(12,value=0)
DecidProf=[]
;make_array(12,value=0)
MixedProf=[]
;make_array(12,value=0)
EvgreenProf=[]
;make_array(12,value=0)

for i = 0, 11 do begin
  CropsProf=[CropsProf,mean(megalist[i,0])]
  ;print, mean(megalist[i,0])
  MosaicProf=[MosaicProf,mean(megalist[i,1])]
  DecidProf=[DecidProf, mean(megalist[i,2])]
  MixedProf=[MixedProf, mean(megalist[i,3])]
  EvgreenProf=[EvgreenProf,mean(megalist[i,4])]
  endfor
    
  end