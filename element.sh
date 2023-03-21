PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else 
  ELEMENTPROP=$1
  if [[ "$ELEMENTPROP" =~ ^[0-9]+$ ]]
  then 
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ELEMENTPROP")
  else 
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE name='$ELEMENTPROP' OR symbol='$ELEMENTPROP'")
  fi

  if [[ -z $ELEMENT ]]
  then 
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while IFS="|" read AN SYMBOL NAME
    do
      TYPE_ID=$($PSQL "SELECT type_id FROM properties where atomic_number = $AN")
      TYPE=$($PSQL "SELECT type FROM types where type_id = $TYPE_ID")
      MASS=$($PSQL "SELECT atomic_mass FROM properties where atomic_number = $AN")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties where atomic_number = $AN")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties where atomic_number = $AN")

      echo "The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
