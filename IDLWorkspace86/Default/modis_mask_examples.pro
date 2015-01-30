pro modis_mask_examples

;Directory loop
AlbFiles=FILE_SEARCH('F:\Processing\FullRaw\Albedo','RawAlbedo*h11v05*')
for l = 0, n_elements(Albfiles)-1 do begin ;MAKE SURE THIS IS RIGHT
  
input_evi_file = (AlbFiles[l])

;'F:\Processing\FullRaw\RawAlbedo2011h11v04.tif'

identifier=Strmid(Albfiles[l],38,10) ;year and tile code 

print, "Start time for "+identifier+":"
print, SYSTIME()

;Read state and qc file for MOD09A1 product. Different
;MODIS products might have different quality files
;You can check the MODIS product website for the details of available files
evi = read_tiff(input_evi_file, GEOTIFF=geotiff_info) ; I calculated EVI first using the reflectance in MOD09A1. Here I just load it.
;state = read_tiff(input_state_file)                  
;qc = read_tiff(input_qc_file)
dim_evi = size(evi)

IOPEN, input_evi_file, GEOTIFF=Geokeys

;store the filter vegetation index time series
vi_final_sg = fltarr(46,4910,2223)


for i= 0,4910-1 do begin 
    for j = 0,2223-1  do begin ;
    
; Cloud tag
      cloud = bytarr(dim_evi[1])
      cloud[*] = 0
      mask = 0
      for k=0, 46-1 do begin
        ;MODIS reflectance product has two quality layers: QC and State. For other products you can change the code below to suit your needs.
        ;binary function convert the long type numbers in qc and state into 01010101 type value.
        ; https://lpdaac.usgs.gov/products/modis_products_table/mod09a1 click on layers
        ; you will find what does it mean for each digit equal to 0 or 1
        
        ;This is the key part to mask the values you do not want
        ;For example, if the 31th (start from 0!) digit from the left equal zero, AND the first equal zero, and the second equal 0, then we mask it
        ;You can add more criteria if you want
        if(evi[k,i,j] lt 2) then cloud[k]=1  ;Modified to exclude fill values only; does not use band or QC
    
      endfor
      
      ; SG-filter, with interpolation, attached in the email. You can tinker with the function (it has four additional parameters).
      ;vi_final_sg is the final filtered time-series      
      vi_final_sg[*,i,j] = phur_reconstruct_ndvi_ts(evi[*,i,j],cloud_tag=cloud)
      
     
    endfor
    if ((i mod 1000)eq 0)then print, i
   

  endfor
  print, "writing file"
  
 
  filename="C:\Users\Rocha Lab\Desktop\QualRedo\"+identifier+"QC.tif"
  
  WRITE_TIFF,filename,vi_final_sg,/float, GEOTIFF=Geokeys

  print, "Processing finished for "+identifier
  print, "End time for "+identifier+":"
  print, SYSTIME()
  endfor
end
