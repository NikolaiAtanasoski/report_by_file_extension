#!/bin/bash

set -Eeou pipefail

find_command="/usr/bin/find.exe"
sort_command="/usr/bin/sort.exe"
find_errorlog=""
results_file=""
dir_to_search=""

ask_for_dir(){
    clear
    printf "create a summary of files based by extension\n"
    printf "which directory do you want me to look into? (recursively) \n"
    printf "press enter to use current directory:\n  ${PWD}\n"
    printf "> "
    read dir_to_search
    dir_to_search=${dir_to_search:-$PWD}
    printf "creating summary for ${dir_to_search}\n"

}

prepare_log_files() {
    find_errorlog="errors.log"
    touch $find_errorlog
    echo "" >$find_errorlog

    results_file="results.log"
    touch $results_file
    echo "" >$results_file
}

print_to_file() {
    message=$1

    printf "$1"
    printf "$1" >>$results_file
}

find_files(){
    file_extensions=$($find_command $dir_to_search -type f -name '*.*' 2>$find_errorlog | sed 's|.*\.||' | $sort_command -u)

    for extension in $file_extensions; do
        files=$($find_command $dir_to_search -type f -name "*.$extension" 2>$find_errorlog)
        print_to_file "Extention: *.${extension}\n"
        print_to_file "  Files:\n"
        for file in $files; do
            print_to_file "    $file\n"
        done
        print_to_file "\n"
    done
}

print_goodbye(){
    printf "\n\ndone!\n"
    printf "open ${results_file} to look at your summary\n"
    read
}

main() {
    ask_for_dir
    prepare_log_files
    find_files
    print_goodbye    
}


main
exit 0
