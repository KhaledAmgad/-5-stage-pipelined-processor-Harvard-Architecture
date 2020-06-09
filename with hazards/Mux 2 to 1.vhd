library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity MUX_2T1 is
generic (regCount : natural := 32);
 Port ( SEL : std_logic;
 D0,D1: in std_logic_vector(regCount-1 downto 0);
 F : out std_logic_vector(regCount-1 downto 0));
end MUX_2T1;
architecture my_mux of MUX_2T1 is
begin
 F <= D0 when (SEL = '0') else
 D1 when (SEL = '1') else
 (others => '0');
end my_mux;