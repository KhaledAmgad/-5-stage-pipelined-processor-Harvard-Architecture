LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all; 
ENTITY pre_store IS
	PORT(
		clk : IN std_logic;
		MemWrite : in std_logic	;
		addressout,addressin: in STD_LOGIC_VECTOR (31 downto 0);
		readData: out STD_LOGIC_VECTOR (1 downto 0);
		const: out STD_LOGIC_VECTOR (1 downto 0);
		writeData: in STD_LOGIC_VECTOR (1 downto 0));
END pre_store;

ARCHITECTURE syncrama OF pre_store IS

	TYPE ram_type IS ARRAY(0   to 4096) OF std_logic_vector(1  downto 0);
	SIGNAL ram : ram_type := (
	
	OTHERS =>(OTHERS => '0'));
	BEGIN
		PROCESS(clk) IS
			BEGIN
				if rising_edge(clk)  THEN  
						if MemWrite='1' THEN
							ram(to_integer(unsigned(Addressin))) <= writeData(1 downto 0);
						end if;
				end if;
		END PROCESS;
			readData<=ram(to_integer(unsigned(Addressin)));
		  const<=ram(to_integer(unsigned(Addressout)));
		
END syncrama;

