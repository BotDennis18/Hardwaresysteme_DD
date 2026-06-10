library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity PC_TB is
end PC_TB;
architecture TESTBENCH of PC_TB is

  -- Component declaration ...
  component PC
    port (
      clk              : in std_logic;
      reset, inc, load : in std_logic; -- Steuersignale
      pc_in            : in std_logic_vector (15 downto 0); -- Dateneingang
      pc_out           : out std_logic_vector (15 downto 0) -- Ausgabe Zaehlerstand
    );
  end component;

  -- Configuration ...
  --   EDIT HERE: Uncomment one of the following lines to select RTL or post simulation
  --for U_COUNTER: COUNTER use entity WORK.COUNTER(RTL);              -- normal (RTL) simulation
  --for U_COUNTER: COUNTER use configuration WORK.CFG_COUNTER_FINAL;  -- post simulation
  for U_PC : PC use entity WORK.PC(RTL);

  -- Clock period ...
  constant period : time := 10 ns;

  -- Signals ...
  signal clk_i                  : std_logic;
  signal reset_i, inc_i, load_i : std_logic;
  signal pc_in_i                : std_logic_vector (15 downto 0);
  signal pc_out_o               : std_logic_vector (15 downto 0);
begin

  -- Instantiate counter...
  U_PC : PC
  port map
  (
    clk    => clk_i,
    reset  => reset_i,
    inc    => inc_i,
    load   => load_i,
    pc_in  => pc_in_i,
    pc_out => pc_out_o
  );

  -- Process for applying patterns
  process
    -- Helper to perform one clock cycle...
    procedure run_cycle is
    begin
      clk_i <= '0';
      wait for period / 2;
      clk_i <= '1';
      wait for period / 2;
    end procedure;
  begin
    -- Initialisierung der Eingänge
    reset_i <= '0';
    inc_i   <= '0';
    load_i  <= '0';
    pc_in_i <= (others => '0');
    wait for period;

    --------------------------- RESET TEST ------------------------
    report "Teste Reset...";
    reset_i <= '1';
    run_cycle;
    assert unsigned(pc_out_o) = 0 report "FEHLER: Reset fehlgeschlagen!" severity error;
    reset_i <= '0';
    report "Reset erfolgreich.";

    --------------------------- INCREMENT TEST --------------------
    report "Teste Zaehlfunktion (inc)...";
    inc_i <= '1';
    run_cycle; -- Stand 1
    run_cycle; -- Stand 2
    assert unsigned(pc_out_o) = 2 report "FEHLER: Zaehler sollte auf 2 stehen!" severity error;
    inc_i <= '0';
    report "Zaehlen erfolgreich.";

    --------------------------- HOLD TEST -------------------------
    report "Teste Halten des Wertes...";
    -- Alle Steuersignale auf '0'
    reset_i <= '0';
    inc_i   <= '0';
    load_i  <= '0';
    run_cycle;
    assert unsigned(pc_out_o) = 2 report "FEHLER: Wert wurde nicht gehalten!" severity error;
    report "Halten erfolgreich.";

    --------------------------- LOAD TEST -------------------------
    report "Teste Laden (load) für Spruenge...";
    pc_in_i <= x"ABCD"; -- Zieladresse setzen
    load_i  <= '1';
    run_cycle;
    assert pc_out_o = x"ABCD" report "FEHLER: Laden von xABCD fehlgeschlagen!" severity error;
    load_i <= '0';

    -- Nochmal halten testen nach dem Laden
    run_cycle;
    assert pc_out_o = x"ABCD" report "FEHLER: Wert nach Load nicht gehalten!" severity error;
    report "Laden erfolgreich.";

    --------------------------- FERTIG ----------------------------
    assert false report "Simulation PC getestet finished" severity note;
    wait;
  end process;
end TESTBENCH;
