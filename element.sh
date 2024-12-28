#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#CHECK IF AN ARGUMENT HAS BEEN PARSED
if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    #CHECK IF PARSED ARGUMENT EXISTS
    # Check if the input is an integer
    if [[ "$1" =~ ^[0-9]+$ ]] 
    then
      # If it's an integer, search by atomic_number
      ELEMENT_SEARCH=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number='$1';")
    else
      # If it's not an integer, search by symbol or name
      ELEMENT_SEARCH=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1' OR name='$1';")
    fi

    #IF ELEMENT DOES NOT EXIST
    if [[ -z "$ELEMENT_SEARCH" ]]
    then
      echo "I could not find that element in the database."
    else
      #GET AND OUTPUT THE INFORMATION
      read ELEMENT_ID BAR SYMBOL BAR NAME <<< "$ELEMENT_SEARCH"

      #GET ELEMENT PROPERTIES
      ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM properties LEFT JOIN types ON  properties.type_id = types.type_id WHERE atomic_number=$ELEMENT_ID;")
      read ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE <<< "$ELEMENT_PROPERTIES"
      
      echo "The element with atomic number $ELEMENT_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
fi