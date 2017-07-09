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
	make puras-primmoneram

.PHONY: puras-primmonerad
puras-primmonerad:
	$(MAKE) -C src/primmonerad clean

.PHONY: puras-primmoneram
puras-primmoneram:
	cd src/primmoneram && qmake Testa-primmoneram.pro
	$(MAKE) -C src/primmoneram clean && rm src/primmoneram/Makefile
	cd src/primmoneram && qmake Primmoneram.pro
	$(MAKE) -C src/primmoneram clean && rm src/primmoneram/Makefile

# Testoj
.PHONY: testoj
testoj: testa-primmonerad testa-primmoneram

.PHONY: testa-primmonerad
testa-primmonerad:
	# $(MAKE) -C src/primmonerad test

.PHONY: testa-primmoneram
testa-primmoneram:
	cd src/primmoneram && qmake Testa-primmoneram.pro
	$(MAKE) -C src/primmoneram
	./src/primmoneram/testa-primmoneram

# Programoj
.PHONY: programoj
programoj: primmonerad primmoneram

.PHONY: primmonerad
primmonerad:
	$(MAKE) -C src/primmonerad

.PHONY: primmoneram
primmoneram:
	cd src/primmoneram && qmake Primmoneram.pro
	$(MAKE) -C src/primmoneram
