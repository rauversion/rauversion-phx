.PHONY: deploy install start format test coverage versions cy.server cy.open cy.run

install i:
	mix setup

deploy d:
	mix assets.deploy

start server s:
	mix setup
	make deploy
	iex -S mix phx.server

format f:
	mix format

test t:
	mix test

cy.server:
	MIX_ENV=cy mix setup
	MIX_ENV=cy mix cy.account
	MIX_ENV=cy iex -S mix phx.server

cy.run:
	npx --yes cypress run

cy.open:
	npx --yes cypress open

coverage cover co:
	mix test --cover

versions v:
	@echo "Tool Versions"
	@cat .tool-versions
	@cat Aptfile
	@echo

