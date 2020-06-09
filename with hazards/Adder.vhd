library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity adder is
  port (
    a  : in STD_LOGIC_VECTOR (31 downto 0);
    b  : in STD_LOGIC_VECTOR (31 downto 0);
    --
    sum   : inout STD_LOGIC_VECTOR (31 downto 0));
end adder;
 
architecture rtl of adder is
begin
  sum   <= std_logic_vector(unsigned(a)+unsigned(b));

end rtl;
