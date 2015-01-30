
;creates an index vector for each date in the series of 46 that makes up a year
infilename="F:\Albedo_h11v04_2006to2007.tif"
infile=read_tiff(infilename, GEOTIFF=geotiff_info)
stacksize=size(infile)    ;dimensions of input file
YEARS=stacksize[1]/46     ;46 images per year. Result is number of years.
INDBAND=INDGEN(46,YEARS)  ;matrix in which each row is a year of images
DAT=fltarr(46,6794,2223)    ;placeholder

IOPEN, infilename, GEOTIFF=Geokeys    ;records georeferencing info
print, 'starting loop'
print, systime()
for k = 0,46-1 do begin 
;main loop collapsing stack dimension by averaging:  
  for i = 0,6794-1 do begin
    ;print, 'starting i'
    for j = 0,2223-1 do begin
      ;print, 'starting j'
      val=[i,j]
      ;print, val
        ;print, 'now calculating mean for i, j'
      DAT[k,i,j]=mean(infile[INDBAND[k,*],i,j])   ;means of individual pixel values on each date accross all years (e.g. Jan 1 2012, Jan 1 2013, Jan 1 2014...)
    
     endfor
     if ((i mod 1000)eq 0)then print, i
    endfor   
     ;window,0,xsize=400,ysize=400
     ;plot, DAT[*,111,40]                         ;no special significance to [11,40]. Choose any pixel index you would like to see or comment this line out
     ;spatialaverage[k]=mean(DAT[k,*,*])          ;spatial average of all pixels from each date k
     print, k
   endfor
   ;print, spatialaverage
   ;window,1, xsize=400,ysize=400
   ;plot, average
   print, systime()
   filename='C:\Users\Rocha Lab\Desktop\Albedo06to07avg.tif'
   WRITE_TIFF,filename,DAT,/float, GEOTIFF=Geokeys
   
   
end
