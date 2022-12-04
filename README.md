# YNAB transactions CSV converter

Given a transaction file in the format used by [Intesa San Paolo](https://www.intesasanpaolo.com/) bank, convert it to the format require by [YNAB](https://youneedabudget.com/) File-Import.
The script makes assumptions on the format of the input files, but can be easily customized to make it work with similar CSV input files.
For more info about YNAB File-Import check the [guide](https://support.youneedabudget.com/en_us/file-based-import-a-guide-Bkj4Sszyo) and the [formatting specification](https://support.youneedabudget.com/en_us/formatting-a-csv-file-an-overview-BJvczkuRq)

### Usage

The script accepts input files with `.xlsx` or `.csv` extensions, and will determine the mode of execution based on it.

1) `xlsx` files will be converted to `csv` using [xlsx2csv](https://github.com/dilshod/xlsx2csv) and then converted to YNAB format

```sh
./ynabCSVConverter.sh ORIGINAL.xlsx converted.csv
```

2) `csv` files will be considered to have been manually exported to CSV using Numbers and thus will receive additional awk processing (using `gawk`) based on the observed Numbers export behaviour (especially regarding date and amount formats).

```sh
./ynabCSVConverter.sh MANUALLY_EXPORTED.csv converted.csv
```

Note that mode 1 is the preferred one to use, we are leaving option 2. in case `xlsx2csv` stops working as expeected.