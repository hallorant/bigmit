# On Mac OSX gcc is required as clang complains bitterly about the old style
# C delarations used.

CC=gcc
CXX=g++
DEP=zmac.o mio.o doc.o zi80dis.o

zmac: doc.inl $(DEP)
	$(CXX) -Wall $(CXXFLAGS) -o zmac $(DEP)

doc.inl: doc.c doc.txt
	$(CC) -Wall -DMK_DOC -o doc doc.c
	./doc >/dev/null

clean:
	rm -f zmac.c doc.inl $(DEP)
