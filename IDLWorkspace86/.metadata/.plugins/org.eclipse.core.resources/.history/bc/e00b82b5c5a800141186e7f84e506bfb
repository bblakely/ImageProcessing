;Snow sorting tests
;


Snowfiles=File_search('F:\Snow\early','*Part*.tif') ;early refers to these being the first 3 months of the year

;build snow array. Each file covers two dates so each is used twice

for l = 0, n_elements(snowfiles) - 1 do begin 
  Space=fltarr(2,6794,2223)
  Snowday=read_tiff(Snowfiles[l])
  identifier=Strmid(snowfiles[l],16,8)
  Reads,identifier,name
  Snowdayexp=rebin(reform(Snowday,1,6794,2223),2,6794,2223) ;takes 2 dimensional snow image,adds a third dimension, and 'stacks' two copies of the image 
  ;need to create a name using identifier and copy snowdayexp to it.... BUT HOW???
endfor


;Alljan=[Jan1exp,Jan2exp]  ;concatinate 2-image stacks into one large array that lines up with the first 3 months of modis dates

albfile='F:\TwoYearAlbAvg\Albedo02to03avg.tif' ;main part of procedure checking snow array and filtering out values that do not match the criterion
testalb=read_tiff(albfile ,GEOTIFF=geotiff_info)
iopen, albfile , geotiff=geokeys

Snowy=fltarr(46,6794,2223)

  for i= 0,6794-1 do begin ;Will have a k-dimension. Doesnt work yet.
    
    for j = 0,2223-1  do begin
      
      if Jan1exp[k,i,j] gt 0.75 then Snowy[k,i,j]=testalb[k,i,j] else Snowy[k,i,j]= 9999
  
      
 ;testalb1[1:2,Jan1exp lt .75] = 9999 ;not sure why this doesn't work
      


  endfor
  endfor
  write_tiff,'F:\SnowSort4.tif', testalb1, /float, geotiff=geokeys
  end
 
 ;from experimentation 
  ;Jan1=read_tiff('F:\Snow\JanPart1.tif')
  ;Jan2=read_tiff('F:\Snow\JanPart2.tif')
  ;Jan1exp=rebin(reform(jan1,1,6794,2223),2,6794,2223)
  ;Jan2exp=rebin(reform(jan2,1,6794,2223),2,6794,2223)
  ;microtestalb=reform(testalb[1,*,*])