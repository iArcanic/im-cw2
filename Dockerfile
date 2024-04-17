# Use an official PostgreSQL image as the base image
FROM postgres:latest

# Copy the SQL files
COPY sql/* /docker-entrypoint-initdb.d/

# Expose Postgres port
EXPOSE 5432
