LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all; 
ENTITY RAM_4GB IS
	PORT(
		clk : IN std_logic;
		MemWrite : in std_logic	;
		writeData,Address1_DataMemory,Address2_DataMemory,Address_InstructionMemory: in STD_LOGIC_VECTOR (31 downto 0);
		readData_InstructionMemory: inout STD_LOGIC_VECTOR (15 downto 0);
		readData_DataMemory: inout STD_LOGIC_VECTOR (31 downto 0));
END RAM_4GB;

ARCHITECTURE syncrama OF RAM_4GB IS

	TYPE ram_type IS ARRAY(0   to 4096) OF std_logic_vector(15  downto 0);
	SIGNAL ram : ram_type := (
"0000000000000010",
"0000000000000000",
"0100100010000000",
"0000000000010000",
"0001010100000000",
"0000000000000000",
"0010110000010000",
"0010101000010100",
"0010011010010100",
"0011000110000000",
"0001000001000000",

	
	OTHERS =>(OTHERS => '0'));
	BEGIN
		PROCESS(clk) IS
			BEGIN
				if rising_edge(clk)  THEN  
						if MemWrite='1' THEN
							ram(to_integer(unsigned(Address1_DataMemory))) <= writeData(15 downto 0);
							ram(to_integer(unsigned(Address2_DataMemory))) <= writeData(31 downto 16);
						end if;
				end if;
		END PROCESS;
		readData_InstructionMemory<=ram(to_integer(unsigned(Address_InstructionMemory)));
		readData_DataMemory(15 downto 0)<=ram(to_integer(unsigned(Address1_DataMemory)));
		readData_DataMemory(31 downto 16)<=ram(to_integer(unsigned(Address2_DataMemory)));
END syncrama;