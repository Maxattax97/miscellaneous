# CINLUG: Watch and Column

## Watch

- Didn't know this command existed on nearly all Linux system
- I've always written my own equivalent with shell
- ... or just used UP + ENTER
- comes with procps-ng (on DNF)

```sh
watch df

# update every second
watch -n1 df

# highlight differences
watch -n1 -d df

# no header
watch -n1 -d -t df

# show waitonline / waitoffline
# watch ping, beep if fails
watch -b ping 8.8.8.8 -c 1 -W 2
```

## Column

- comes with util-linux (on DNF)
- secret JSON feature (no need for jq)

```sh
cat bank.csv

# wraps rows across terminal width
column bank.csv

# align into neat columns, except its using spaces
column -t bank.csv

# switch to separate on commas
column -t -s, bank.csv

# deconstruct header from data
head -n1 bank.csv
tail -n +2 bank.csv

# enable metadata (looks the same)
column -t -s, --table-columns="$(head -n1 bank.csv)" <(tail -n +2 bank.csv)

# convert to JSON
column -t -s, --table-columns="$(head -n1 bank.csv)" <(tail -n +2 bank.csv) -J

# change table key's name
column -t -s, --table-columns="$(head -n1 bank.csv)" <(tail -n +2 bank.csv) -J --table-name="financial_crisis"

# hide the balance column
column -t -s, --table-columns="$(head -n1 bank.csv)" <(tail -n +2 bank.csv) --table-hide="balance"
```

## Together

```sh
cp bank.csv live.csv
watch -d column -t -s, live.csv
echo "2026-02-04,253,-30,Join CINLUG" >> live.csv
```
