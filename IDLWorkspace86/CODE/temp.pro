
yearfiles = file_search('F:\RawData\Landcover\Type_1\Covertype1\*land*.tif')
AllLCyears= list()
for i = 0, 10-1 do begin
  LCyear=read_tiff(yearfiles[i])
  AllLCyears.add, LCyear
endfor

tester27=indgen(4)

foreach element, tester27, index do begin
  for i= 0, n_elements(AllLCyears)-1 do begin
    pixel= [pixel,allLCyears[i,index]]
  endfor
  print, pixel
  print, 000
  pixel=[]
endforeach
end


;pixel=[AllLCyears[0,[index]], AllLCyears[1,[index]], AllLCyears[2,[index]], AllLCyears[3,[index]],$
  ;AllLCyears[4,[index]],AllLCyears[5,[index]],AllLCyears[6,[index]],