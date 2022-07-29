@rem not generally needed so commented out
@rem perl mkwrd.pl
zmac wrd80.z
@if ERRORLEVEL 1 goto done
trs80gp -m3 zout\wrd80.cmd
:done
