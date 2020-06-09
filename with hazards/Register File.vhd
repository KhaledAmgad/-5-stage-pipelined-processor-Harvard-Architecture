LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all; 
ENTITY RegisterFile IS
generic (regCount : natural := 32);
	PORT(
		clk : IN std_logic;
		rst : in STD_LOGIC;
		RegWrite : in STD_LOGIC_VECTOR (1 downto 0)	;
		readReg1,readReg2,writeReg1,writeReg2 : in STD_LOGIC_VECTOR (2 downto 0);
		writeData1,writeData2: in STD_LOGIC_VECTOR (regCount-1 downto 0);
		readData1,readData2: inout STD_LOGIC_VECTOR (regCount-1 downto 0));
END RegisterFile;

ARCHITECTURE syncrama OF RegisterFile IS
	TYPE ram_type IS ARRAY(0 TO 7) OF std_logic_vector(regCount-1 downto 0);
	SIGNAL ram : ram_type := (OTHERS =>(OTHERS => '0'));
	BEGIN
		PROCESS(clk,rst) IS
			BEGIN
				if rst = '1' then
					ram <= (OTHERS =>(OTHERS => '0'));
				elsif falling_edge(clk)  THEN  
						if RegWrite(0)='1' THEN
							ram(to_integer(unsigned(writeReg1))) <= writeData1;
						end if;
						if RegWrite(1)='1' THEN
							ram(to_integer(unsigned(writeReg2))) <= writeData2;
						end if;
				end if;
		END PROCESS;
		readData1 <= ram(to_integer(unsigned(readReg1)));
		readData2 <= ram(to_integer(unsigned(readReg2)));
END syncrama;