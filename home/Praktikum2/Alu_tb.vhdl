library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ALU_TB is
end ALU_TB;
architecture TESTBENCH of ALU_TB is

  -- Component declaration ...
  component ALU
    port (
      a    : in std_logic_vector (15 downto 0); -- Eingang A
      b    : in std_logic_vector (15 downto 0); -- Eingang B
      sel  : in std_logic_vector (2 downto 0); -- Operation
      y    : out std_logic_vector (15 downto 0); -- Ausgang
      zero : out std_logic -- gesetzt, falls Eingang B = 0
    );
  end component;

  -- Configuration ...
  --   EDIT HERE: Uncomment one of the following lines to select RTL or post simulation
  --for U_COUNTER: COUNTER use entity WORK.COUNTER(RTL);              -- normal (RTL) simulation
  --for U_COUNTER: COUNTER use configuration WORK.CFG_COUNTER_FINAL;  -- post simulation
  for U_ALU : ALU use entity WORK.ALU(RTL);

  -- Clock period ...
  constant period : time := 10 ns;

  -- Signals ...
  signal clk      : std_logic;
  signal i_sel    : std_logic_vector (2 downto 0);
  signal o_zero   : std_logic;
  signal o_y      : std_logic_vector (15 downto 0);
  signal i_a, i_b : std_logic_vector (15 downto 0);

begin

  -- Instantiate counter...
  U_ALU : ALU
  port map
  (
    a    => i_a,
    b    => i_b,
    y    => o_y,
    sel  => i_sel,
    zero => o_zero);

  -- Process for applying patterns
  process

    -- Helper to perform one clock cycle...
    procedure run_cycle is
    begin
      clk <= '0';
      wait for period / 2;
      clk <= '1';
      wait for period / 2;
    end procedure;

  begin

    -- Play with uninitialized state (may reveal design errors in specification)...
    --------------------------- ADDITION ------------------------
    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "000"; -- Addition
    i_a   <= std_logic_vector(to_unsigned(10, 16));
    i_b   <= std_logic_vector(to_unsigned(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;

    report "Sel : 000 ----- Addition -------";
      report to_string((signed(i_a)));
    report to_string((signed(i_b)));
    report "Das Ergebnis lautet: " & to_string(to_integer(signed(o_y)));
    assert signed(o_y) = 15 report "FEHLER: 10 + 5 ergab nicht 15!" severity error;
    report "Addition 10 + 5 erfolgreich getestet.";
    report "           ";

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "000"; -- Addition
    i_a   <= std_logic_vector(to_signed(10, 16));
    i_b   <= std_logic_vector(to_signed(-5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    assert signed(o_y) = 5 report "FEHLER: 10 + (-5) ergab nicht 5!" severity error;
    report "----------------- Das Ergebnis lautet: " & to_string(to_integer(signed(o_y)));
      assert false report "Addition mit Plus und Minus bestanden" severity note;
    report "           ";
    ---------------SUBTRAKTION-------------------
    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "001"; -- Subtraktion
    i_a   <= std_logic_vector(to_signed(10, 16));
    i_b   <= std_logic_vector(to_signed(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 001 ----- Subtraktion -------";
      report to_string((signed(i_a)));
    report to_string((signed(i_b)));
    report "----------------- Das Ergebnis lautet: " & to_string(to_integer(signed(o_y)));
      assert signed(o_y) = 5 report "FEHLER: Subtraktion 10 - 5 ergab nicht 5!" severity error;
    report "Subtraktion erfolgreich getestet.";
    report "           ";
    --------------AND--------------

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "010"; -- AND
    i_a   <= std_logic_vector(to_signed(5, 16));
    i_b   <= std_logic_vector(to_signed(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 010 ----- AND -------";
      report to_string((signed(i_a))) & " AND ";
    report to_string((signed(i_b)));
    report "----------------- Das Ergebnis lautet: ";
      report to_string((signed(o_y)));
    assert o_y = (i_a and i_b) report "FEHLER: AND-Operation fehlgeschlagen!" severity error;
    report "AND erfolgreich getestet.";
    report "           ";

    --------------OR--------------

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "011"; -- OR
    i_a   <= std_logic_vector(to_signed(5, 16));
    i_b   <= std_logic_vector(to_signed(15, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 011 ----- OR -------";
      report to_string((signed(i_a))) & " OR ";
    report to_string((signed(i_b)));
    report "----------------- Das Ergebnis lautet: ";
      report to_string((signed(o_y)));
    assert o_y = (i_a or i_b) report "FEHLER: OR-Operation fehlgeschlagen!" severity error;
    report "OR erfolgreich getestet.";
    report "           ";
    --------------XOR--------------

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "100"; -- XOR
    i_a   <= std_logic_vector(to_signed(7, 16));
    i_b   <= std_logic_vector(to_signed(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 100 ----- XOR -------";
      report to_string((signed(i_a))) & " XOR ";
    report to_string((signed(i_b)));
    report "-----------------  Das Ergebnis lautet: ";
      report to_string((signed(o_y)));
    assert o_y = (i_a xor i_b) report "FEHLER: XOR-Operation fehlgeschlagen!" severity error;
    report "XOR erfolgreich getestet.";
    report "           ";
    --------------NOT--------------

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "101"; -- NOT
    i_a   <= std_logic_vector(to_signed(7, 16));
    i_b   <= std_logic_vector(to_signed(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 101 ----- NOT -------";
      report to_string((signed(i_a))) & " NOT ";
    report "----------------- Das Ergebnis not von A lautet: ";
      report to_string((signed(o_y)));
    assert o_y = (not i_a) report "FEHLER: NOT-Operation fehlgeschlagen!" severity error;
    report "NOT erfolgreich getestet.";
    report "           ";
    --------------Left Shift--------------

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "110"; -- Left Shift
    i_a   <= std_logic_vector(to_signed(7, 16));
    i_b   <= std_logic_vector(to_signed(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 110 ----- Left Shift -------";
      report to_string((signed(i_a))) & " << ";
    report "----------------- Das Ergebnis lautet, A rechts 0 Aufgefüllt: ";
      report to_string((signed(o_y)));
    assert o_y = (i_a sll to_integer(unsigned(i_b))) report "FEHLER: Left Shift-Operation fehlgeschlagen!" severity error;
    report "Left Shift erfolgreich getestet.";
    report "           ";
    --------------Right Shift--------------

    for n in 1 to 2 loop run_cycle;
    end loop;
    i_sel <= "111"; -- Right Shift
    i_a   <= std_logic_vector(to_signed(7, 16));
    i_b   <= std_logic_vector(to_signed(5, 16));
    for n in 1 to 2 loop run_cycle;
    end loop;
    report "Sel : 111 ----- Right Shift -------";
      report to_string((signed(i_a))) & " >> ";
    report "----------------- Das Ergebnis lautet, A links 0 Aufgefüllt: ";
      report to_string((signed(o_y)));
    assert o_y = (i_a srl to_integer(unsigned(i_b))) report "FEHLER: Right Shift-Operation fehlgeschlagen!" severity error;
    report "Right Shift erfolgreich getestet.";
    report "           ";

    --------------Zero Flag--------------
    ---- fertigg ---- 
    assert false report "Simulation ALU getestet finished" severity note;
    wait;

  end process;
end TESTBENCH;
