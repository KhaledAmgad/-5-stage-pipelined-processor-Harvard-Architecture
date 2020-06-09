library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity MUX_4T1 is
 Port ( SEL : in std_logic_vector(1 downto 0);
 D0,D1,D2,D3 : in std_logic_vector(31 downto 0);
 F : inout std_logic_vector(31 downto 0));
end MUX_4T1;
architecture my_mux of MUX_4T1 is
begin
 F <= D0 when (SEL = "00") else
 D1 when (SEL = "01") else
 D2 when (SEL = "10") else
 D3 when (SEL = "11") else
 (others => '0');
end my_mux;