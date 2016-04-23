#!/bin/bash
set -e

# Vérifie la valeur par défaut du nom de la base données
GIS_DB=${GIS_DB:-"tryton"}

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $GIS_DB;
    CREATE DATABASE $GIS_DB;
    GRANT ALL PRIVILEGES ON DATABASE $GIS_DB TO $GIS_DB;
EOSQL
