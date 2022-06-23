FILE=inheritance
all:
	pandoc -t slidy -s $(FILE).md -o $(FILE).html
self-contained:
	pandoc --self-contained -t slidy -s $(FILE).md -o $(FILE).html
preview: all
	gio open $(FILE).html
