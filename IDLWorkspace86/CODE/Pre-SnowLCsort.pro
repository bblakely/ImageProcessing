;Arr1=indgen(10, increment=2)
;Arr2=indgen(10, increment=2)
;Arr3=indgen(10, increment=7)
TwoD=indgen(2,5, increment=2)
TwoDr=indgen(2,5, increment=3)
Arrx=[]
foreach element, TwoD, index do begin
  ;Arr1[i]=0
  print, index
  print, element
  if element mod 4 eq 0 then ArrX = [ArrX, TwoDr[index]] else ArrX = ArrX
endforeach
end