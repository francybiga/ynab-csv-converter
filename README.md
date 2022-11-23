# YNAB transactions CSV converter

Given a transaction file in the format used by [Intesa San Paolo](https://www.intesasanpaolo.com/) bank, convert it to the format require by [YNAB](https://youneedabudget.com/) File-Import.
The script makes assumptions on the format of the input files, but can be easily customized to make it work with similar CSV input files.
For more info about YNAB File-Import check the [guide](https://support.youneedabudget.com/en_us/file-based-import-a-guide-Bkj4Sszyo) and the [formatting specification](https://support.youneedabudget.com/en_us/formatting-a-csv-file-an-overview-BJvczkuRq)

### Requirements

The script uses `gawk` which, on macOS can be installed using `brew`:

```sh
brew install gawk
```

### Usage

```sh
./ynabCSVConverter.sh original.csv > converted.csv
```
