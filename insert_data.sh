#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#  empty the rows in the tables of your database
echo $($PSQL "TRUNCATE TABLE games, teams")
#Insert Germany
#echo "$($PSQL "INSERT INTO teams(name) VALUES('Germany')")"
       #echo "Inserted into teams, Germany"

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 

 if [[ $WINNER != "winner" ]] 
   then

   # Check if the winner already exists in the teams table
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

   # If the winner does not exist, insert it
    if [[ -z $WINNER_ID ]]
     then
     INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

     if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
       then
       echo "Inserted into teams, $WINNER"
       fi
       
    
   # get new updated winners
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
 

   # Check if the team already exists in the teams table
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

   # If the winner does not exist, insert it
    if [[ -z $OPPONENT_ID ]]
     then
     INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

     if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
       then
       echo "Inserted into teams, $OPPONENT"
       fi
       
    fi
   # get new updated list of winners
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

fi
 



   # insert year
   INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round, winner_id, opponent_id, winner_goals,opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")

   if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
     then
     echo "Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
   fi
  

done




  


