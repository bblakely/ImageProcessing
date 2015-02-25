albedostack=[]
for n = 0, 46-1 do begin
  Date=read_tiff(Thefiles[n])
  Datereform=reform(Date,1,4910,2223)
  albedostack=[albedostack,Datereform]
  endfor
end