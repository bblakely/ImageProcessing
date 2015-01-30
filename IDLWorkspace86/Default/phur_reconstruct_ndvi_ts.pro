function phur_reconstruct_ndvi_ts, array_ndvi, $ ;ndvi time series to be reconstructed
                                  cloud_tag = cloud_tag, $ ;cloud tag of the data 0/1
                                  savgol_m_long = savgol_m_long, $ ; half-width of the smoothing window for long-term
                                  savgol_d_long = savgol_d_long, $ ; degree of polinomial for long-term
                                  savgol_m_iter = savgol_m_iter, $ ; half-width of the smoothing window for iteration
                                  savgol_d_iter = savgol_d_iter    ; degree of polinomial for iteration

;+
; NAME:
;   PHUR_RECONSTRUCT_NDVI_TS
;
; AUTHOR:
;   Hong Xu
;
; PURPOSE:
;   This function returns the reconstructed ndvi time series using Chen Jin's algorithm
;   Reference: A simple method for reconstructing a high-quality NDVI time-series data set based on the Savitzky�CGolay filter
;              Remote Sensing of Environment 91 (2004) 332-344
;
; INPUTS:
;   array_ndvi: The ndvi time series to be reconstructed
;   cloud_tag: The cloud tag of the ndvi time series, 0 means bad condition
;   savgol_m_long: Half-width of the smoothing window for long-term
;   savgol_d_long: Degree of polinomial for long-term
;   savgol_m_iter: Half-width of the smoothing window for iteration
;   savgol_d_iter: Degree of polinomial for iteration
;
; OUTPUTS:
;   array_back: The reconstructed ndvi time series
;
; MODIFICATION HISTORY:
;   Written by: Hong XU, April, 2008.
;   Xi YANG, changed Step 1 to take continuous cloudy days into account, Oct. 19, 2011     

  if ~keyword_set(savgol_m_long) then begin
    savgol_m_long = 7
  endif

  if ~keyword_set(savgol_d_long) then begin
    savgol_d_long = 2
  endif
  
   if ~keyword_set(savgol_m_iter) then begin
    savgol_m_iter = 8
  endif
  
   if ~keyword_set(savgol_d_iter) then begin
    savgol_d_iter = 6
  endif

  n_ts = n_elements(array_ndvi)

  ;Step 1
  ;If there is cloud tag of data, do linear interpolation first.
  ;Cloud tag eq 0 means bad condition
  if keyword_set(cloud_tag) then begin
  
    if n_elements(cloud_tag) ne n_ts then begin
      print,"ndvi time series and cloud tag don't match!"
      return, -1
    endif
    
    subscript_cloud = where(cloud_tag eq 0,count_tmp,COMPLEMENT = subscript_noncloud, NCOMPLEMENT = count_nonc_tmp)
    
    if count_tmp gt 0 AND count_nonc_tmp gt 0 then begin
      n_cloud = n_elements(subscript_cloud)
      n_non_cloud = n_elements(subscript_noncloud)
      
      for int_script = 0,n_cloud-1 do begin ;int_script = 0,n_cloud-1
        
        if subscript_cloud[int_sc ript] eq 0 then begin
          array_ndvi[0] = array_ndvi[subscript_noncloud[0]]
        endif else if subscript_cloud[int_script] eq n_ts-1 then begin
          array_ndvi[n_ts-1] = array_ndvi[array_ndvi[subscript_noncloud[n_non_cloud-1]]]
        endif else begin
          tmp_abs = where((subscript_noncloud[*] - subscript_cloud[int_script]) GT 0,n_tmp_abs, COMPLEMENT = tmp_abs_1, NCOMPLEMENT = n_tmp_abs_1) ;FIND the closest non-cloudy day after the cloudy day
          if n_tmp_abs EQ 0 then begin
            array_ndvi[subscript_cloud[int_script]] = array_ndvi[subscript_noncloud[tmp_abs_1[n_tmp_abs_1-1]]]
          endif else begin
            if tmp_abs[0] EQ 0 then begin
             array_ndvi[subscript_cloud[int_script]] = array_ndvi[subscript_noncloud[tmp_abs[0]]]
            endif else begin
              before_sub = subscript_noncloud[tmp_abs[0]-1]
              after_sub = subscript_noncloud[tmp_abs[0]]
              array_ndvi[subscript_cloud[int_script]] = array_ndvi[before_sub] + (array_ndvi[after_sub] - array_ndvi[before_sub])*(subscript_cloud[int_script]-before_sub)/(after_sub-before_sub) 
            endelse  
          endelse       
        endelse
      
      endfor
    
    endif
  
  endif
  
  
  
  ;Step 2
  ;Do Savitzky-Golay filter smoothing
  savgol_Filter = SAVGOL(savgol_m_long,savgol_m_long,0,savgol_d_long,/double)
  array_savgol_Fitted = CONVOL(array_ndvi, savgol_Filter, /EDGE_TRUNCATE, /NAN) ;add /NAN by XY
  
  ;Step 3 Weight calculation
  diff_of_n0_and_nr = array_ndvi - array_savgol_Fitted
  diff_abs          = abs(diff_of_n0_and_nr)
  diff_abs_max      = max(diff_abs,/NAN);add /NAN by XY
  weights           = fltarr(n_ts)
  array_new         = fltarr(n_ts)
  
  for int_ts = 0,n_ts-1 do begin
  
    if diff_of_n0_and_nr[int_ts] ge 0 then begin
      weights[int_ts] = 1
    endif else begin
      weights[int_ts] = 1-diff_abs[int_ts]/diff_abs_max
    endelse
    
  endfor

  ;Step 4 generation of new ndvi
  ;Step 5 loop
  
  Fk_1 = total(diff_abs * weights,/NAN) ;add /NAN by XY 
  Fk  = Fk_1
  test = 0
  while Fk_1 le Fk do begin
  
    array_back = array_savgol_Fitted
    
    for int_ts = 0,n_ts-1 do begin
  
      if diff_of_n0_and_nr[int_ts] ge 0 then begin
        array_new[int_ts] = array_ndvi[int_ts]
      endif else begin
        array_new[int_ts] = array_savgol_Fitted[int_ts]
      endelse
      
    endfor
    
    savgol_Filter       = SAVGOL(savgol_m_iter, savgol_m_iter, 0,savgol_d_iter)    
    array_savgol_Fitted = CONVOL(array_new, savgol_Filter, /EDGE_TRUNCATE,/NAN) ;add /NAN by XY
    
    diff_of_n0_and_nr = array_new - array_savgol_Fitted
    Fk                = Fk_1
    ;Step 6 fitting-effect index calculation
    Fk_1              = total(abs(diff_of_n0_and_nr) * weights,/NAN);add /NAN by XY
    
    test++
    if test gt 100 then break
    
  endwhile
  
  return,array_back
                               
end
