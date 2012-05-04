.SUFFIXES: .d
DC=gdc
DFLAGS=-funittest -Wall -O2 -g
SRCS=$(wildcard *.d)
OBJS=$(patsubst %.d,%.o,$(wildcard *.d))

all: cf_parallel cf

cf_parallel: $(SRCS)
	$(DC) $(DFLAGS) -fversion=Parallel -o $@ $(SRCS)

cf: $(SRCS)
	$(DC) $(DFLAGS) -o $@ $(SRCS)

# .d.o:
#     $(DC) $(DFLAGS) -c -o $@ $<

clean:
	rm -f cf *.o
