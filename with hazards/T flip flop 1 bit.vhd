library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity T_FF is
port( clk : in STD_LOGIC;
rst : in STD_LOGIC;
loadEn : in STD_LOGIC;
T : in STD_LOGIC;
Q : inout STD_LOGIC);
end T_FF;
 
architecture Behavioral of T_FF is
signal tmp: std_logic;
begin
process (clk,rst)
begin
	if rst = '1' then

	tmp <= '0';


	elsif clk = '0' then
	 
		if T='0' and loadEn='1' then
			tmp <= tmp;
		elsif T='1' and loadEn='1' then
			tmp <= not (tmp);
		end if;
	end if;
end process;
Q <= tmp;
end Behavioral;
