library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Forward_unit is
 Port ( 
 R1_D,R2_D,RD_E,RD_W : in std_logic_vector(2 downto 0);
 WB_E,WB_W : in std_logic;
 SEL1 : out std_logic_vector(1 downto 0);
 SEL2 : OUT std_logic_vector(1 downto 0));
end Forward_unit;
architecture forward of Forward_unit is

begin
SEL1<= "01" WHEN  (R1_D = RD_E)AND (WB_E='1')
ELSE "10" WHEN (R1_D = RD_W) AND (WB_W='1') 
ELSE "00";
  
SEL2<= "01" WHEN  (R2_D = RD_E)AND (WB_E='1')
ELSE "10" WHEN (R2_D = RD_W) AND (WB_W='1') 
ELSE "00";
end forward;
