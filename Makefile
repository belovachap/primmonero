# Kopirajto (c) 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

MAKE=make -j4

# Ĉiuj
.PHONY: all
all:
	make testoj
	make programoj

# Puri
.PHONY: puras
puras:
	make puras-servilo

.PHONY: puras-servilo
puras-servilo:
	$(MAKE) -C src/servilo clean

# Testoj
.PHONY: testoj
testoj: testa-servilo

.PHONY: testa-servilo
testa-servilo:
	$(MAKE) -C src/servilo testo

# Programoj
.PHONY: programoj
programoj: servilo

.PHONY: servilo
servilo:
	$(MAKE) -C src/servilo

