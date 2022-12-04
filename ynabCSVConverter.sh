# !/bin/bash

awkcommand_prefix='
BEGIN {
   FS=";"; # input file uses ; as field separator
   OFS=","; # use , as field separator for output file
   print "Date,Payee,Memo,Amount" # column names
}
'

# This is the awk command to use when receiving a csv input file.
# In this case we assume that the file has been manually converted 
# from xlsx to csv using Numbers, thus we have to perform some additional
# processing to convert it to YNAB format.
#
# We leave this option in the script to be more resilient in case xlsx2csv
# stops working as we expect.
awkcommand_manual_csv='
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

# This is the awk command to use when receiving a xlsx file, which we 
# convert to csv using xlsx2csv. Since this tool has different exporting conventions,
# we can "save" some awk processing and we simply print the selected columns
awkcommand_auto_csv='
# match lines whose first columns is in a date format and print selected columns
$1~/[0-9]{2}\/[0-9]{2}\/[0-9]{2}/ { print $1,$2,$3,$8 }
'

if [ "$#" -ne 2 ]; then
    echo "Usage ./ynabCSVConverter.sh input_file output_file"
    exit 1
fi

input_file=$1
output_file=$2
input_file_extension="${input_file##*.}"

# Check the input_file extension and determine execution mode
# 1. xlsx   Convert the file using xlsx2csv and apply minimum awk processing
# 2. csv    Consider the file as manually exported from xlsx to csv and apply additional awk processing

if [ $input_file_extension = "xlsx" ]; then
    # Check xlsx2csv is installed
    if ! command -v 'xlsx2csv' &> /dev/null
    then
        echo "xlsx2csv needed to convert xlsx to csv install it with:"
        echo "\tpip3 install xlsx2csv"
        echo "\nMore info at https://github.com/dilshod/xlsx2csv"
        exit 1
    fi   

    # Convert xlsx to csv
    tmp_csv_filename=tmp.csv
    xlsx2csv_cmd="xlsx2csv -d ';' -f '%m/%d/%Y' $input_file $tmp_csv_filename"
    eval "$xlsx2csv_cmd"

    # Run gawk to process csv
    awkcommand="$awkcommand_prefix $awkcommand_auto_csv"
    awk "$awkcommand" $tmp_csv_filename > $output_file

    # Delete temporary converted file
    rm $tmp_csv_filename
elif [ $input_file_extension = "csv" ]; then
    awkcommand="$awkcommand_prefix $awkcommand_manual_csv"

    if ! command -v 'gawk' &> /dev/null
    then
        echo "In order to use 'gensub' which supports capturing groups, we need to use gawk instead of awk. You can install it with:"
        echo "\tbrew install gawk"
        exit 1
    fi

    gawk "$awkcommand" $input_file > $output_file
else
    echo "Unrecognized input file extension $input_file_extension"
    exit 1
fi
