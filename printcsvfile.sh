#!/bin/bash

# Check if a file name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

# Function to print a horizontal line
function print_horizontal_line {
    header=$(head -n 1 $1)
    printf "+%s\n" "${header//,/+}+"
}

# Function to print table header
function print_table_header {
    print_horizontal_line $1
    printf "| %-20s | %-20s | %-20s |\n" $(head -n 1 $1 | tr ',' ' ')
    print_horizontal_line $1
}

# Function to print a row in the table
function print_table_row {
    printf "| %-20s | %-20s | %-20s |\n" $(echo $1 | tr ',' ' ')
}

# Main program

csv_file=$1

# Check if the file exists
if [ ! -f "$csv_file" ]; then
    echo "File $csv_file not found."
    exit 1
fi

# Print table header
print_table_header $csv_file

# Print table rows
tail -n +2 $csv_file | while IFS=, read -r line; do
    print_table_row "$line"
done

# Print the final horizontal line
print_horizontal_line $csv_file



print_table_header

    while IFS=, read -r project repo; do
        print_table_row $project $repo"
    done <"$HARBOR_URL.csv"    
print_horizontal_line
