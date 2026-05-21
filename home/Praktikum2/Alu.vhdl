library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ALU is
  port (
    a    : in std_logic_vector (15 downto 0); -- Eingang A
    b    : in std_logic_vector (15 downto 0); -- Eingang B
    sel  : in std_logic_vector (2 downto 0); -- Operation
    y    : out std_logic_vector (15 downto 0); -- Ausgan g
    zero : out std_logic -- gesetzt, falls Eingang B = 0
  );
end ALU;
architecture RTL of ALU is
begin
  -- Implementation for ALU operations

  process (a, b, sel)
  begin

    y <= (others => '0');

    case sel is
      when "000" => y  <= std_logic_vector (signed (a) + signed (b)); -- Addition
      when "001" => y  <= std_logic_vector(signed(a) - signed(b)); -- Subtraction
      when "010" => y  <= a and b; -- Bitweise AND
      when "011" => y  <= a or b; -- Bitweise OR
      when "100" => y  <= a xor b; -- Bitweise XOR
      when "101" => y  <= not a; -- Bitweise NOT von A
      when "110" => y  <= a(14 downto 0) & '0'; -- Logische Linksverschiebung von A um 1
      when "111" => y  <= '0' & a(15 downto 1); -- Logische Rechtsverschiebung von A um 1
      when others => y <= (others => '0'); -- Standardfall, falls sel ungültig ist
    end case;
  end process;

  zero <= '1' when (signed(b) = 0) else
    '0';
end architecture RTL;
