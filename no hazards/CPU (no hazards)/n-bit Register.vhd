library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ckt_reg is
generic (regCount : natural := 16);
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
loadEn : in STD_LOGIC;
reg_in : in STD_LOGIC_VECTOR (regCount-1 downto 0);
reg_out : inout STD_LOGIC_VECTOR (regCount-1 downto 0));
end ckt_reg ;

architecture Behavioral of ckt_reg is
begin

process (clk, rst)
begin

if rst = '1' then

reg_out <= (others => '0');

elsif rising_edge(clk) then
if loadEn = '1' then

reg_out <= reg_in;

end if;
end if;
end process;

end Behavioral;