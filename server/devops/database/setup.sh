export PGPASSWORD='password'
psql -U postgres -f devops/database/destroy_and_setup.sql
