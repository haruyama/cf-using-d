.SUFFIXES: .d
DC=gdc
DFLAGS=-funittest -Wall -O2 -g
OBJS=$(patsubst %.d,%.o,$(wildcard *.d))

cf: $(OBJS)
	$(DC) $(DFLAGS) -o $@ $(OBJS)

.d.o:
	$(DC) $(DFLAGS) -c -o $@ $<

clean:
	rm -f cf *.o
