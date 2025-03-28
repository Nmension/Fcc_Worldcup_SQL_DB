#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #populate the teams table then use the ID to add it to the second table
  if [[ $WINNER != "winner" ]]
  then
    #checks if the team is already in the table
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    #if not found
    if [[ -z $TEAM_ID_W ]]
    then
      #INSERT TEAM NAME
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi
    #get the id of the inserted team
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    #checks if the team is already in the table
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    #if team doesn't exist yet
    if [[ -z $TEAM_ID_O ]]
    then
      #INSERT TEAM NAME
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi
    #get the id of the inserted team
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    
  fi
  #populate the second table
  if [[ $YEAR != "year" ]]
  then
    
    #insert GAME
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS);")
    
  fi
done