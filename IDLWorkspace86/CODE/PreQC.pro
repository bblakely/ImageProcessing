
Year=[2010, 2011, 2012]
;2003,2004,2005, 2006 ;;;2007, 2008, 2009 have bad tifs
for m = 0, n_elements(year)-1 do begin
filepath='F:/RawData/Albedo/'+Strtrim(year[m],2)+'Albedo/shortwave/wsa/h11v04'
print, filepath
Thefiles=File_search(filepath[0],'*.tif')
albedostack=[]
  for n = 0, 46-1 do begin
    Date=read_tiff(Thefiles[n], GEOTIFF=Geokeys)
    Datereform=reform(Date,1,6794,2223)
    albedostack=[albedostack,Datereform]
  endfor
  Albedo=albedostack*0.001

  writepath= 'F:/Processing/RawAlbedoWSA'+Strtrim(Year[m],2)+'h11v04.tif'
  write_tiff, writepath, Albedo,  /FLOAT, GEOTIFF=Geokeys
endfor
end