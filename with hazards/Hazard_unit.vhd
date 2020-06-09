library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Hazard_unit is
 Port ( 
 R1_D,R2_D,RD_E : in std_logic_vector(2 downto 0);
 opFETCH : in std_logic_vector(5 downto 0);
 opDEC : in std_logic_vector(5 downto 0);
 enable : OUT std_logic;
 enable2: OUT std_logic);
end Hazard_unit;
architecture hazard of Hazard_unit is

begin
enable <= '1' when ((R1_D=RD_E)or(R2_D=RD_E))and ((opFETCH = "001100") or (opFETCH = "010100"))
else '0';
  
enable2<= '1' when  (opFETCH="100000")
else '0';
end hazard;



