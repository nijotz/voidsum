#!/bin/bash

# character to number
ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

scream_at_file() {
  if [ -d "$1" ]; then
    echo 'Is a directory';
    return;
  fi

  cat "$1" | scream;
}

scream() {
  # do a "real" checksum
  sha=$(sha256sum <&0);

  # add the character values in the checksum
  sum=0;
  for (( i=0; i<${#sha}; i++ )); do
    val=$(ord ${sha:$i:1});
    sum=$(( sum + val ));
  done

  # get a number between 5 and 125
  ayys=$(( $sum % 120 ));
  ayys=$(( $ayys + 5 ));

  # scream into the void
  s=$(printf "%-${ayys}s" "A")
  echo "${s// /A}"
}

# if there's no arguments, use stdin
if [ "$#" -eq 0 ]; then
  scream;

# if there's one file as an argument, just scream
elif [ "$#" -eq 1 ]; then
  scream_at_file $1;

# if there's more than one file argument, scream at all of them
elif [ "$#" -gt 1 ]; then
  for file in "$@"; do
    echo "$file: $(scream_at_file "$file")";
  done;
fi
