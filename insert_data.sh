#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "DROP TABLE games;")"
echo "$($PSQL "DROP TABLE teams;")"
#create table
echo "$($PSQL "CREATE TABLE games();")"
echo "$($PSQL "CREATE TABLE teams();")"

#create columns
#teams
echo "$($PSQL "ALTER TABLE teams ADD COLUMN team_id SERIAL PRIMARY KEY NOT NULL;")"
echo "$($PSQL "ALTER TABLE teams ADD COLUMN name VARCHAR(30) UNIQUE NOT NULL;")"

#games
echo "$($PSQL "ALTER TABLE games ADD COLUMN year INT NOT NULL;")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN round VARCHAR(30) NOT NULL;")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN game_id SERIAL PRIMARY KEY NOT NULL;")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN winner_id INT REFERENCES teams(team_id) NOT NULL;")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN opponent_id INT REFERENCES teams(team_id) NOT NULL;")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN winner_goals INT NOT NULL;")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN opponent_goals INT NOT NULL;")"

#read file
cat ./games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#skip first line of csv
if [[ $YEAR == "year" ]]
then
  continue
else
  #add teams
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")" 
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"

  #add games
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
fi
done