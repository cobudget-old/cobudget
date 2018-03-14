# Makefile

docker-ui:
	cd ui; gulp build; sudo docker build -t greatherthanfinance/cobudget-ui .
	sudo docker push greaterthanfinance/cobudget-ui

docker-api:
	cd api; sudo docker build -t greaterthanfinance/cobudget-api .
	sudo docker push greaterthanfinance/cobudget-api