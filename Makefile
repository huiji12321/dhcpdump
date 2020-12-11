CFLAGS=	 -Wall -g
LDFLAGS= -g
LIBS=	-lpcap

BIN_PATH = /usr/sbin
MAN_PATH = /usr/share/man/man8/

all: dhcpdump dhcpdump.8

clean:
	-rm dhcpdump.o dhcpdump dhcpdump.8

dhcpdump.8: dhcpdump.pod Makefile
	pod2man --section 8 \
		--date "23 June 2008" \
		--name "DHCPDUMP" \
		--center "User Contributed Software" \
		dhcpdump.pod dhcpdump.8

dhcpdump: dhcpdump.o
	${CC} ${LDFLAGS} -o $@ dhcpdump.o ${LIBS}

dhcpdump.o: dhcpdump.c dhcp_options.h Makefile
	${CC} ${CFLAGS} -c -o $@ dhcpdump.c

install: all
	cp dhcpdump $(BIN_PATH)
	cp dhcpdump.8 $(MAN_PATH)
	gzip -9n $(MAN_PATH)dhcpdump.8
