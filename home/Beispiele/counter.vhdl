-- (C) 2013-2024 Gundolf Kiefer, Hochschule Augsburg, University of Applied Sciences
--
-- This is an example design file for various courses at the
-- Efficient Embedded Systems (EES) lab.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity COUNTER is
  port (
    clk      : in std_logic;
    down, up : in std_logic;
    cnt_out  : out std_logic_vector (3 downto 0)
  );
end COUNTER;
architecture RTL of COUNTER is
  signal state : unsigned (3 downto 0); -- := "0000";
begin

  -- Output function...
  cnt_out <= std_logic_vector (state);

  -- State transition function...
  process (clk)
  begin
    if rising_edge(clk) then
      if (down = '1' and up = '1') then
        state <= "0000";
      end if;
      if (down = '1' and up = '0') then
        state <= state - 1;
      end if;
      if (down = '0' and up = '1') then
        state <= state + 1;
      end if;
    end if;
  end process;

end RTL;
