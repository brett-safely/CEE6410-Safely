$title 'CONOPT test suite - basic option reading test' (CONOPT01,SEQ=280)
$if not '%GAMS.nlp%' == '' $set solver %GAMS.nlp%
$if not set solver         $set solver conopt

$call gamslib -q ajax

$echo "abort$(ajax.solvestat <> %solveStat.iterationInterrupt%) 'problems with %solver% option';" >> ajax.gms

$echo "LFITER 1" > %solver%.op2
$call =gams ajax optfile=2 lo=0 lp=%solver%
$if errorlevel 1 $abort 'problems with %solver% options'
