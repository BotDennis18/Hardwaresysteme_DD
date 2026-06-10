# ==========================================
# Dynamisches VHDL Simulation Makefile
# ==========================================

# Erkennt den Namen des aktuellen Ordners (z.B. "IR" oder "ALU")
PROJECT = $(shell basename $(CURDIR))

# Dateinamen basierend auf dem Projektnamen
SRC = $(PROJECT).vhdl
TB  = $(PROJECT)_tb.vhdl

# GHDL Kommando und Standard
GHDL = ees-ghdl
STD  = --std=08

.PHONY: all analyze simulate view clean help

# Standard-Ziel: Alles kompilieren und simulieren
all: analyze simulate

# Hilfe-Ziel: Dokumentation des Workflows
help:
	@echo "VHDL Simulation Workflow - Benutzung:"
	@echo "--------------------------------------"
	@echo "1. make analyze  - Prüft Syntax und kompiliert $(SRC) sowie $(TB)."
	@echo "2. make simulate - Baut die Testbench-Entity und führt die Simulation aus."
	@echo "3. make view     - Öffnet die Wellenform-Datei ($(PROJECT).ghw) in GTKWave."
	@echo "4. make clean    - Entfernt temporäre GHDL-Dateien und die Wave-Datei."
	@echo "Alternativ: 'make' ohne Argumente führt Schritt 1 und 2 direkt aus."

# 1. Analysieren (Kompilieren)
analyze:
	@echo "--- Schritt 1: Analysiere VHDL Dateien ---"
	@if [ -f $(SRC) ]; then $(GHDL) -a $(STD) $(SRC); else echo "Fehler: $(SRC) nicht gefunden!"; exit 1; fi
	@if [ -f $(TB) ]; then $(GHDL) -a $(STD) $(TB); fi

# 2. & 3. Elaborieren und Ausführen (Simulieren)
simulate:
	@if [ -f $(TB) ]; then \
		echo "--- Schritt 2 & 3: Bauen und Simulieren von $(PROJECT)_TB ---"; \
		$(GHDL) -e $(STD) $(PROJECT)_TB; \
		$(GHDL) -r $(STD) $(PROJECT)_TB --wave=$(PROJECT).ghw; \
	else \
		echo "--- Info: Keine Testbench ($(TB)) gefunden. Simulation wird uebersprungen. ---"; \
	fi

# 4. Anzeigen in GTKWave
view:
	@if [ -f $(PROJECT).ghw ]; then \
		echo "--- Schritt 4: Signalverlaufe anzeigen ---"; \
		gtkwave $(PROJECT).ghw & \
	else \
		echo "Fehler: Signaldatei $(PROJECT).ghw nicht gefunden. Führe zuerst 'make' aus."; \
	fi

clean:
	$(GHDL) --clean
	rm -f *.ghw *.cf