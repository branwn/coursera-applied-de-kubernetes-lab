install:
	pip3 install --upgrade pip &&\
		pip3 install -r requirements.txt

test:
	python3 -m pytest -vv --cov=main --cov=mylib test_*.py

format:	
	black *.py logic/*.py

lint:
	pylint --disable=R,C --ignore-patterns=test_.*?py --extension-pkg-whitelist='pydantic' *.py logic/*.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint


build:
	docker build -t cdfastapi .

push:
	docker tag cdfastapi:latest attend/fast-api-python:latest
	docker push attend/fast-api-python:latest

deploy:
	kubectl delete deployment hello-fastapi
	kubectl create deployment hello-fastapi --image=registry.hub.docker.com/attend/fast-api-python

all: install lint test format deploy
