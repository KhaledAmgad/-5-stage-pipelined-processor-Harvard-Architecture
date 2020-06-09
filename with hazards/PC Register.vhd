library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pc_reg is
generic (regCount : natural := 16);
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
rst_value : in STD_LOGIC_VECTOR (regCount-1 downto 0);
loadEn : in STD_LOGIC;
reg_in : in STD_LOGIC_VECTOR (regCount-1 downto 0);
reg_out : inout STD_LOGIC_VECTOR (regCount-1 downto 0));
end Pc_reg ;

architecture Behavioral of Pc_reg is
begin

process (clk, rst)
begin

if rst = '1' then
reg_out <= rst_value;

elsif rising_edge(clk) then
if loadEn = '1' then

reg_out <= reg_in;

end if;
end if;
end process;

end Behavioral;