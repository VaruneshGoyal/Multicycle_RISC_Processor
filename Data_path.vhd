library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;



entity Data_path is 

port (	clk:in std_logic);


end Data_path;


architecture Formula_Data_Path of Data_Path is
--reg_file signals
signal D1_RF, D2_RF,D3_RF:std_logic_vector(15 downto 0);
signal pc_data_out,pc_data_in:std_logic_vector(15 downto 0);
signal A1_RF,A2_RF,A3_RF :std_logic_vector( 2 downto 0);
signal RF_write_en,RF_pc_en:std_logic;
--t1_mux signals
signal unused_port: std_logic_vector(15 downto 0):= "ZZZZZZZZZZZZZZZZ";
signal t1_mux_output: std_logic_vector(15 downto 0);
signal t1_mux_cntrl0, t1_mux_cntrl1:std_logic;
--t2_mux signals
signal t2_mux_output: std_logic_vector(15 downto 0);
signal t2_mux_cntrl:std_logic;
--instructino reg signals
signal mem_to_IR: std_logic_vector(15 downto 0);
signal instr_sig: std_logic_vector(15 downto 0);
signal IR_en: std_logic;
--pc_mux signals
signal pc_mux_cntrl:std_logic;
--t1 signals
signal t1_output:std_logic_vector(15 downto  0);
signal t1_en:std_logic;

--t2 signals
signal t2_output:std_logic_vector(15 downto  0);
signal t2_en:std_logic;
--A1_RF mux signals
signal unused_A1_sig : std_logic_vector(2 downto 0):= "ZZZ";
signal A1_RF_mux_cntrl0, A1_RF_mux_cntrl1:std_logic;
--A3RF mux signals
signal A3_RF_mux_cntrl: std_logic;
--data extender signals
signal data_ext_output: std_logic_vector(15 downto 0);
--sign extender 6t016 signals
signal sign_ext_6t016_output:std_logic_vector(15 downto 0);
--sign extender 9 t0 16 signals
signal sign_ext_9t016_output:std_logic_vector(15 downto 0);
--D3_RF mux signals
signal D3_RF_mux_cntrl0, D3_RF_mux_cntrl1: std_logic;

-- PE mux signal
signal pe_mux_cntrl : std_logic;
signal pe_mux_output : std_logic_vector(7 downto 0);

-- RPE signal
signal rpe_output : std_logic_vector(7 downto 0);
signal rpe_en :std_logic;

--PE signal
signal  pe_output :std_logic_vector( 2 downto 0);

---PE encode modifer signal
signal pe_modifier_output :std_lodic_vector( 7 downto 0);

--- ALU mux upper signals
signal alu_mux_upper_out :std_logic_vector( 15 downto 0);
signal alu_mux_upper_cntrl0,alu_mux_upper_cntrl1:std_logic;

--- ALU mux lower signals
signal alu_mux_lower_out :std_logic_vector( 15 downto 0);
signal alu_mux_lower_cntrl0,alu_mux_lower_cntrl1:std_logic;
constant const_sig1 :std_logic_vector( 15 downto 0):="0000000000000001";
begin


--instruction register
	--mem_to_IR connects mem and IR, at present hanging signal
dut_instr_reg: DataRegister    generic map(data_width=>16);
			       port map (Din: mem_to_IR,
		      	       Dout=> instr_sig,
		      	       clk=>clk, enable=>IR_en);
--pc mux
	--Din(1) to be obtained form alu output
dut_pc_mux: Data_MUX    generic map(control_bit_width=>1) 
			port map(Din(0) => t2_out_sig, Din(1) =>## , 
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
			   port map(Din(0) => instr_sig(11 downto 9), Din(1) => pe_output,
			   Dout=>A3_RF,
			   control_bits(0)=>A3_RF_mux_cntrl);

--d3_mux
	--din1 is from t3_output
dut_D3_RF_mux: Data_MUX generic map(control_bit_width=>2)
			port map(Din(0)=>data_ext_output,Din(1)=>##,Din(2)=>t1_output,Din(3)=>unused_port,
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
			port map (Din(0) =>instr_sig(7 downto 0), Din(1) => pe_modifier_output,
			Dout => pe_mux_output,
			control_bits => pe_mux_cntrl);
-- priority enocoder mux
dut _pe_reg :DataRegister generic map (data_width => 8);
			  port (Din => pe_mux_output,
	      			Dout => rpe_output,
	     			clk=>clk, enable=> rpe_en);

 --- Priority Encoder
dut_pe :  priority_encoder port map (x=> rpe_output,
				     y=> pe_output);

-- Priority Decode logic

dut_pe_modifier : encode_modifier port map ( encode_bits => pe_output,
      					    priority_bits_in => rpe_output,
      					    priority_bits_out=> pe_modifier_output);
--Register file
dut_rf :Reg_File port map( A1=>A1_RF, A2=>A2_RF, A3=>A3_RF, R7_data_out=>pc_data_out, R7_data_in=>pc_data_in,
      		 D1=>D1_RF, D2=>D2_RF, D3=>D3_RF, write_enable=>RF_write_en, clk=>clk, 
		 pc_enable=>RF_pc_en);
--Data mux for t1
	--for the t1 data mux, we din0 is from mem
dut_mux_t1: Data_MUX    generic map(control_bit_width=>2)
			port map(Din(0)=> ####,Din(1) =>D1_RF,Din(2) =>sign_ext_6t016_output,Din(3) =>unused_port,
			Dout=>t1_mux_output,
			control_bits(0)=>t1_mux_cntrl0,control_bits(1)=>t1_mux_cntrl1);

--Data mux for t2
dut_mux_t2: Data_MUX    generic map(control_bit_width=>1) 
			port map(Din(0) => D2_RF, Din(1) => sign_ext_9t016_output, 
			Dout=> t2_mux_output,
			control_bits(0)=>t2_mux_cntrl);

--T1 register
dut_t1_reg : DataRegister generic map (data_width=>16);
			  port map (Din => t1_mux_output,
	      		  Dout => t1_output,
	     		  clk=>clk, enable=>t1_en);

--T2 register
dut_t2_reg : DataRegister generic map (data_width=>16);
			  port map (Din => t2_mux_output,
	      		  Dout => t2_output,
	     		  clk=>clk, enable=>t2_en);

-- Alu_mUX_Upper
 --DIn(0)  from T3 output
dut_alu_mux_upper : Data_MUX generic map(control_bit_width=>2)
			port map(Din(0)=> ##,Din(1)=>pc_data_out,Din(2)=>t1_output,Din(3)=>unused_port,
			Dout=> alu_mux_upper_out,
			control_bits(0)=>alu_mux_upper_cntrl0,control_bits(1)=>alu_mux_upper_cntrl1);


-- Alu_MUX_lower
 
dut_alu_mux_upper : Data_MUX generic map(control_bit_width=>2)
			port map(Din(0)=>t2_output,Din(1)=>sign_ext_6t016_output,Din(2)=>const_sig_1,Din(3)=>unused_port,
			Dout=> alu_mux_lower_out,
			control_bits(0)=>alu_mux_lower_cntrl0,control_bits(1)=>alu_mux_lower_cntrl1);


end Formula_Data_Path;

