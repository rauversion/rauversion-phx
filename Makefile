.PHONY: deploy install start format test coverage versions

install i:
	mix deps.get
	mix ecto.setup
	mix fake_accounts
	cd assets && yarn install

deploy d:
	mix assets.deploy

start server s:
	make deploy
	iex -S mix phx.server

format f:
	mix format

test t:
	mix test

coverage cover co:
	mix test --cover

versions v:
	@echo "Tool Versions"
	@cat .tool-versions
	@cat Aptfile
	@echo

