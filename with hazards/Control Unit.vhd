library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Control is
    Port (
	clk :in std_logic;
	OP : in std_logic_vector (5 downto 0) ;
	insertNOP: in std_logic;

	IN_EN: inout std_logic;
	WB :inout std_logic_vector (6 downto 0);
	M: inout std_logic_vector(2 downto 0);
	EX: inout std_logic_vector(7 downto 0));
	
end Control;

architecture dataflow of Control is

signal insertNOP_clk : std_logic;

begin
process (clk)
begin


if falling_edge(clk) then


insertNOP_clk <= insertNOP;

end if;
end process;


process (OP,insertNOP)
begin
		if OP = "000000" or insertNOP_clk='1' then --NOP
			IN_EN <='0';
			WB<= "0000000";
			M<= (others =>'0');
			EX(7)<='0';
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="000";

		elsif OP = "100000" then
		
			IN_EN <='0';
			WB<= "0000111";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="100";
			
		elsif OP = "000001" then
		
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="0100";
			EX(2 downto 0)<="000";
			
		elsif OP = "000010" then
		
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="0101";
			EX(2 downto 0)<="000";

		elsif OP = "000011" then
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="0110";
			EX(2 downto 0)<="000";

		elsif OP = "000100" then
			IN_EN <='0';
			WB<= "0100000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="000";
	   
		elsif OP = "000101" then
			
			IN_EN <='1';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="000";
			
		elsif OP = "000110" then
			IN_EN <='0';
			WB<= "1011000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1010";
			EX(2 downto 0)<="000";
						
		elsif OP = "000111" then
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1011";
			EX(2 downto 0)<="000";

		elsif OP = "001000" then
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="0001";
			EX(2 downto 0)<="000";

		elsif OP = "001001" then
		
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="0010";
			EX(2 downto 0)<="000";

		elsif OP = "001010" then
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="0011";
			EX(2 downto 0)<="000";

		elsif OP = "001011" then
			
			IN_EN <='0';
			WB<= "0000001";
			M<= "101";		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="100";

		elsif OP = "001100" then
			
			IN_EN <='0';
			WB<= "0001011";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="100";

		elsif OP = "001101" then
		
			IN_EN <='0';
			WB<= "1000000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1011";
			EX(2 downto 0)<="010";

		elsif OP = "001110" then
			
			IN_EN <='0';
			WB<= "1000000";
			M<= (others =>'0');		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="001";

		elsif OP = "001111" then
		
			IN_EN <='0';
			WB<= "1000001";
			M<= "001";
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="101";
				
		elsif OP = "010000" then
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='1';	 
			EX(6 downto 3)<="0111";
			EX(2 downto 0)<="000";

		elsif OP = "010001" then	
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='1';	 
			EX(6 downto 3)<="1000";
			EX(2 downto 0)<="000";

		elsif OP = "010010" then
			
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='1';	 
			EX(6 downto 3)<="1010";
			EX(2 downto 0)<="000";

		elsif OP = "010011" then
				
			IN_EN <='0';
			WB<= "1001000";
			M<= (others =>'0');		 
			EX(7)<='1';	 
			EX(6 downto 3)<="1011";
			EX(2 downto 0)<="000";

		elsif OP = "010100" then
			
			IN_EN <='0';
			WB<= "0001000";
			M<= "010";		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="100";

		else
			
			IN_EN <='0';
			WB<= "0000000";
			M<= "111";		 
			EX(7)<='0';	 
			EX(6 downto 3)<="1001";
			EX(2 downto 0)<="000";

		end if;
	
		
		
	
end process;
end dataflow;

