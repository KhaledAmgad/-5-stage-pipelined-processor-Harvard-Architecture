library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Extend is
Port (
reg_in : in STD_LOGIC_VECTOR (19 downto 0);
reg_out : inout STD_LOGIC_VECTOR (31 downto 0));
end Extend ;

architecture Behavioral of Extend is
begin

reg_out <=  "000000000000" & reg_in;


end Behavioral;