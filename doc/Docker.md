# Relevant docker commands

## Build the image

`docker build -t cobudget .`

## Run with DB on host (interactive)

This requires a password to be set for Postgresql user ubuntu. Connect with `psql` and use the `\password` command.

`docker run --network=host -e "DATABASE_URL=postgres://ubuntu:ubuntu@localhost/cobudget_development" cobudget rails s -b 0.0.0.0`

## Run postgresql from a container

Start the DB container

`docker run -d -p 5433:5432 postgres:9.6` 

Data is inside the container and will disappear when restartet. 

We're using port 5433, because we a database running on the host on port 5432.

Create user ubuntu:

`sudo -u postgres createuser -h localhost -p 5433 ubuntu -s`

Det er uklart om det er nødvendigt at skifte til bruger `postgres`

Create a database and load the data

```
createdb -h localhost -p 5433 cobudget_development
psql -h localhost -p 5433 -d cobudget_development < cobudget-prod-171129
```

Start cobudget on the host network connecting to docker DB:

`docker run --network=host -e "DATABASE_URL=postgres://ubuntu:ubuntu@localhost:5433/cobudget_development" cobudget rails s -b 0.0.0.0`

# Use a custom network

## Create the network

`docker network create --driver bridge cobudget`

Start the database on the newly created network. Map a directory where I can place the the DB dumps. For now, don't map the `data directory, as it will be easier to test stuff.

`docker run --network=cobudget --name=db -v /vagrant:/dbdump -e POSTGRES_DB=cobudget_development -e POSTGRES_USER=ubuntu -e POSTGRES_PASSWORD=pw -d postgres:9.6` 

Start cobudget

`docker run --network=cobudget --name=cobudget -e DATABASE_URL=postgres://ubuntu:pw@db/cobudget_development -p 3000:3000 -p 1080:1080 -d cobudget rails s -b 0.0.0.0`

Start the delayed job service and mailcatcher

```
sudo docker exec -it cobudget bin/delayed_job start
sudo docker exec -it cobudget mailcatcher --http-ip 0.0.0.0
```

## Other thougts

* Use database user cobudget like in in prod
* Run staging like it's prod (and set appropriate environment variables)
* Using the above setup could work with several staging environments on the same machine. We just need to solve what to do with port 3000, port 1080 and how to deploy the frontend.
* To begin with it would be ok to have one staging environment. Then I just need to find a way to update it automatically.
* Maybe travis can build and push a docker image. Then all we need is a way to pull and restart at the server.

