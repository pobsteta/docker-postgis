# Postgis stack
#
# This image includes the following tools
# - Postgis 2.2
#
# Version 1.0

FROM pobsteta/docker-postgresql
MAINTAINER Pascal Obstetar <pascal.obstetar@bioecoforests.com>

# ---------- DEBUT --------------

# On évite les messages debconf
ENV DEBIAN_FRONTEND noninteractive

ENV POSTGIS_MAJOR 2.2

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
           postgis \          
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./init-user-db.sh /docker-entrypoint-initdb.d/init-user-db.sh

# ---------- FIN --------------
#
# Nettoie les APT
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
