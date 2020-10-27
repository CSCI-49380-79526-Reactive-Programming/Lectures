FILE=collections
all:
	pandoc -t slidy -s $(FILE).md -o $(FILE).html --filter pandoc-plantuml # --lua-filter ./diagram-generator.lua
preview: all
	gio open $(FILE).html
