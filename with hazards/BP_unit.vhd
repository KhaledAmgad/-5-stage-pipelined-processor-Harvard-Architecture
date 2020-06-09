Library ieee;
use ieee.std_logic_1164.all;
entity BP_unit is
    port ( input: in std_logic;
          pcout,pcin :in std_logic_vector(31 downto 0);
            clk,rst,enable : in std_logic;
            taken: out std_logic);
    end entity;
-------------- Synchronized -------------
Architecture BP of BP_unit is
    COMPONENT pre_store IS
	PORT(
		clk : IN std_logic;
		MemWrite : in std_logic	;
		addressout,addressin: in STD_LOGIC_VECTOR (31 downto 0);
		readData: out STD_LOGIC_VECTOR (1 downto 0);
		const: out STD_LOGIC_VECTOR (1 downto 0);
		writeData: in STD_LOGIC_VECTOR (1 downto 0));
END COMPONENT;
        type states is (strongly_not_taken,weakly_not_taken,weakly_taken,strongly_taken);
        signal current_state ,new_state: states ;
        signal pwta,old,old2 : std_logic_vector(1 downto 0);
     begin
    
    store: pre_store port map (clk,enable,pcout,pcin,old,old2,pwta);
   
    current_state<= strongly_not_taken when (old="01")
  else weakly_not_taken when (old="11")
  else weakly_taken when (old="10")
  else strongly_taken;
        process (clk) 
            begin  
            if enable='1' then           
              if falling_edge(clk) then 
                case current_state is
                    when strongly_not_taken =>
                        if input = '1' then new_state <= weakly_not_taken; else new_state <= strongly_not_taken; end if;
                    when weakly_not_taken =>
                        if input = '1' then new_state <= weakly_taken; else new_state <= strongly_not_taken; end if;
                    when weakly_taken =>
                        if input = '1' then new_state <= strongly_taken; else new_state <= weakly_not_taken; end if;
                    when strongly_taken =>
                        if input = '1' then new_state <= strongly_taken; else new_state <= weakly_taken; end if;
                end case;
              end if;
            end if;
            end process;
        pwta <= "01" when (new_state= strongly_not_taken)
      else "11" when (new_state= weakly_not_taken)
      else "10" when (new_state= weakly_taken)
      else "00" when (new_state = strongly_taken);
    
    taken<= not old2(0);
    

           
    end Architecture; 