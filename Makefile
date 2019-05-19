# Makefile
# DOCKER_REPO=greaterthanfinance
UI_STAGE_NAME=cobudget-ui-stage
UI_PROD_NAME=cobudget-ui
API_STAGE_NAME=cobudget-api-stage
API_PROD_NAME=cobudget-api
STAGE_SSH=ssh stage.cobudget
PROD_SSH="ssh cobudget"

stage: docker-api-stage docker-ui-stage

prod: docker-api-prod docker-ui-prod

all: stage prod

docker-ui-stage:
	cd ui; sudo docker build --build-arg NODE_ENV=stage -t $(UI_STAGE_NAME) .
	sudo docker save -o $(UI_STAGE_NAME).saved $(UI_STAGE_NAME)

docker-ui-prod:
	cd ui; sudo docker build --build-arg NODE_ENV=production -t $(UI_PROD_NAME) .
	sudo docker save -o $(UI_PROD_NAME).saved $(UI_PROD_NAME)

docker-api-stage:
	cd api; sudo docker build -t $(API_STAGE_NAME) .
	sudo docker save -o $(API_STAGE_NAME).saved $(API_STAGE_NAME)

docker-api-prod:
	cd api; sudo docker build -t $(API_PROD_NAME) .
	sudo docker save -o $(API_PROD_NAME).saved $(API_PROD_NAME)

