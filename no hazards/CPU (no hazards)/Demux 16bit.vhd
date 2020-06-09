library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DEMUX_SOURCE is
    Port (
	I : in std_logic_vector (15 downto 0) ;
	--read_enable : in std_logic ;
	rst,S : in std_logic;
	O1,O2: inout std_logic_vector(15 downto 0));
end DEMUX_SOURCE;

architecture dataflow of DEMUX_SOURCE is
begin
process (I,rst,S)
begin
	if rst = '1' then

	O1 <= (others => '0');
	O2 <= (others => '0');

	elsif S= '0' then
		O1 <= I;
	else
		O2 <= I;

	end if;
end process;

end dataflow;