LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all; 
ENTITY CPU IS
generic (regCount : natural := 32);
	PORT(
		clk,rst : IN std_logic;
		IN_PORT: in STD_LOGIC_VECTOR (31 downto 0);
		CCR :inout std_logic_vector (3 downto 0);
		OUT_PORT: out STD_LOGIC_VECTOR (31 downto 0));
END CPU;

ARCHITECTURE CPU_ARCH OF CPU IS

COMPONENT ckt_reg is
generic (regCount : natural := 16);
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
loadEn : in STD_LOGIC;
reg_in : in STD_LOGIC_VECTOR (regCount-1 downto 0);
reg_out : inout STD_LOGIC_VECTOR (regCount-1 downto 0));
END COMPONENT;

COMPONENT adder is
  port (
    a  : in STD_LOGIC_VECTOR (31 downto 0);
    b  : in STD_LOGIC_VECTOR (31 downto 0);
    --
    sum   : inout STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;


COMPONENT MUX_4T1 is
 Port ( SEL : in std_logic_vector(1 downto 0);
 D0,D1,D2,D3 : in std_logic_vector(31 downto 0);
 F : inout std_logic_vector(31 downto 0));
END COMPONENT;

COMPONENT RAM_4GB IS
	PORT(
		clk : IN std_logic;
		MemWrite : in std_logic	;
		writeData,Address1_DataMemory,Address2_DataMemory,Address_InstructionMemory: in STD_LOGIC_VECTOR (31 downto 0);
		readData_InstructionMemory: inout STD_LOGIC_VECTOR (15 downto 0);
		readData_DataMemory: inout STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

COMPONENT T_FF is
port( clk : in STD_LOGIC;
rst : in STD_LOGIC;
loadEn : in STD_LOGIC;
T : in STD_LOGIC;
Q : inout STD_LOGIC);
END COMPONENT;



COMPONENT DEMUX_SOURCE is
    Port (
	I : in std_logic_vector (15 downto 0) ;
	--read_enable : in std_logic ;
	rst,S : in std_logic;
	O1,O2: inout std_logic_vector(15 downto 0));
END COMPONENT;

COMPONENT Control is
    Port (
	clk: in std_logic;
	OP : in std_logic_vector (5 downto 0) ;
	insertNOP: in std_logic;

	IN_EN: inout std_logic;
	WB :inout std_logic_vector (6 downto 0);
	M: inout std_logic_vector(2 downto 0);
	EX: inout std_logic_vector(7 downto 0));
	
END COMPONENT;


COMPONENT RegisterFile IS
generic (regCount : natural := 32);
	PORT(
		clk : IN std_logic;
		rst : in STD_LOGIC;
		RegWrite : in STD_LOGIC_VECTOR (1 downto 0)	;
		readReg1,readReg2,writeReg1,writeReg2 : in STD_LOGIC_VECTOR (2 downto 0);
		writeData1,writeData2: in STD_LOGIC_VECTOR (regCount-1 downto 0);
		readData1,readData2: inout STD_LOGIC_VECTOR (regCount-1 downto 0));
END COMPONENT;

COMPONENT MUX_2T1 is
generic (regCount : natural := 32);
 Port ( SEL : std_logic;
 D0,D1: in std_logic_vector(regCount-1 downto 0);
 F : inout std_logic_vector(regCount-1 downto 0));
END COMPONENT;

COMPONENT signExtend is
Port (
reg_in : in STD_LOGIC_VECTOR (15 downto 0);
reg_out : inout STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT ;

COMPONENT Extend is
Port (
reg_in : in STD_LOGIC_VECTOR (19 downto 0);
reg_out : inout STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT ;


COMPONENT ALU is
    Port (
	A,B : in std_logic_vector (31 downto 0) ;
	OP : in std_logic_vector (3 downto 0) ;
	rst :in std_logic;

	Zero: inout std_logic;
	CCR :inout std_logic_vector (3 downto 0);
	Res: inout std_logic_vector(31 downto 0));
	
end COMPONENT;


COMPONENT Stack is
generic (regCount : natural := 32);
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
SP_E,SP_SL : in STD_LOGIC;
reg_in : in STD_LOGIC_VECTOR (regCount-1 downto 0);
reg_out : inout STD_LOGIC_VECTOR (regCount-1 downto 0));
end COMPONENT ;


COMPONENT Pc_reg is
generic (regCount : natural := 16);
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
rst_value : in STD_LOGIC_VECTOR (regCount-1 downto 0);
loadEn : in STD_LOGIC;
reg_in : in STD_LOGIC_VECTOR (regCount-1 downto 0);
reg_out : inout STD_LOGIC_VECTOR (regCount-1 downto 0));
end COMPONENT ;


signal pc_in,pc_out,pc_plusOne,readData1,ALU_OUT,ALU_IN_2,SP_OUT,SP_IN,writeData,ADDRESS,Address1_DataMemory,Address2_DataMemory,MR_OR_RES_SIG,EA_Extend : STD_LOGIC_VECTOR (31 downto 0);
signal IF_ID_OUT,IF_ID_IN : STD_LOGIC_VECTOR (63 downto 0);
signal ID_IE_OUT,ID_IE_IN : STD_LOGIC_VECTOR (174 downto 0);
signal IE_IM_OUT,IE_IM_IN : STD_LOGIC_VECTOR (131 downto 0);
signal IM_IW_OUT,IM_IW_IN : STD_LOGIC_VECTOR (140 downto 0);
signal outInstructionMemory : STD_LOGIC_VECTOR (15 downto 0);
signal PC_selector : STD_LOGIC_VECTOR (1 downto 0);
signal T,IN_EN,Zero,insertNOP,T_not : std_logic;
	BEGIN
	
	
	
		----------------fetch------------------------
		----------------------------------------------------------RAM_OUT---------------------------
		PC: Pc_reg generic map(regCount) PORT MAP (clk ,rst,IM_IW_IN(69 downto 38),'1',pc_in,pc_out); --PC regester
		PC_PLUS_ONE:adder PORT MAP (pc_out,x"00000001",pc_plusOne); --PC add 1
		PC_MUX:MUX_4T1 PORT MAP(PC_selector,pc_plusOne,ALU_OUT,MR_OR_RES_SIG,MR_OR_RES_SIG,pc_in); -- PC MUX
		-----------------------------MemWrite-------------------------------------------------------------------------------------------RAM_OUT--------------
		RAM:RAM_4GB PORT MAP(clk,IE_IM_OUT(122),writeData,Address1_DataMemory,Address2_DataMemory,pc_out,outInstructionMemory,IM_IW_IN(69 downto 38)); --RAM
		----------------------------------op[4]------------------------
		TFF: T_FF PORT MAP(clk,rst,'1',IF_ID_OUT(30),T); -- T flip flop
		---------------------------------------------------------------first 16----------------second 16 bit----
		DEMUX:DEMUX_SOURCE PORT MAP(outInstructionMemory,rst,T,IF_ID_IN(31 downto 16),IF_ID_IN(15 downto 0)); -- DEMUX
		IF_ID_IN(63 downto 32) <= pc_plusOne; -- first 32 bit (PC + 1)
		T_not <= not(T);
		IF_ID_0: ckt_reg generic map(32) PORT MAP (clk ,rst,'1',IF_ID_IN(63 downto 32),IF_ID_OUT(63 downto 32)); -- IF/ID Register
		IF_ID_1: ckt_reg generic map(16) PORT MAP (clk ,rst,T,IF_ID_IN(15 downto 0),IF_ID_OUT(15 downto 0)); -- IF/ID Register
		IF_ID_2: ckt_reg generic map(16) PORT MAP (clk ,rst,T_not,IF_ID_IN(31 downto 16),IF_ID_OUT(31 downto 16)); -- IF/ID Register
		---------------------------------------------
		
		
		
		
		
		----------------decode------------------------
		--------------------op[4]------
		insertNOP <= not(T) and IF_ID_OUT(30); -- stall / instert Nop (make control out nop)
		----------------------------------------op-----------------------------------W------------------------M---------------------------E--------------
		ControlUnit: Control PORT MAP(clk,IF_ID_OUT(31 downto 26),insertNOP,IN_EN,ID_IE_IN(174 downto 168),ID_IE_IN(167 downto 165),ID_IE_IN(164 downto 157));
		ID_IE_IN(156 downto 125)<=IF_ID_OUT(63 downto 32); --(pc + 1)
		ID_IE_IN(124 downto 122)<=IF_ID_OUT(25 downto 23); --Rd
		ID_IE_IN(57 downto 55)<=IF_ID_OUT(22 downto 20); --Rs1
		ID_IE_IN(54 downto 52)<=IF_ID_OUT(19 downto 17); --Rs2
		ID_IE_IN(19 downto 0)<=IF_ID_OUT(19 downto 0); --EA
		------------------------------------------------RegWrite------------------Rs1--------------------Rs2-------------------------WR1---------------------WR2---------------------D1 From write back--------------------------D2-----------
		RegFIle: RegisterFile PORT MAP(clk,rst,IM_IW_OUT(138 downto 137),IF_ID_OUT(22 downto 20),IF_ID_OUT(19 downto 17),IM_IW_OUT(5 downto 3),IM_IW_OUT(2 downto 0),MR_OR_RES_SIG,IM_IW_OUT(133 downto 102),readData1,ID_IE_IN(89 downto 58));
		------------------------------------------------------------D1----------
		INMUX:MUX_2T1 PORT MAP(IN_EN,readData1,IN_PORT,ID_IE_IN(121 downto 90));
		-----------------------------------IMM16-------------------IMM32---------
		signEx:signExtend PORT MAP(IF_ID_OUT(19 downto 4),ID_IE_IN(51 downto 20));
		ID_IE: ckt_reg generic map(175) PORT MAP (clk ,rst,'1',ID_IE_IN,ID_IE_OUT);
		---------------------------------------------

		
		
		
		
		----------------excute------------------------
		-----------------------------Jz-----------------JMP--------
		PC_selector(0)<=(Zero and ID_IE_OUT(158)) or ID_IE_OUT(157);
		------------------------------IMM?----------------D2----------------------IMM32-------------------
		IMM_MUX:MUX_2T1 PORT MAP(ID_IE_OUT(164),ID_IE_OUT(89 downto 58),ID_IE_OUT(51 downto 20),ALU_IN_2);	
		------------------------------------D1-----------------------------ALUOP--------------------------
		OUR_ALU:ALU  PORT MAP(ID_IE_OUT(121 downto 90),ALU_IN_2,ID_IE_OUT(163 downto 160),rst,Zero,CCR,ALU_OUT);
		IE_IM_IN(131 downto 125)<=ID_IE_OUT(174 downto 168); --WB
		IE_IM_IN(124 downto 122)<=ID_IE_OUT(167 downto 165); --M
		IE_IM_IN(121 downto 90)<=ID_IE_OUT(156 downto 125); --PC
		IE_IM_IN(89 downto 87)<=ID_IE_OUT(124 downto 122); --Rd
		IE_IM_IN(86 downto 55)<=ALU_OUT; --Res
		IE_IM_IN(54 downto 52)<=ID_IE_OUT(54 downto 52); --Rs2
		IE_IM_IN(51 downto 20)<=ID_IE_OUT(121 downto 90); --D1
		IE_IM_IN(19 downto 0)<=ID_IE_OUT(19 downto 0); --EA
		IE_IM: ckt_reg generic map(132) PORT MAP (clk ,rst,'1',IE_IM_IN,IE_IM_OUT);	
		---------------------------------------------
		
		
		
		
		
		----------------Memory------------------------
		-----------------------------SE_EN------------SP_SL-------------------
		SP:Stack PORT MAP (clk,rst,IM_IW_OUT(134),IE_IM_OUT(126),SP_IN,SP_OUT);
		------------------------------PC_or_d1-------------PC----------------------D1-------------
		PC_OR_D1:MUX_2T1 PORT MAP(IE_IM_OUT(124),IE_IM_OUT(121 downto 90),IE_IM_OUT(51 downto 20),writeData);
		-----------------------------------------EA----------------------
		EA_Extend_HW: Extend PORT MAP(IE_IM_OUT(19 downto 0),EA_Extend);
        ---------------------------------EA?------------------------------
		EA_OR_SP:MUX_2T1  PORT MAP(IE_IM_OUT(123),SP_OUT,EA_Extend,ADDRESS);	
		REST_PC:MUX_2T1 PORT MAP(rst,ADDRESS,x"00000000",Address1_DataMemory);	
		ADDRESS_PLUS:adder PORT MAP (Address1_DataMemory,x"00000001",Address2_DataMemory);	
		-------------------------------------------------------------W------------------------------------W--------------------
		IM_IW_IN(140 downto 134) <= IE_IM_OUT(131 downto 125) ; --WB
		IM_IW_IN(133 downto 102) <=IE_IM_OUT(51 downto 20); --D1
		IM_IW_IN(101 downto 70) <= SP_OUT; --SP
		--IM_IW_IN(69 downto 38) assigned on RAM
		IM_IW_IN(37 downto 6) <= IE_IM_OUT(86 downto 55); --Res
		IM_IW_IN(5 downto 3) <=  IE_IM_OUT(89 downto 87); --Rd
		IM_IW_IN(2 downto 0) <=  IE_IM_OUT(54 downto 52); --Rs2
		IM_IW: ckt_reg generic map(141) PORT MAP (clk ,rst,'1',IM_IW_IN,IM_IW_OUT);
		---------------------------------------------
		
		
		
		
		
		----------------write back------------------------
		---------------------Res----------------------OUT?-----------------------------------
		OUT_PORT <= IM_IW_OUT(37 downto 6) when (IM_IW_OUT(139) = '1' ) else  (OTHERS => 'Z');
		------------------------------MemtoReg-------------RAM out-----------------Res---------------------
		MR_OR_RES:MUX_2T1 PORT MAP(IM_IW_OUT(140),IM_IW_OUT(69 downto 38),IM_IW_OUT(37 downto 6),MR_OR_RES_SIG);
		----------------------PCWB-----
		PC_selector(1) <= IM_IW_OUT(136);
		-------------------------------------------SP----------------------------------------------SP_SL------------------------------------SP----------
		SP_IN <= std_logic_vector(unsigned(IM_IW_OUT(101 downto 70))-to_unsigned(2,32))  when (IM_IW_OUT(135) = '0' ) else IM_IW_OUT(101 downto 70);
		---------------------------------------------
		

		
		
		
		
		
END CPU_ARCH;