#!/bin/sh

set -e

# Réalise les actions avec l'utilisateur $POSTGRES_USER
export PGUSER="$POSTGRES_USER"
export GIS_DB="$GIS_DB"

# Crée la base de données modèle 'template_postgis'
psql --dbname="$POSTGRES_DB" <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Charge les extensions dans les base de données tryton, template_database et $POSTGRES_DB
for DB in "$GIS_DB" template_postgis "$POSTGRES_DB"; do
	echo "Charge les extensions PostGIS dans $DB"
	psql --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION postgis;
		CREATE EXTENSION postgis_topology;
		CREATE EXTENSION fuzzystrmatch;		
EOSQL
done
