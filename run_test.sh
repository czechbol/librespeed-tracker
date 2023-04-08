#!/bin/sh

# Running the speedtest
result=$(speedtest-cli --csv)
header=$(speedtest-cli --csv-header)

# Speedtest results are empty, exitting
[[ -z "$result" ]] && { echo "No results" ; exit 1; }

if [ -f "/config/tests.db" ];
then
    # DB exists, header is not necessary
    output="$result"
else
    # DB does not exist, header is used to create table columns
    output="$header"$'\n'"$result"
fi

# Saving to the database
echo "$output" | sqlite3 -csv /config/tests.db ".import '| cat -' results"