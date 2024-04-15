#/bin/sh
echo "Waiting for postgres..."
while ! nc -z database 5432; do
    sleep 0.1
done
echo "PostgreSQL started"
echo "Running migrations"
DATABASE_URL=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:5432/$POSTGRES_DB npm run migrate:up
echo "Migrations complete"
echo "Starting server"
while true; do
    npm run start
    echo "Server crashed, restarting in 5 seconds..."
    sleep 5
done
