#!/bin/bash
set -e

: ${GIS_DB:=tryton}
: ${DB_ENCODING:=UTF-8}

: ${GIS_USER:=tryton}
if [ "$GIS_PASSWORD" ]; then
    PASS="PASSWORD '$GIS_PASSWORD'"
else
    PASS="PASSWORD '$GIS_USER'"
fi

SQLDIR="/usr/share/postgresql/9.5/contrib/postgis-2.2/"

# Réalise toutes les actions avec l'utilisateur 'postgres'
export PGUSER=postgres

# Teste si la base de données existe
echo
echo "Vérifie l'existence de la base de données $GIS_DB..."
INIT=$(psql -d template1 -t <<-EOSQL
        SELECT COUNT(*) from pg_database where datname = '$GIS_DB';
EOSQL
)
INIT="$(echo "$INIT" | sed -e 's/^[ \t]*//;s/[ \t]*$//')"

if [ "${INIT}" == "0" ]; then
	echo "Crée le rôle $GIS_USER..."
	psql <<-EOSQL
		CREATE ROLE $GIS_USER WITH LOGIN $PASS CREATEDB;		
	EOSQL
	echo
	echo "Crée la base de données $GIS_DB..."
	psql <<-EOSQL
		CREATE DATABASE $GIS_DB WITH OWNER $GIS_USER ENCODING='$DB_ENCODING';		
	EOSQL
	echo
	echo "Ajoute l'extension postgis à la base de données $GIS_DB..."	
	psql --dbname $GIS_DB <<-EOSQL
		CREATE EXTENSION postgis;	    
	EOSQL
	echo
	echo "Ajoute l'extension postgis_topology à la base de données $GIS_DB..."	
	psql --dbname $GIS_DB <<-EOSQL
	    CREATE EXTENSION postgis_topology;		
	EOSQL
	echo
	echo "Ajoute l'extension fuzzystrmatch à la base de données $GIS_DB..."	
	psql --dbname $GIS_DB <<-EOSQL
	    CREATE EXTENSION fuzzystrmatch;
	EOSQL
	echo
	echo "Ajoute l'extension legacy à la base de données $GIS_DB..."	
	psql --dbname $GIS_DB -f $SQLDIR/legacy.sql
	echo
	echo "La base de données $GIS_DB est prête !"
else
    echo
	echo "La base de données $GIS_DB existe déjà, elle est prête !"
fi
