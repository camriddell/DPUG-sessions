.PHONY: notebooks clean clean-ipynb clean-pixi

md_FILES := $(shell find . -name 'notes.md')
ipynb_FILES := $(md_FILES:.md=.ipynb)

%.ipynb: %.md
	( \
		set -e; \
		export PIXI_PROJECT_MANIFEST=$(<D)/pixi.toml; \
		pixi add jupytext jupyterlab; \
		pixi run jupytext --from myst --to notebook --execute $<; \
	)

clean-ipynb:
	find . -name notes.ipynb | xargs -I {} rm -r {}
	find . -type d -name .ipynb_checkpoints | xargs -I {} rm -r {}
clean-pixi:
	find . -name .pixi | xargs -I {} rm -r {}

publish:
	{ \
		set -e; \
		curbranch=$$(git rev-parse --abbrev-ref HEAD); \
		git switch --orphan main || git switch main; \
		trap 'git switch $$curbranch' EXIT; \
		git checkout dev -- .; \
		$(MAKE) notebooks; \
		git add .; \
		git commit -m "auto publish $$(date +'%Y-%m-%d %H:%M')"; \
		git push origin -u main; \
	}

notebooks: $(ipynb_FILES)
clean: clean-ipynb clean-pixi
