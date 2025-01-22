#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# Check if argument is a number
if [ -z "$1" ]; then
  echo Please provide an element as an argument.
else
  if  [[ "$1" =~ ^[0-9]+$ ]]; then
    OUTPUT=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1")
  else
    OUTPUT=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol LIKE '$1' OR name LIKE '$1'")
  fi
  # Check if the element was found
  if [ -z $OUTPUT ]; then
      echo I could not find that element in the database.
  else 
    # Split the output into an array
    IFS='|' read -r -a elements <<< "$OUTPUT"
    ATOMIC_NUMBER=${elements[1]}
    NAME=${elements[3]}
    SYMBOL=${elements[2]}
    TYPE=${elements[7]}
    MASS=${elements[4]}
    MELTING=${elements[5]}
    BOILING=${elements[6]}
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi