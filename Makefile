# Makefile
DOCKER_REPO=greaterthanfinance
UI_STAGE_NAME=cobudget-ui-stage
UI_PROD_NAME=cobudget-ui-prod
API_NAME=cobudget-api

all: docker-ui-stage docker-ui-prod docker-api

docker-ui-stage:
	cd ui; sudo docker build --build-arg NODE_ENV=stage -t $DOCKER_REPO/$UI_STAGE_NAME .
	sudo docker push $DOCKER_REPO/$UI_STAGE_NAME

docker-ui-prod:
	cd ui; sudo docker build --build-arg NODE_ENV=production -t $DOCKER_REPO/$UI_PROD_NAME .
	sudo docker push $DOCKER_REPO/$UI_PROD_NAME

docker-api:
	cd api; sudo docker build -t $DOCKER_REPO/$API_NAME .
	sudo docker push $DOCKER_REPO/$API_NAME