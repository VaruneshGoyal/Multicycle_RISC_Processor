library work;
use work.Microprocessor_project.all;
library ieee;
use ieee.std_logic_1164.all;

entity IITB_RISC_Controlpath is
	port (
		carry_flag, zero_flag: in std_logic;
		carry_en, zero_en: out std_logic;
		zero_mux_ctrl: out std_logic;
		Rpe_zero_checker: in std_logic;
		mem_read_en, mem_write_en, mem_address_mux_ctrl: out std_logic;		
		IR_en: out std_logic;							
		Rpe_mux_ctrl: out std_logic; -- rpe_mux_cntrl
		D3_mux_ctrl: out std_logic_vector(1 downto 0);
		A1_mux_ctrl: out std_logic_vector(1 downto 0);
		A3_mux_ctrl: out std_logic;
		R7_mux_ctrl: out std_logic; -- pc_muc cntrl
		RegFile_write, PC_write: out std_logic;
		T1_mux_ctrl: out std_logic_vector(1 downto 0);	
		T1_en: out std_logic;
		T2_mux_ctrl: out std_logic;
		T2_en: out std_logic;
		Rpe_en: out std_logic;
		Z_mux_ctrl: out std_logic;
		Alu_uppermux_ctrl: out std_logic_vector(1 downto 0);
		Alu_lowermux_ctrl: out std_logic_vector(1 downto 0);
		Alu_signal_mux_ctrl: out std_logic;
		Alu_decoder_signal: out std_logic_vector(1 downto 0);
		T3_mux_ctrl: out std_logic_vector(1 downto 0);
		T3_en: out std_logic;
		clk, reset: in std_logic;
		Inst: in std_logic_vector(15 downto 0);			--check if all necessary
		S1_Decoder, S2_decoder, S3_decoder, S6_decoder, S12_decoder : in std_logic_vector(3 downto 0);
		ALU_Decoder: in std_logic_vector(1 downto 0);
		Carry_Decoder, zero_Decoder: in std_logic
	     );
end entity IITB_RISC_Controlpath;

architecture Behave of IITB_RISC_Controlpath is
	signal fsm_state : std_logic_vector(3 downto 0) := "0001";
	constant reset_state : std_logic_vector(3 downto 0) := "0000";
	constant instruction_fetch : std_logic_vector(3 downto 0) := "0001";
	constant S2 : std_logic_vector(3 downto 0) := "0010";
	constant S3 : std_logic_vector(3 downto 0) := "0011";
	constant S40: std_logic_vector(3 downto 0) := "1111";
	constant S4 : std_logic_vector(3 downto 0) := "0100";
	constant S5 : std_logic_vector(3 downto 0) := "0101";
	constant S6 : std_logic_vector(3 downto 0) := "0110";
	constant S7 : std_logic_vector(3 downto 0) := "0111";
	constant S8 : std_logic_vector(3 downto 0) := "1000";
	constant S9 : std_logic_vector(3 downto 0) := "1001";
	constant S10: std_logic_vector(3 downto 0) := "1010";
	constant S11: std_logic_vector(3 downto 0) := "1011";
	constant S12: std_logic_vector(3 downto 0) := "1100";
	constant S13: std_logic_vector(3 downto 0) := "1101";
	constant S14: std_logic_vector(3 downto 0) := "1110";



begin

   process(fsm_state, clk, reset)
      variable next_state : std_logic_vector(3 downto 0);
      variable vcarry_en, vzero_en: std_logic;
      variable vzero_mux_ctrl: std_logic;
      variable vmem_read_en, vmem_write_en, vmem_address_mux_ctrl: std_logic;		
      variable vIR_en: std_logic;							
      variable vRpe_mux_ctrl: std_logic;
      variable vD3_mux_ctrl: std_logic_vector(1 downto 0);
      variable vA1_mux_ctrl: std_logic_vector(1 downto 0);
      variable vA3_mux_ctrl: std_logic;
      variable vR7_mux_ctrl: std_logic;
      variable vRegFile_write, vPC_write: std_logic;
      variable vT1_mux_ctrl: std_logic_vector(1 downto 0);	
      variable vT1_en: std_logic;
      variable vT2_mux_ctrl: std_logic;
      variable vT2_en: std_logic;
      variable vAlu_uppermux_ctrl: std_logic_vector(1 downto 0);
      variable vAlu_lowermux_ctrl: std_logic_vector(1 downto 0);
      variable vAlu_decoder_signal: std_logic_vector(1 downto 0);
      variable vALU_ctrl: std_logic_vector(1 downto 0);
      variable vT3_mux_ctrl: std_logic_vector(1 downto 0);
      variable vT3_en: std_logic;
      variable vRpe_en: std_logic;
      variable vZ_mux_ctrl: std_logic; 
   begin
       -- defaults
       next_state:= reset_state;
       vcarry_en := '0'; vzero_en := '0'  ;
       vzero_mux_ctrl := '0';
       vmem_read_en:= '0'; vmem_write_en:= '0'; vmem_address_mux_ctrl:= '0';		
       vIR_en := '0';							
       vRpe_mux_ctrl := '0';
       vD3_mux_ctrl := "00";
       vA1_mux_ctrl := "00";
       vA3_mux_ctrl := '0';
       vR7_mux_ctrl := '0';
       vRegFile_write := '0';
       vPC_write := '0';
       vT1_mux_ctrl := "00";	
       vT1_en:= '0';
       vT2_mux_ctrl:= '0';
       vT2_en:= '0';
       vAlu_uppermux_ctrl:= "00";
       vAlu_lowermux_ctrl:= "00";
       vAlu_decoder_signal := "00";
       vALU_ctrl:= "00";
       vT3_mux_ctrl:= "00";
       vT3_en:= '0';
       vZ_mux_ctrl:= '0';

       case fsm_state is 
	  when reset_state => 
		next_state := instruction_fetch;

          when instruction_fetch =>		--2, 5, 8, 10, 13
		vmem_address_mux_ctrl := '1';
		vmem_read_en := '1';
		vIR_en := '1';
                next_state := S1_decoder;

          when S2 => 				--1, 3, 9
		vA1_mux_ctrl(0) := Inst(14);
		-- in this state vA1_mux_ctrl(1) := '0';
		vR7_mux_ctrl := '1';
		vPC_write := '1'; --- bit reversed !!
		vT1_mux_ctrl(0) := Inst(12) or (Inst(14) and (not Inst(15)));
		vT1_en:= '1';
		vT2_mux_ctrl := '1';
		vT2_en := '1';
		next_state := S2_decoder;
		--valu_upper_mux_cntrl := "00";
		--valu_lower_mux_cntrl := "00";
	  when S3 =>				--1, 4, 6, 7
		vA1_mux_ctrl := "01";
		vT1_en := '1';
		--vT1_mux_cntrl :="00";
		valu_uppermux_ctrl := "01";
		vT3_mux_ctrl:= "01";
		vT3_en:= '1';
		valu_lowermux_ctrl := "10";
		vAlu_decoder_signal := ALU_decoder;
		vcarry_en := Carry_decoder;
		vzero_en := Zero_decoder;
		next_state := S3_decoder;

	  when S4 =>				--1
		vD3_mux_ctrl:= "01";
		vA3_mux_ctrl:= '1';
		vRegFile_write := '1';
		vT3_en:= '0'; -- check . Reversed!! 
		next_state := instruction_fetch;

	  when S40 => 				--4
		vmem_read_en := '1';
		--vmem_addr_mux_ctrl :='0';
		vT3_en:= '1';
		--vt3_mux_ctrl:= "00";
		vZ_mux_ctrl:= '1'; --new inclusion !!
		vzero_mux_ctrl := '1';
		--vcarry_en := '0';  --for the LW instruction only is this state used
		vzero_en := Zero_decoder;
		next_state := S4;

	  when S5 =>				--1
		vA3_mux_ctrl:= '1';
		--vD3_mux_cntrl :="00";
		vR7_mux_ctrl:= '1';
		--vAlu_lower_mux := "00";
		--vAlu_upper_mux := "00";
		--vAlu_decoder_signal := "00";
		vRegFile_write := '1';
		vPC_write := '1';  -- bit reversed !!
		next_state := instruction_fetch;

          when S6 =>				--1, 7, 14
	       --vcarry_en := '0'; vzero_en := '0'  ;
	       vmem_write_en:= '1';
	       vAlu_uppermux_ctrl:= "10";
	       vT3_en:='1'; -- new inclusion !!!
	       vT3_mux_ctrl:= "01"; -- new inclusion !!!
		--vAlu_lowermux_ctrl:= "00";
		--vMem_addr_mux_cntrl :='0';
		--vRpe_mux_cntrl :='0';
		vRpe_en :='1'; -- new inclusion !!!  
		next_state := S6_decoder;

	  when S7 =>				--1
	       vR7_mux_ctrl := '1';
	       vPC_write := '1';
	       vAlu_lowermux_ctrl(0):=not(Inst(13)); -- bit reversed !!
		vAlu_lowermux_ctrl(1):= '0';
		--vAlu_decoder_signal := "00";
	   	--vAlu_uppermux_ctrl :="00";
		next_state := instruction_fetch;

	  when S8 =>				--9
	       vT2_en:= '1';
		--vT2_mux_cntrl := "00";
		--vAlu_uppermux_ctrl: ="00";
		--vAlu_lowermux_ctrl: ="00";
		--vAlu_decoder_signal := "00";
	       vT3_mux_ctrl:= "01";
	       vT3_en:= '1';
		next_state := S9;

	  when S9 =>				--1
	       vD3_mux_ctrl := "01";
		vA3_mux_ctrl:='1' ; -- new inclusion !!
	       vR7_mux_ctrl := not(Inst(12)); -- bit reversed !!
	       vRegFile_write := '1';
	       vPC_write := '1';
		valu_lowermux_ctrl := "10";
		--valu_uppermux_ctrl := "00";
		--vAlu_decoder_signal := "00";
		next_state := instruction_fetch;

	  when S10 => 				--11						
	       vRpe_mux_ctrl := '1';
		vRpe_en :='1'; -- new inclusion !!
	       vA1_mux_ctrl := "01";
	       vt3_mux_ctrl :="10"; -- new inclusion !!
	       vR7_mux_ctrl := '1';
	       vPC_write := '1';
		--vAlu_uppermux_ctrl:= "00";
	       vAlu_lowermux_ctrl:= "00"; -- MSB reversed !!
		--vAlu_decoder_signal := "00";
	       vT3_en:= '1';
		next_state := S11;

	  when S11 =>				--12
	       vmem_read_en:= '1';
		-- vmem_write_en :='0';	
	       vT1_mux_ctrl := "10";	
	       vT1_en:= '1';
		--vmem_addr_mux_ctlr :='0';
		next_state := S12;

	  when S12 =>				--1, 11
	       vD3_mux_ctrl := "10";
		--vA3_mux_ctrl :='0';
	       vRegFile_write := '1';
	       vAlu_uppermux_ctrl:= "10";
		--vAlu_lowermux_ctrl:= "00";
		--vAlu_decoder_signal := "00";
	       vT3_mux_ctrl:= "01";
	       vT3_en:= '1';
		vRpe_en := '1'; -- new inclusion !!
		--vRpe_mux_ctrl :='0';
		next_state := S12_decoder;

	  when S13 =>				--14							
	       vRpe_mux_ctrl := '1';
		vRpe_en := '1'; -- new inclusion !!
	       vA1_mux_ctrl := "01";
	       vT3_mux_ctrl:= "10";
	       vT3_en:= '1';
		next_state := S14;

	  when S14 =>				--6
	       vA1_mux_ctrl := "10";	
	       vT1_en:= '1';
		--vT1_mux_ctrl := "00";
		next_state := S6;
	
	  when others =>
		next_state := reset_state;

     end case;

       carry_en <= vcarry_en; zero_en <= vzero_en;
       zero_mux_ctrl <= vzero_mux_ctrl;
       mem_read_en <= vmem_read_en; mem_write_en <= vmem_write_en; mem_address_mux_ctrl <= vmem_address_mux_ctrl;		
       IR_en <= vIR_en;							
       Rpe_mux_ctrl <= vRpe_mux_ctrl;
       D3_mux_ctrl <= vD3_mux_ctrl;
       A1_mux_ctrl <= vA1_mux_ctrl;
       A3_mux_ctrl <= vA3_mux_ctrl;
       R7_mux_ctrl <= vR7_mux_ctrl;
       RegFile_write <= vRegFile_write;
       PC_write <= vPC_write;
       T1_mux_ctrl <= vT1_mux_ctrl;	
       T1_en <= vT1_en;
       T2_mux_ctrl <= vT2_mux_ctrl;
       T2_en <= vT2_en;
       Alu_uppermux_ctrl <= vAlu_uppermux_ctrl;
       Alu_lowermux_ctrl <= vAlu_lowermux_ctrl;
       --Alu_signal_mux_ctrl <= vAlu_lowermux_ctrl(1);		--because whenever add is needed explicitly, we also need +1 as lowermux output.
	Alu_signal_mux_ctrl <=(vAlu_lowermux_ctrl(0)) and (not vAlu_lowermux_ctrl(1));
	--new inclusion !! verify again.
       Alu_decoder_signal <= vAlu_decoder_signal;
       T3_mux_ctrl <= vT3_mux_ctrl;
       T3_en <= vT3_en;
       Rpe_en <= vRpe_en;
	Z_mux_ctrl<= vZ_mux_ctrl;

     if(clk'event and (clk = '1')) then
	if(reset = '1') then
             fsm_state <= reset_state;
        else
             fsm_state <= next_state;
        end if;
     end if;
   end process;
end Behave;




















