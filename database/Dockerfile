FROM postgres:9.6

COPY init-db.sh /docker-entrypoint-initdb.d/

HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD psql -c 'select 1' -d rd_jrd_ref_data -U rd_jrd_ref_data

EXPOSE 5432
