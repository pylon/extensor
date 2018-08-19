ERLANG_PATH ?= $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)
CC           = g++
CFLAGS       = -std=c++11 -Wall -Werror -O3 -fpic \
               -Wl,-undefined,dynamic_lookup -shared \
               -I$(ERLANG_PATH)/include -L$(ERLANG_PATH)/lib
LIBS         = -ltensorflow
OBJDIR       = ../obj
OUTDIR       = ../priv

all: $(OUTDIR)/extensor.so

clean:
	$(RM) $(OUTDIR)/extensor.so

rebuild: clean all

$(OUTDIR)/extensor.so: extensor.cpp tf.cpp

%.so:
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

.PHONY: all clean rebuild
