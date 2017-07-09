# Kopirajto (c) 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

MAKE=make -j8

# Ĉiuj
.PHONY: all
all:
	make puras
	make testoj
	make puras
	make programoj

# Puri
.PHONY: puras
puras:
	make puras-primmonerad
	make puras-primmonero

.PHONY: puras-primmonerad
puras-primmonerad:
	$(MAKE) -C src/primmonerad clean

.PHONY: puras-primmonero
puras-primmonero:
	cd src/primmonero && qmake Testa-primmonero.pro
	$(MAKE) -C src/primmonero clean && rm src/primmonero/Makefile
	cd src/primmonero && qmake Primmonero.pro
	$(MAKE) -C src/primmonero clean && rm src/primmonero/Makefile

# Testoj
.PHONY: testoj
testoj: testa-primmonerad testa-primmonero

.PHONY: testa-primmonerad
testa-primmonerad:
	# $(MAKE) -C src/primmonerad test

.PHONY: testa-primmonero
testa-primmonero:
	cd src/primmonero && qmake Testa-primmonero.pro
	$(MAKE) -C src/primmonero
	./src/primmonero/testa-primmonero

# Programoj
.PHONY: programoj
programoj: primmonerad primmonero

.PHONY: primmonerad
primmonerad:
	$(MAKE) -C src/primmonerad

.PHONY: primmonero
primmonero:
	cd src/primmonero && qmake Primmonero.pro
	$(MAKE) -C src/primmonero
