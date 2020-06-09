library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity signExtend is
Port (
reg_in : in STD_LOGIC_VECTOR (15 downto 0);
reg_out : inout STD_LOGIC_VECTOR (31 downto 0));
end signExtend ;

architecture Behavioral of signExtend is
begin

process (reg_in)
begin

if reg_in(15) = '1' then

reg_out <=  "1111111111111111"&reg_in;
else
reg_out <=  "0000000000000000"&reg_in;
end if;

end process;

end Behavioral;