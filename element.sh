#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Kiểm tra nếu không truyền đối số
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Xác định đối số là số nguyên hay chuỗi
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
fi

# Kiểm tra nếu không tìm thấy nguyên tố trong CSDL
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_DATA"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi