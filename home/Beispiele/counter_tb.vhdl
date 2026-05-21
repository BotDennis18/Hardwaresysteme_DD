-- (C) 2013-2024 Gundolf Kiefer, Hochschule Augsburg, University of Applied Sciences
--
-- This is an example design file for various courses at the
-- Efficient Embedded Systems (EES) lab.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity COUNTER_TB is
end COUNTER_TB;
architecture TESTBENCH of COUNTER_TB is

  -- Component declaration ...
  component COUNTER
    port (
      clk      : in std_logic;
      down, up : in std_logic;
      cnt_out  : out std_logic_vector (3 downto 0)
    );
  end component;

  -- Configuration ...
  --   EDIT HERE: Uncomment one of the following lines to select RTL or post simulation
  --for U_COUNTER: COUNTER use entity WORK.COUNTER(RTL);              -- normal (RTL) simulation
  --for U_COUNTER: COUNTER use configuration WORK.CFG_COUNTER_FINAL;  -- post simulation

  -- Clock period ...
  constant period : time := 10 ns;

  -- Signals ...
  signal clk, down, up : std_logic;
  signal cnt_out       : std_logic_vector (3 downto 0);

begin

  -- Instantiate counter...
  U_COUNTER : COUNTERPORT
  map (
  clk => clk, down => down, up => up, cnt_out => cnt_out
  );

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
    for n in 1 to 2 loop run_cycle;
    end loop;
    down <= '0';
    up   <= '0';
    for n in 1 to 2 loop run_cycle;
    end loop;
    -- output must be all-'U' or all-'X' until now
    assert cnt_out = "UUUU" or cnt_out = "XXXX" report "Something seems to have been pre-initialized" severity warning;

    -- Reset counter...
    down <= '1';
    up   <= '1';
    run_cycle;
    assert cnt_out = "0000" report "Reset does not work";

    -- Count up and keep state...
    for n in 1 to 20 loop
      down <= '0';
      up   <= '1';
      run_cycle;
      assert cnt_out = std_logic_vector (to_unsigned (n mod 16, 4)) report "Counting up does not work";
      down <= '0';
      up   <= '0';
      run_cycle;
      assert cnt_out = std_logic_vector (to_unsigned (n mod 16, 4)) report "Keeping the state does not work";
    end loop;

    -- Count down and keep state...
    down <= '1';
    up   <= '1';
    run_cycle;
    for n in 15 downto integer(-5) loop
      down <= '1';
      up   <= '0';
      run_cycle;
      assert cnt_out = std_logic_vector (to_unsigned (n mod 16, 4)) report "Counting down does not work";
      down <= '0';
      up   <= '0';
      run_cycle;
      assert cnt_out = std_logic_vector (to_unsigned (n mod 16, 4)) report "Keeping the state does not work";
    end loop;

    -- Print a note & finish simulation...
    assert false report "Simulation finished" severity note;
    wait;

  end process;

end TESTBENCH;
