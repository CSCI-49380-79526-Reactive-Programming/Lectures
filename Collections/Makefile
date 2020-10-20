FILE=collections
all:
	pandoc -t slidy -s $(FILE).md -o $(FILE).html
preview: all
	gio open $(FILE).html
