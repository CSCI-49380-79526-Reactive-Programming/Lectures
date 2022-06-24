FILE=collections
all:
	pandoc -t slidy -s $(FILE).md -o $(FILE).html --filter pandoc-plantuml
self-contained:
	pandoc --self-contained -t slidy -s $(FILE).md -o $(FILE).html --filter pandoc-plantuml
preview: all
	gio open $(FILE).html
