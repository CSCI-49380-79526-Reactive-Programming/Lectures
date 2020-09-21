inheritance:
	pandoc -t slidy -s inheritance.md -o inheritance.html
inheritance-preview: inheritance
	gio open inheritance.html
