library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;



entity Data_path is 

port (clk:in std_logic;
	reset:in std_logic;
	RF_write_en,RF_pc_en:in std_logic;
	t1_mux_cntrl0, t1_mux_cntrl1:in std_logic;
	t2_mux_cntrl:in std_logic;
	IR_en: in std_logic;
	pc_mux_cntrl:in std_logic;
	t1_en:in std_logic;
	t2_en:in std_logic;
	A1_RF_mux_cntrl0, A1_RF_mux_cntrl1:in std_logic;
	A3_RF_mux_cntrl: in std_logic;
	D3_RF_mux_cntrl0, D3_RF_mux_cntrl1:in  std_logic;
	pe_mux_cntrl : in std_logic;
	rpe_en :in std_logic;
	alu_mux_upper_cntrl0,alu_mux_upper_cntrl1:in std_logic;
	alu_mux_lower_cntrl0,alu_mux_lower_cntrl1:in std_logic;
	carry_reg_en:in std_logic;
	zero_reg_en:in std_logic;
	t3_mux_cntrl0,t3_mux_cntrl1 :in std_logic;
	t3_en:in std_logic;
	mem_addr_mux_cntrl:in std_logic;
	mem_read_en,mem_write_en:in std_logic;
	z_mux_cntrl: in std_logic;
	Alu_signal_mux_ctrl :in std_logic;
	--carry_reg_out: out std_logic;
	--zero_reg_out: out std_logic;
	instr_reg_out :out std_logic_vector(15 downto 0);
	--pe_zero_flag :out std_logic;
	S1_decoder_output :out std_logic_vector(3 downto 0);
	S2_decoder_output :out std_logic_vector(3 downto 0);
	S3_decoder_output :out std_logic_vector(3 downto 0);
	S6_decoder_output :out std_logic_vector(3 downto 0);
	S11_decoder_output :out std_logic_vector(3 downto 0);
	S14_decoder_output :out std_logic_vector(3 downto 0)

	--mem_addr_mux_output: out std_logic_vector(15 downto 0);
	--mem_data_output: in std_logic_vector(15 downto 0)
);



end Data_path;


architecture Formula_Data_Path of Data_Path is

--reg_file signals
signal D1_RF, D2_RF,D3_RF:std_logic_vector(15 downto 0);
signal pc_data_out,pc_data_in:std_logic_vector(15 downto 0);
signal A1_RF,A2_RF,A3_RF :std_logic_vector( 2 downto 0);
--signal RF_write_en,RF_pc_en:std_logic;

--t1_mux signals
signal unused_port: std_logic_vector(15 downto 0):= "ZZZZZZZZZZZZZZZZ";
signal t1_mux_output: std_logic_vector(15 downto 0);
--signal t1_mux_cntrl0, t1_mux_cntrl1:std_logic;

--t2_mux signals
signal t2_mux_output: std_logic_vector(15 downto 0);
--signal t2_mux_cntrl:std_logic;

--instruction reg signals
signal instr_sig: std_logic_vector(15 downto 0);
--signal IR_en: std_logic;

--pc_mux signals
--signal pc_mux_cntrl:std_logic;

--t1 signals
signal t1_output:std_logic_vector(15 downto  0);
--signal t1_en:std_logic;

--t2 signals
signal t2_output:std_logic_vector(15 downto  0);
--signal t2_en:std_logic;

--A1_RF mux signals
signal unused_A1_sig : std_logic_vector(2 downto 0):= "ZZZ";
--signal A1_RF_mux_cntrl0, A1_RF_mux_cntrl1:std_logic;

--A3_RF mux signals
--signal A3_RF_mux_cntrl: std_logic;

--data extender signals
signal data_ext_output: std_logic_vector(15 downto 0);

--sign extender 6t016 signals
signal sign_ext_6t016_output:std_logic_vector(15 downto 0);

--sign extender 9 t0 16 signals
signal sign_ext_9t016_output:std_logic_vector(15 downto 0);

--D3_RF mux signals
--signal D3_RF_mux_cntrl0, D3_RF_mux_cntrl1: std_logic;

--PE mux signal
--signal pe_mux_cntrl : std_logic;
signal pe_mux_output : std_logic_vector(7 downto 0);

--RPE signal
signal rpe_output : std_logic_vector(7 downto 0);
--signal rpe_en :std_logic;

--PE signal
signal  pe_output :std_logic_vector( 2 downto 0);

--PE encode modifer signal
signal pe_modifier_output :std_logic_vector( 7 downto 0);

--ALU mux upper signals
signal alu_mux_upper_out :std_logic_vector( 15 downto 0);
--signal alu_mux_upper_cntrl0,alu_mux_upper_cntrl1:std_logic;

--ALU mux lower signals
signal alu_mux_lower_out :std_logic_vector( 15 downto 0);
--signal alu_mux_lower_cntrl0,alu_mux_lower_cntrl1:std_logic;
constant const_sig_1 :std_logic_vector( 15 downto 0):="0000000000000001";

--ALU signals
signal alu_output:std_logic_vector(15 downto 0);
signal alu_cntrl0,alu_cntrl1 :std_logic;
--signal alu_cntrl0,alu_cntrl1:std_logic;
signal alu_carry_flag,alu_zero_flag:std_logic;

--carry reg signal
signal carry_reg_out_sig:std_logic;
signal carry_reg_enable:std_logic;
--signal carry_reg_en:std_logic;

--zero reg signal
signal zero_reg_out_sig:std_logic;
signal zero_reg_enable:std_logic;
--signal zero_reg_en:std_logic;

--T3_MUX signals
signal t3_mux_output : std_logic_vector(15 downto 0);
--signal t3_mux_cntrl0,t3_mux_cntrl1 :std_logic;

--T3 signal
signal t3_output:std_logic_vector(15 downto 0);
--signal t3_en:std_logic;

--MEM_ADDR MUX signals
signal mem_addr_mux_output:std_logic_vector(15 downto 0);
--signal mem_addr_mux_cntrl:std_logic;

--memory signals
signal mem_data_output:std_logic_vector(15 downto 0);
--signal mem_read_en,mem_write_en:std_logic;

-- pe zerochecker signal
constant const_sig_0:std_logic_vector(7 downto 0):= "00000000";
signal pe_zero_checker_output:std_logic;
--zero checker of z flag signals
signal zerochecker_z_out: std_logic;
--zero flag mux signal
signal zero_flag_mux_output: std_logic;

-- alunflag decoder signal

signal carry_decoder_output,zero_decoder_output:std_logic;
signal ALU_decoder_output:std_logic_vector(1 downto 0);
signal S1_decoder_output_sig :std_logic_vector(3 downto 0);
begin


--instruction register
	
dut_instr_reg: DataRegister    generic map(data_width=>16)
			       port map (Din=> mem_data_output,
		      	       Dout=> instr_sig,
		      	       clk=>clk, enable=>IR_en,reset=>reset);

--pc mux
	
dut_pc_mux: Data_MUX    generic map(control_bit_width=>1) 
			port map(Din(0) => t2_output, Din(1) =>alu_output , 
			Dout=> pc_data_in,
			control_bits(0)=>pc_mux_cntrl);
--A1_RF_mux
	
dut_A1_RF_mux : Data_MUX_3 generic map(control_bit_width=>2) 
			   port map(Din(0) => instr_sig(5 downto 3), Din(1) => instr_sig(11 downto 9),
			   Din(2) => pe_output, Din(3) => unused_A1_sig,
			   Dout=>A1_RF,
			   control_bits(0)=>A1_RF_mux_cntrl0,control_bits(1)=>A1_RF_mux_cntrl1);
			   A2_RF <= instr_sig(8 downto 6);
--A3_RF mux
	
dut_A3_RF_mux : Data_MUX_3 generic map(control_bit_width=>1) 
			   port map(Din(0) =>pe_output, Din(1) => instr_sig(11 downto 9) ,
			   Dout=>A3_RF,
			   control_bits(0)=>A3_RF_mux_cntrl);

--d3_mux
	
dut_D3_RF_mux: Data_MUX generic map(control_bit_width=>2)
			port map(Din(0)=>data_ext_output,Din(1)=>t3_output,Din(2)=>t1_output,Din(3)=>unused_port,
			Dout=>D3_RF,
			control_bits(0)=>D3_RF_mux_cntrl0,control_bits(1)=>D3_RF_mux_cntrl1);

--Data Extender
dut_data_ext9_16: data_extender_9to16 port map(x=>instr_sig(8 downto 0),y=>data_ext_output);

--sign extender 6-16
dut_sign_ext6_16: sign_extender_6to16 port map(x=>instr_sig(5 downto 0),y=>sign_ext_6t016_output);

--sign extender 9-16
dut_sign_ext9_16: sign_extender_9to16 port map(x=>instr_sig(8 downto 0),y=>sign_ext_9t016_output);

--priority encoder mux
dut_pe_mux:  Data_MUX_8 generic map (control_bit_width=>1)
			port map (Din(0) =>pe_modifier_output, Din(1) => instr_sig(7 downto 0),
			Dout => pe_mux_output,
			control_bits(0) => pe_mux_cntrl);
--priority enocoder reg
dut_pe_reg :DataRegister generic map (data_width => 8)
			 port map (Din => pe_mux_output,
	      		 Dout => rpe_output,
	     		 clk=>clk, enable=> rpe_en,reset=>reset);
-- priority zero checker
	-- as component is defined only for 16 bits. WE set 1st 8 bits as 0.
dut_pe_zero_check: zero_checker port map ( X(15 downto 8)=> const_sig_0,X(7 downto 0) => rpe_output,
     					 Z => pe_zero_checker_output);
      



--Priority Encoder
dut_pe :  priority_encoder port map (x=> rpe_output,
				     y=> pe_output);

--Priority Decode logic
dut_pe_modifier : encode_modifier port map (encode_bits => pe_output,
      					    priority_bits_in => rpe_output,
      					    priority_bits_out=> pe_modifier_output);

--Register file
dut_rf :Reg_File port map( A1=>A1_RF, A2=>A2_RF, A3=>A3_RF, R7_data_out=>pc_data_out, R7_data_in=>pc_data_in,
      		 D1=>D1_RF, D2=>D2_RF, D3=>D3_RF, write_enable=>RF_write_en, clk=>clk,reset =>reset,
		 pc_enable=>RF_pc_en);

--Data mux for t1
dut_mux_t1: Data_MUX    generic map(control_bit_width=>2)
			port map(Din(0)=> D1_RF,Din(1) =>sign_ext_6t016_output,Din(2) =>mem_data_output,Din(3) =>unused_port,
			Dout=>t1_mux_output,
			control_bits(0)=>t1_mux_cntrl0,control_bits(1)=>t1_mux_cntrl1);

--Data mux for t2
dut_mux_t2: Data_MUX    generic map(control_bit_width=>1) 
			port map(Din(0) => sign_ext_9t016_output, Din(1) => D2_RF, 
			Dout=> t2_mux_output,
			control_bits(0)=>t2_mux_cntrl);

--T1 register
dut_t1_reg : DataRegister generic map (data_width=>16)
			  port map (Din => t1_mux_output,
	      		  Dout => t1_output,
	     		  clk=>clk, enable=>t1_en,reset=>reset);

--T2 register
dut_t2_reg : DataRegister generic map (data_width=>16)
			  port map (Din => t2_mux_output,
	      		  Dout => t2_output,
	     		  clk=>clk, enable=>t2_en,reset=>reset);

--Alu_mUX_Upper
dut_alu_mux_upper : Data_MUX    generic map(control_bit_width=>2)
				port map(Din(0)=> pc_data_out,Din(1)=>t1_output,Din(2)=>t3_output,Din(3)=>unused_port,
				Dout=> alu_mux_upper_out,
				control_bits(0)=>alu_mux_upper_cntrl0,control_bits(1)=>alu_mux_upper_cntrl1);


--Alu_MUX_lower
dut_alu_mux_lower : Data_MUX    generic map(control_bit_width=>2)
				port map(Din(0)=>const_sig_1,Din(1)=>sign_ext_6t016_output,Din(2)=>t2_output,Din(3)=>unused_port,
				Dout=> alu_mux_lower_out,
				control_bits(0)=>alu_mux_lower_cntrl0,control_bits(1)=>alu_mux_lower_cntrl1);

--ALU
dut_alu : ALU port map( X=> alu_mux_upper_out,Y=>alu_mux_lower_out,
      			Z =>alu_output,
     			carry_flag=>alu_carry_flag,zero_flag=>alu_zero_flag,
     		        Control_bits(0)=> alu_cntrl0,Control_bits(1)=> alu_cntrl1);

--carry reg
	--- carry reg out and zero reg out to go to control path
dut_carry_reg : DataRegister    generic map (data_width=>1)
			  	port map (Din(0) => alu_carry_flag,
	      		  	Dout(0) => carry_reg_out_sig,
	     		  	clk=>clk, enable=>carry_reg_enable,reset=>reset);
carry_reg_enable<= carry_reg_en and carry_decoder_output;

--zero reg
dut_zero_reg : DataRegister generic map (data_width=>1)
			    port map (Din(0) => zero_flag_mux_output,
	      		    Dout(0) => zero_reg_out_sig,
	     		    clk=>clk, enable=>zero_reg_enable,reset=>reset);
zero_reg_enable<= zero_reg_en and zero_decoder_output;

--t3_MUX
dut_mux_t3: Data_MUX    generic map(control_bit_width=>2) 
			port map(Din(0) => mem_data_output, Din(1) =>alu_output,Din(2) => D1_RF, Din(3)=>unused_port,
			Dout=> t3_mux_output,
			control_bits(0)=>t3_mux_cntrl0,control_bits(1)=>t3_mux_cntrl1);


--T3 register
dut_t3_reg : DataRegister generic map (data_width=>16)
			  port map (Din =>t3_mux_output ,
	      		  Dout => t3_output ,
	     		  clk=>clk, enable=>t3_en,reset=>reset);

--Memory address MuX
dut_mux_mem_addr: Data_MUX      generic map(control_bit_width=>1) 
				port map(Din(0) =>t3_output , Din(1) =>pc_data_out, 
				Dout=> mem_addr_mux_output ,
				control_bits(0)=>mem_addr_mux_cntrl);
-- Memory
dut_memory :Memory port map (Din=> t1_output,
			Dout => mem_data_output,
			write_enable=>mem_write_en,
			read_enable=>mem_read_en,clk=>clk,
			Addr=>  mem_addr_mux_output);



--zero checker for z flag
dut_zerochecker_z: zero_checker port map ( X=>mem_data_output,
     					 Z =>zerochecker_z_out);

--zero_flag_mux
dut_zero_flag_mux: Data_MUX_1
		generic map(control_bit_width=>1)
		port map (Din(0)(0)=>alu_zero_flag,Din(1)(0)=>zerochecker_z_out,
		Dout(0)=>zero_flag_mux_output,
		control_bits(0)=>z_mux_cntrl);
-- S1 decoder

--dutS1_decoder :S1_decoder port map( i0=>Instr_sig(12), i1=>Instr_sig(13), i2=>Instr_sig(14), i3=> Instr_sig(15),
dutS1_decoder :S1_decoder port map( i0=>mem_data_output(12), i1=>mem_data_output(13), i2=>mem_data_output(14), i3=>mem_data_output(15),
      S1_decoder_out => S1_decoder_output_sig );
S1_decoder_output<= S1_decoder_output_sig ;
---


--
-- s2 decoder
dutS2_decoder :S2_decoder port map( i0=>Instr_sig(12),  i2=>Instr_sig(14),i3=> Instr_sig(15), p0=>Instr_sig(0), p1=>Instr_sig(1), z =>zero_reg_out_sig, c =>carry_reg_out_sig,
      S2_decoder_out => S2_decoder_output );


-- s3 decoder

dutS3_decoder:S3_decoder port map ( i0=>Instr_sig(12),  i2=>Instr_sig(14),i3=> Instr_sig(15),  z =>alu_zero_flag,
      S3_decoder_out =>S3_decoder_output );


--- s6 decoder

dutS6_decoder:S6_decoder port map( i1=>Instr_sig(13), z_Rpe=>pe_zero_checker_output,
      S6_decoder_out=>S6_decoder_output  );

-- s14 decoder

dutS14_decoder:S14_decoder port map( z_Rpe => pe_zero_checker_output,
      S14_decoder_out => S14_decoder_output );

dutS11_decoder:S11_decoder port map( z_Rpe => pe_zero_checker_output,
      S11_decoder_out => S11_decoder_output );

--alu n flag decoder
dut_alunflag_decoder:ALUnFLAG_decoder port map( IR15 =>Instr_sig(15), IR14=>Instr_sig(14), IR13=>Instr_sig(13), IR12=>Instr_sig(12),
      ALU_decoder_out =>ALU_decoder_output,
      carry_decoder_out=> carry_decoder_output, zero_decoder_out=> zero_decoder_output );

--alu control mux
dut_alu_cntrl_mux:Data_MUX_2 generic map (control_bit_width=>1)
				port map(Din(0) => "00" ,Din(1) =>ALU_decoder_output,
					Dout(0)=>alu_cntrl0,Dout(1) =>alu_cntrl1,
					control_bits(0)=> Alu_signal_mux_ctrl );
--carry_reg_out<=carry_reg_out_sig;
--zero_reg_out<=zero_reg_out_sig;
instr_reg_out<=instr_sig;
--pe_zero_flag <=pe_zero_checker_output;


end Formula_Data_Path;

