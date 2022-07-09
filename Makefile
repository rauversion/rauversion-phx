.PHONY: deploy install start format test coverage versions

install i:
	mix deps.get
	mix ecto.setup
	mix fake_accounts
	npm install --prefix assets

deploy d:
	mix assets.deploy

start server s:
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

