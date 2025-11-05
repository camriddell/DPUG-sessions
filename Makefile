.PHONY: all clean clean-ipynb clean-pixi

md_FILES := $(shell find . -name 'notes.md')
ipynb_FILES := $(md_FILES:.md=.ipynb)

%.ipynb: %.md
	pixi add --manifest-path $(<D)/pixi.toml jupytext jupyterlab
	pixi run --manifest-path $(<D)/pixi.toml jupytext --to notebook --execute $<

clean-ipynb:
	find . -name notes.ipynb | xargs -I {} rm -r {}
	find . -type d -name .ipynb_checkpoints | xargs -I {} rm -r {}
clean-pixi:
	find . -name .pixi | xargs -I {} rm -r {}

all: $(ipynb_FILES)
clean: clean-ipynb clean-pixi
