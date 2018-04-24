# Makefile
DOCKER_REPO=greaterthanfinance
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
	cd ui; sudo docker build --build-arg NODE_ENV=stage -t $(DOCKER_REPO)/$(UI_STAGE_NAME) .
	sudo docker push $(DOCKER_REPO)/$(UI_STAGE_NAME)

docker-ui-prod:
	cd ui; sudo docker build --build-arg NODE_ENV=production -t $(DOCKER_REPO)/$(UI_PROD_NAME) .
	sudo docker push $(DOCKER_REPO)/$(UI_PROD_NAME)

docker-api-stage:
	cd api; sudo docker build -t $(DOCKER_REPO)/$(API_STAGE_NAME) .
	sudo docker push $(DOCKER_REPO)/$(API_STAGE_NAME)

docker-api-prod:
	cd api; sudo docker build -t $(DOCKER_REPO)/$(API_PROD_NAME) .
	sudo docker push $(DOCKER_REPO)/$(API_PROD_NAME)

