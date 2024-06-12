FROM flyway/flyway:10.13.0-alpine

COPY flyway.conf /flyway/conf/flyway.conf
COPY sql/migrations /flyway/sql/migrations

ENTRYPOINT ["flyway", "migrate"]