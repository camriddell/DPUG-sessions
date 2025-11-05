.PHONY: all clean clean-ipynb clean-pixi

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

all: $(ipynb_FILES)
clean: clean-ipynb clean-pixi
