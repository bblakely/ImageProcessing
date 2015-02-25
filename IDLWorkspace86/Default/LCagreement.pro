
yearfiles = file_search('F:/RawData\Landcover\Type_1\Covertype1\*land*.tif')

AllLCyears= list()
for i = 0, 10-1 do begin
LCyear=read_tiff(yearfiles[i])
AllLCyears.add, LCyear
endfor


Agreement=fltarr(6794,2223) ;Array to hold values generated by agreement procedure (all years have to match for a given pixel)
Majority=fltarr(6794,2223)  ;Array to hold values generated by majpority procedure (pixel is determined by value of some percent of years. If desired majority does not exist, the pixel is discarded)
pixel=[]

;;Agreement procedure
;foreach element, Agreement, index do begin
  ;for i= 0, n_elements(AllLCyears)-1 do begin
  ;pixel= [pixel,allLCyears[i,index]]
  ;endfor
;if (pixel[0] ne pixel[1]) OR (pixel[1] ne pixel[2]) OR (pixel[2] ne pixel[3]) OR (pixel[3] ne pixel[4])$
    ;OR (pixel[4] ne pixel[5]) OR (pixel[5] ne pixel[6]) OR (pixel[6] ne pixel[7])$
    ;OR (pixel[7] ne pixel[8])  OR (pixel[8] ne pixel[9])then Agreement[index]= 9999 else Agreement[index]= pixel[1]
    ;pixel=[]
;endforeach

;;Majority procedure
foreach element, Majority, index do begin
for i= 0, n_elements(AllLCyears)-1 do begin
  pixel= [pixel,allLCyears[i,index]]
  endfor
  hist=histogram(pixel, min=0, max=14)
  freq=max(hist)
  MCV=where(hist eq freq)
  
  if freq lt (n_elements(pixel)/1.25) then Majority[index] =9999 else Majority[index] = MCV
  pixel=[]
endforeach 

write_tiff, 'F:/Majority80LC.tif',Majority, /FLOAT

end
