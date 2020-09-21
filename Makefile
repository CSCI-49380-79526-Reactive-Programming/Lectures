all:
	pandoc -t slidy -s README.md -o README.html
preview: all
	gio open README.html
