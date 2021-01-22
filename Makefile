RUSTINA ?= bin/rustina-x86_64.AppImage

SAMPLES = $(shell ls samples)
BATCH = $(SAMPLES:%.i=data/%.csv)
BATCHX = $(SAMPLES:%.i=data/%.woopt.csv)

help:
	@echo "Usage: make [-j] [ help | motivating | table1 | table2 | all ]"

all: motivating table1 table4

motivating: examples/motivating.i
	$(RUSTINA) -v $(shell pwd)/$<

table1: data/debian.csv
	scripts/table1.py $<

table4: data/debian.woopt.csv data/debian.csv
	scripts/table4.py $^

data/debian.csv: $(BATCH)
	@echo -n "project," > $@; head -n 1 $< >> $@
	@for f in $^; do \
		tail -n +2 $$f | \
		while read -r l; do \
			echo -n "$$(basename $$f .csv)," >> $@; \
			echo $$l >> $@; \
		done; \
	done

data/debian.woopt.csv: $(BATCHX)
	@echo -n "project," > $@; head -n 1 $< >> $@
	@for f in $^; do \
		tail -n +2 $$f | \
		while read -r l; do \
			echo -n "$$(basename $$f .woopt.csv)," >> $@; \
			echo $$l >> $@; \
		done; \
	done

$(BATCH) : data/%.csv : samples/%.i | data
	@$(RUSTINA) --batch $(shell pwd)/$@ $(shell pwd)/$< > /dev/null 2>&1

$(BATCHX) : data/%.woopt.csv : samples/%.i | data
	@$(RUSTINA) -x --batch $(shell pwd)/$@ $(shell pwd)/$< > /dev/null 2>&1

data:
	@mkdir data

clean:
	@rm -rf data/

.PHONY: clean help example overview
