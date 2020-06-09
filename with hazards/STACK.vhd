library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 

entity Stack is
generic (regCount : natural := 32);
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
SP_E,SP_SL : in STD_LOGIC;
reg_in : in STD_LOGIC_VECTOR (regCount-1 downto 0);
reg_out : inout STD_LOGIC_VECTOR (regCount-1 downto 0));
end Stack ;

architecture Behavioral of Stack is
COMPONENT MUX_2T1 is
 Port ( SEL : std_logic;
 D0,D1: in std_logic_vector(31 downto 0);
 F : inout std_logic_vector(31 downto 0));
end COMPONENT;



signal reg ,SP_PLUS: STD_LOGIC_VECTOR (regCount-1 downto 0); 
begin

process (clk,rst)
begin

if rst = '1' then

reg <= x"00000ffe";

elsif rising_edge(clk) then
if SP_E = '1' then

reg <= reg_in;

end if;
end if;
end process;
SP_PLUS<=std_logic_vector(unsigned(reg)+to_unsigned(2,regCount));
Mux : MUX_2T1 PORT MAP(SP_SL,reg,SP_PLUS,reg_out);
end Behavioral;