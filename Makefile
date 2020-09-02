RUSTINA ?= bin/rustina-x86_64.AppImage

SAMPLES = $(shell ls samples)
BATCH = $(SAMPLES:%.i=data/%.csv)

help:
	@echo "Usage: make [-j] [ help | example | overview ]"

example: example/test.i
	$(RUSTINA) -v $(shell pwd)/$<

overview: data/debian.csv
	script/overview.py $<

data/debian.csv: $(BATCH)
	@echo "project,file,func,id,line,size,extended,kind,patch,comments" > $@
	@for f in $^; do \
		tail -n +2 $$f | \
		while read -r l; do \
			echo -n "$$(basename $$f .csv)," >> $@; \
			echo $$l >> $@; \
		done; \
	done


$(BATCH) : data/%.csv : samples/%.i | data
	$(RUSTINA) --batch $(shell pwd)/$@ $(shell pwd)/$< > /dev/null 2>&1

data:
	@mkdir data

clean:
	@rm -rf data/

.PHONY: clean help example overview
