# !/bin/bash

awkcommand='
BEGIN {
   FS=";"; # input file uses ; as field separator
   OFS=","; # use , as field separator for output file
    print "Date,Payee,Memo,Amount" # column names
} 

# match lines whose first columns is in a date format
$1~/[0-9]{2}\/[0-9]{2}\/[0-9]{2}/ { 
    # prepend the two trailing digits (indicating year) with "20" to obtain year in 4 digit format
    fulldate = gensub(/([0-9]{2}$)/,"20\\1", "g", $1); 

    # Remove dots from amount field (is used as thousand separator, i.e. 1.000)
    gsub(/\./,"",$8);  

    # Use dot instead of comma for decimal separator (comma will be used as field separator)
    gsub(/,/,".", $8); 

    print fulldate,$2,$3,$8  
}
'

# In order to use 'gensub' which supports capturing groups, we need to use gawk instead of awk
gawk "$awkcommand" $*

