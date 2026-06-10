library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IR is
  port (
    clk    : in std_logic;
    load   : in std_logic; -- Steuersignal
    ir_in  : in std_logic_vector (15 downto 0); -- Dateneingang
    ir_out : out std_logic_vector (15 downto 0) -- Datenausgang
  );
end IR;

architecture RTL of IR is
begin
  -- Dieser Prozess wird bei jeder Änderung von 'clk' getriggert
  process (clk)
  begin
    if rising_edge(clk) then
      if load = '1' then
        -- Synchrones Laden des Befehlsregisters
        ir_out <= ir_in;
      end if;
    end if;
  end process;
end architecture RTL;
