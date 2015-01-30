pro modis_mask

;File path
input_state_file = 'C:\Users\fbouchar\Desktop\test\state_4Adrian.tif'
input_qc_file = 'C:\Users\fbouchar\Desktop\test\qc_4Adrian.tif'
input_evi_file = 'C:\Users\fbouchar\Desktop\test\evi_4Adrian.tif'

;Read state and qc file for MOD09A1 product. Different
;MODIS products might have different quality files
;You can check the MODIS product website for the details 
;of available files
evi = read_tiff(input_evi_file,GEOTIFF=geotiff_info) ; I calculated EVI first using the reflectance in MOD09A1. Here I just load it.
qc = read_tiff(input_state_file)                  
state = read_tiff(input_qc_file) 
dim_evi = size(evi)

;store the filter vegetation index time series
vi_final_sg = fltarr(45,100,100)

for i= 0,100-1 do begin 
    for j = 0,100-1  do begin ;
    
; Cloud tag
      cloud = bytarr(dim_evi[1])
      cloud[*] = 0
      mask = 0
      for k=0, 45-1 do begin
        ;MODIS reflectance product has two quality layers: QC and State. For other products you can change the code below to suit your needs.
        ;binary function convert the long type numbers in qc and state into 01010101 type value.
        ; https://lpdaac.usgs.gov/products/modis_products_table/mod09a1 click on layers
        ; you will find what does it mean for each digit equal to 0 or 1
        qc_bin = binary(long(qc[k,i,j]))
        state_bin = binary(long(state[k,i,j]))
        state_bin = reverse(uint(state_bin),/OVERWRITE)
        qc_bin = reverse(uint(qc_bin),/OVERWRITE)
        ;This is the key part to mask the values you do not want
        ;For example, if the 31th (start from 0!) digit from the left equal zero, AND the first equal zero, and the second equal 0, then we mask it
        ;You can add more criteria if you want
        if (state_bin[1] EQ 0 and state_bin[2] EQ 0) then cloud[k]=1
      endfor
      
      
      ; SG-filter, with interpolation, attached in the email. You can tinker with the function (it has four additional parameters).
      ;vi_final_sg is the final filtered time-series      
      vi_final_sg[*,i,j] = phur_reconstruct_ndvi_ts(evi[*,i,j],cloud_tag=cloud)
      
     
    endfor
  endfor
  
;tvscl, vi_final_sg[0,*,*]
filename='C:\Users\fbouchar\Desktop\stackmaybe.tif'
WRITE_TIFF,filename,vi_final_sg[1,*,*],/float
tvscl, read_tiff('C:\Users\fbouchar\Desktop\stackmaybe.tif')
end

