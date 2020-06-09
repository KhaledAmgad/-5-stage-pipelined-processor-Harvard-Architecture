library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ALU is
    Port (
	A,B : in std_logic_vector (31 downto 0) ;
	OP : in std_logic_vector (3 downto 0) ;
	rst :in std_logic;

	Zero: inout std_logic;
	CCR :inout std_logic_vector (3 downto 0);
	Res: inout std_logic_vector(31 downto 0));
	
end ALU;

architecture dataflow of ALU is
signal sumAndCarry  : std_logic_vector(32 downto 0);

signal Carry,setFlags : std_logic;

begin
process (A,B,OP,Res,sumAndCarry,Carry,rst,setFlags)
begin
	if OP = "1011" then
		sumAndCarry <= std_logic_vector(unsigned('0'&a)+ unsigned('0'&b));
		Res <=sumAndCarry(31 downto 0);
		Carry<=sumAndCarry(32);
		setFlags<='1';

	elsif OP = "0001" then
		sumAndCarry <= std_logic_vector(unsigned('0'&a)-unsigned('0'&b));
		Res <=sumAndCarry(31 downto 0);
		Carry<=sumAndCarry(32);
		setFlags<='1';
		
	elsif OP = "0010" then
		Res <= a and b;			
		sumAndCarry<=(others => '0');
		Carry <= '0';	
		setFlags<='1';		
	elsif OP = "0011" then
		Res <= a or b;			
		sumAndCarry<=(others => '0');
		Carry <= '0';
		setFlags<='1';
	
				
	elsif OP = "0100" then
		Res <= not(a);
		sumAndCarry<=(others => '0');
		Carry <= '0';
		setFlags<='1';
				
	elsif OP = "0101" then
		sumAndCarry <= std_logic_vector(unsigned('0'&a)+to_unsigned(1,33));
		Res <=sumAndCarry(31 downto 0);		
		Carry<=sumAndCarry(32);
		setFlags<='1';

								
				
	elsif OP = "0110" then
		sumAndCarry <= std_logic_vector(unsigned('0'&a)-to_unsigned(1,33));
		Res <=sumAndCarry(31 downto 0);		
		Carry<=sumAndCarry(32);
		setFlags<='1';

								
	elsif OP = "0111" then
		sumAndCarry <=STD_LOGIC_VECTOR(shift_left(unsigned('0'&a), to_integer(unsigned(b))));	
		Res <= 	sumAndCarry(31 downto 0);	
		Carry<=sumAndCarry(32);
		setFlags<='1';

										
										
	elsif OP = "1000" then
		sumAndCarry  <=STD_LOGIC_VECTOR(shift_right(unsigned(a&'0'), to_integer(unsigned(b))));				
		Res <= 	sumAndCarry(32 downto 1);	
		Carry<=sumAndCarry(0);
		setFlags<='1';

		
		

	elsif OP = "1001" then
		Res <=a;
		sumAndCarry<=(others => '0');
		Carry <= '0';		
		setFlags<='0';
		
	elsif OP = "1011" then
		Res <=a;
		sumAndCarry<=(others => '0');
		Carry <= '0';		
		setFlags<='0';
		CCR(0) <= '0';
		
		
	else
		Res <=b;
		sumAndCarry<=(others => '0');
		Carry <= '0';
		setFlags <='0';
		
	end if;
	
	if (setFlags='1' and rst='0' ) then	
	
		if Res = (31 downto 0 => '0') then
			CCR(0) <= '1';
		elsif Res /= (31 downto 0 => '0') then
			CCR(0) <= '0';
		end if;
		
		
		if Res(31) =  '1' then
			CCR(1) <= '1';
		elsif Res(31) =  '0'  then
			CCR(1) <= '0';
		end if;

		
		if Carry =  '1'  and (OP /="0010" or OP /="0011" or OP /="0100" ) then
			CCR(2) <= '1';
		elsif Carry =  '0'  and (OP /="0010" or OP /="0011" or OP /="0100" ) then
			CCR(2) <= '0';
		end if;
	
	elsif rst='1' then
		CCR <= (others => '0');
	
	end if;
		
		
	
end process;
Zero <=CCR(0);
end dataflow;

