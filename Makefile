# Makefile

docker-ui-stage:
	cd ui; export NODE_ENV=stage; gulp build; sudo docker build -t greaterthanfinance/cobudget-ui-stage .
	sudo docker push greaterthanfinance/cobudget-ui

docker-ui-prod:
	cd ui; export NODE_ENV=production; gulp build; sudo docker build -t greaterthanfinance/cobudget-ui-prod .
	sudo docker push greaterthanfinance/cobudget-ui-prod

docker-api:
	cd api; sudo docker build -t greaterthanfinance/cobudget-api .
	sudo docker push greaterthanfinance/cobudget-api