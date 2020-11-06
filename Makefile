CFLAGS=	 -Wall -g
LDFLAGS= -g  -fpie -pie -Wl,-z,relro
LIBS=	-lpcap
installbin = install -g root -o root -m 755
installdoc = install -g root -o root -m 644
BIN_PATH = /usr/bin
MAN_PATH = /usr/share/man/man8/

all: dhcpdump dhcpdump.8

clean:
	-rm dhcpdump.o dhcpdump dhcpdump.8
	-rm  stamp-build
	-rm  copyright.txt
	-rm  debian/dhcpdump.8 debian/dhcpdump.manpage

dhcpdump.8: dhcpdump.pod Makefile
	pod2man --section 8 \
		--date "23 June 2008" \
		--name "DHCPDUMP" \
		--center "User Contributed Software" \
		dhcpdump.pod dhcpdump.8
	cp dhcpdump.8 debian/
	echo debian/dhcpdump.8 > debian/dhcpdump.manpage

dhcpdump: dhcpdump.o
	${CC} ${LDFLAGS} -o $@ dhcpdump.o ${LIBS}

dhcpdump.o: dhcpdump.c dhcp_options.h Makefile
	${CC} ${CFLAGS} -c -o $@ dhcpdump.c
	touch stamp-build
	cat debian/copyright LICENSE > copyright.txt

install: all
	strip dhcpdump
	$(installbin) dhcpdump $(BIN_PATH)
	$(installdoc) dhcpdump.8 $(MAN_PATH)
	gzip -9n $(MAN_PATH)dhcpdump.8
