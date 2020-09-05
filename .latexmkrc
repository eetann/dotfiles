$latex            = 'platex -kanji=utf8 -synctex=1 -halt-on-error';                                                                                              $latex_silent     = 'platex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
$pdf_mode   = 3; #dvipdfmxを使ってPDF生成
$pdf_previewer = '/mnt/c/Program\ Files/SumatraPDF/SumatraPDF.exe'
