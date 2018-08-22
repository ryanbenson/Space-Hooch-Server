test:
	rspec -f documentation
cover:
	rspec && open coverage/index.html
