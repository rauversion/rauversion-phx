.PHONY: deploy install start format test coverage versions ci-run ci-open

install i:
	mix setup

deploy d:
	mix assets.deploy

start server s:
	mix check
	make deploy
	iex -S mix phx.server

format f:
	mix format

test t:
	mix test

start server ci:
	MIX_ENV=cy iex -S mix phx.server

ci-run: 
	npx cypress run

ci-open: 
	npx cypress open

coverage cover co:
	mix test --cover

versions v:
	@echo "Tool Versions"
	@cat .tool-versions
	@cat Aptfile
	@echo

