.PHONY: dev bootstrap lint test check

## dev: one-command setup (tools, deps, git hooks)
dev: bootstrap

bootstrap:
	pre-commit install

lint:
	shellcheck -S error $$(git ls-files '*.sh')

test:
	@echo "no tests yet"

check: lint test
	pre-commit run --all-files
