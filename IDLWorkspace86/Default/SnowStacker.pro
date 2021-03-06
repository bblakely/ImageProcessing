Snowfiles=File_search('F:\Snow\early','*Part*.tif') ;early refers to these being the first 3 months of the year

;build snow array. Each file covers two dates so each is used twice
 Bimonths=list()
for l = 0, n_elements(snowfiles) - 1 do begin
  Snowday=read_tiff(Snowfiles[l])
  identifier=Strmid(snowfiles[l],16,8)
  ;Reads,identifier,name
  Snowdayexp=rebin(reform(Snowday,1,6794,2223),2,6794,2223) ;takes 2 dimensional snow image,adds a third dimension, and 'stacks' two copies of the image
  BiMonths.add, Snowdayexp
    endfor
    
    Allsnow=[Bimonths[0], Bimonths[1], Bimonths[2], Bimonths[3], Bimonths[4], Bimonths[5]]
    ;write_tiff, 'F:\AutoSnowStack.tif', Allsnow, /FLOAT
    end