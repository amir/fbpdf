PREFIX = .
CC = cc
CFLAGS = -Wall -O2 -I$(PREFIX)/include
LDFLAGS = -L$(PREFIX)/lib

all: fbpdf fbdjvu
%.o: %.c doc.h
	$(CC) -c $(CFLAGS) $<
clean:
	-rm -f *.o fbpdf fbdjvu fbpdf2

# pdf support using mupdf
fbpdf: fbpdf.o mupdf.o draw.o
	$(CC) -o $@ $^ $(LDFLAGS) -lmupdf -lmupdfthird -lcrypto -lm -lz -lharfbuzz -lfreetype -ljpeg -lopenjp2 -ljbig2dec

# djvu support
fbdjvu: fbpdf.o djvulibre.o draw.o
	$(CC) -o $@ $^ $(LDFLAGS) -ldjvulibre -ljpeg -lm -lstdc++ -lpthread

# pdf support using poppler
poppler.o: poppler.c
	$(CXX) -c $(CFLAGS) `pkg-config --cflags poppler-cpp` $<
fbpdf2: fbpdf.o poppler.o draw.o
	$(CXX) -o $@ $^ $(LDFLAGS) `pkg-config --libs poppler-cpp`
