#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams cascade")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 # get team_id from winner
 WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
 OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
 if [[ $YEAR != year ]]
  then
    # if WINNER not found
    if [[ -z $WINNER_ID ]]
     then
      # insert WINNER team
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
       then
        echo Inserted into Teams, "$WINNER"
      fi 
      # get new winner_id
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
      echo $WINNER_ID
    fi
    # if OPPONENT not found
    if [[ -z $OPPONENT_ID ]]
    then
    # insert OPPONENT team
    INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
     then
      echo Inserted into Teams, "$OPPONENT" 
    fi
    # get new opponent_id
     OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
     echo $OPPONENT_ID
    fi
    #insert games
    INSERT_GAMES_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
     echo Inserted into Games: $WINNER - $OPPONENT $WINNER_GOALS:$OPPONENT_GOALS
    fi
 fi
done