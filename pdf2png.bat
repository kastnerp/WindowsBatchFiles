


for /r %%a in (.) do (
  pushd %%a
  (    
    for %%k in (*.pdf) do gswin64c -q -dNOCACHE -dNOPAUSE -dBATCH -dSAFER -sDEVICE=png16m -r1200 -sOutputFile=%%~nk.png	%%k
	)
  popd 
  )
PAUSE