

yearfiles = file_search('F:/RawData\Landcover\Type_1\Covertype1\*land*.tif')

AllLCyears= list()
for i = 0, 10-1 do begin
LCyear=read_tiff(yearfiles[i])
AllLCyears.add, LCyear
endfor

;LC10=read_tiff("F:\RawData\Landcover\Type_1\MCD12Q1_h11v04_2010-01-01.Land_Cover_Type_1.tif")
;LC11=read_tiff("F:\RawData\Landcover\Type_1\MCD12Q1_h11v04_2011-01-01.Land_Cover_Type_1.tif")
;LC12=read_tiff("F:\RawData\Landcover\Type_1\MCD12Q1_h11v04_2012-01-01.Land_Cover_Type_1.tif")

Agreement=fltarr(6794,2223)
Majority=fltarr(6794,2223)
pixel=[]

;foreach element, Agreement, index do begin
  ;for i= 0, n_elements(AllLCyears)-1 do begin
  ;pixel= [pixel,allLCyears[i,index]]
  ;endfor
;if (pixel[0] ne pixel[1]) OR (pixel[1] ne pixel[2]) OR (pixel[2] ne pixel[3]) OR (pixel[3] ne pixel[4])$
    ;OR (pixel[4] ne pixel[5]) OR (pixel[5] ne pixel[6]) OR (pixel[6] ne pixel[7])$
    ;OR (pixel[7] ne pixel[8])  OR (pixel[8] ne pixel[9])then Agreement[index]= 9999 else Agreement[index]= pixel[1]
    ;pixel=[]
;endforeach


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
end

write_tiff, 'F:/Majority50LC.tif',Majority, /FLOAT

end
