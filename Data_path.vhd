library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;



entity Data_path is 

port (	clk:in std_logic);


end Data_path;


architecture Formula_Data_Path of Data_Path is
--reg_file signals
signal D1_mem, D2_mem,D3_mem:std_logic_vector(15 downto 0);
signal pc_data_out,pc_data_in:std_logic_vector(15 downto 0);
signal A1_mem,A2_mem,A3_mem :std_logic_vector( 2 downto 0);
signal mem_write_en,mem_pc_en:std_logic;
--t1 signals
signal unused_port: std_logic_vector(15 downto 0):= "ZZZZZZZZZZZZZZZZ";
signal t1_mux_output: std_logic_vector(15 downto 0);
signal t1_cntrl0, t1_cntrl1:std_logic;
--t2signals
signal t2_mux_output: std_logic_vector(15 downto 0);
signal t2_cntrl:std_logic;
--instructino reg signals
signal mem_to_IR: std_logic_vector(15 downto 0);
signal instr_sig: std_logic_vector(15 downto 0);
signal IR_en: std_logic;
--pc signals
signal pc_mux_en:std_logic;
--t1 signals
signal t1_output:std_logic_vector(15 downto  0);
signal t1_en:std_logic;

--t2 signals
signal t2_output:std_logic_vector(15 downto  0);
signal t2_en:std_logic;
--A1_RF mux signals
signal unused_A1_sig : std_logic_vector(2 downto 0):= "ZZZ";
signal A1_RF_cntrl0, A1_RF_cntrl1:std_logic;
begin


--instruction register
	--mem_to_IR connects mem and IR, at present hanging signal
dut_instr:DataRegister generic map(data_width=>16);
		       port map (Din: mem_to_IR,
	      	       Dout=> instr_sig,
	      	       clk=>clk, enable=>IR_en);
--pc mux
	--Din(1) to be obtained form alu output
dut_pc_mux: Data_MUX    generic map(control_bit_width=>1) 
			port map(Din(0) => t2_out_sig, Din(1) =>## , 
			Dout=> pc_data_in,
			control_bits(0)=>pc_mux_en);
--A1_RF_mux
	--din2 is connected to priority encoder output
dut_A1_RF_mux : Data_MUX_3 generic map(control_bit_width=>2) 
			   port map(Din(0) => instr_sig(5 downto 3), Din(1) => instr_sig(11 downto 9),
			   Din(2) => ##, Din(3) => unused_A1_sig,
			   Dout=>,
			   control_bits(0)=>A1_RF_cntrl0,control_bits(1)=>A1_RF_cntrl1);

--Register file
	--
dut_rf :Reg_File port map( A1=>A1_mem, A2=>A2_mem, A3=>A3_mem, R7_data_out=>pc_data_out, R7_data_in=>pc_data_in,
      				D1=>D1_mem, D2=>D2_mem, D3=>D3_mem, write_enable=>mem_write_en, clk=>clk, 
				pc_enable=>mem_pc_en);
--Data mux for t1
	--for the t1 data mux, we din02 is from mem and sign ext
dut_mux_t1: Data_MUX  generic map(control_bit_width=>2)
			port map(Din(0)=> ####,Din(1) =>D1_mem,Din(2) =>####,Din(3) =>unused_port,
			Dout=>t1_mux_output,
			control_bits(0)=>t1_cntrl0,control_bits(1)=>t1_cntrl1);
--Data mux for t2
	--for t2, din is from sign extender9-16
dut_mux_t2: Data_MUX generic map(control_bit_width=>1) 
			port map(Din(0) => D2_mem, Din(1) => ##, 
			Dout=> t2_mux_output,
			control_bits(0)=>t2_cntrl);

---- T1 register

dut_t1_reg : DataRegister generic map (data_width=>16);
			  port map (Din => t1_mux_output,
	      		  Dout => t1_output,
	     		 clk=>clk, enable=>t1_en);
---- T2 register

dut_t2_reg : DataRegister generic map (data_width=>16);
			  port map (Din => t2_mux_output,
	      		  Dout => t2_output,
	     		 clk=>clk, enable=>t2_en);





end Formula_Data_Path;

