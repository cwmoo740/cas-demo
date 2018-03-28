FROM postgres:10

ENV POSTGRES_USER db_user
ENV POSTGRES_PASSWORD db_password
ENV POSTGRES_DB authentication

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d/
