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
	make puras-servilo
	make puras-monujo

.PHONY: puras-servilo
puras-servilo:
	$(MAKE) -C src/servilo clean

.PHONY: puras-monujo
puras-monujo:
	cd src/monujo && qmake Primmonera-monujo.pro
	$(MAKE) -C src/monujo clean && rm src/monujo/Makefile
	cd src/monujo && qmake Testa-primmonera-monujo.pro
	$(MAKE) -C src/monujo clean && rm src/monujo/Makefile

# Testoj
.PHONY: testoj
testoj: testa-servilo testa-monujo

.PHONY: testa-servilo
testa-servilo:
	# $(MAKE) -C src/servilo testo

.PHONY: testa-monujo
testa-monujo:
	cd src/monujo && qmake Testa-primmonera-monujo.pro
	$(MAKE) -C src/monujo
	./src/monujo/testa-primmonera-monujo

# Programoj
.PHONY: programoj
programoj: servilo monujo

.PHONY: servilo
servilo:
	$(MAKE) -C src/servilo

.PHONY: monujo
monujo:
	cd src/monujo && qmake Primmonera-monujo.pro
	$(MAKE) -C src/monujo
