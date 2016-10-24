library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library std;
use std.textio.all;
library work;
use work.Microprocessor_project.all;

entity testbench_RF is
end entity;

architecture behave of testbench_RF is
	
	
	component Reg_File is 
		port( A1,A2,A3: in std_logic_vector(2 downto 0);
	        D1, D2: out std_logic_vector(15 downto 0);
	        write_enable,clk,reset: in std_logic;
	        pc_enable:in std_logic;
	        D3: in std_logic_vector( 15 downto 0);
	        R7_data_in : in std_logic_vector(15 downto 0);
	        R7_data_out : out std_logic_vector(15 downto 0));
	end component;

----------to string function
	function to_string(x: string) return string is
		variable ret_val: string(1 to x'length);
  		alias lx : string (1 to x'length) is x;
		begin  
		  ret_val := lx;
		  return(ret_val);
		end to_string;

-----------to std_logic
	function to_std_logic_vector (x: bit_vector) return std_logic_vector is
		variable y : std_logic_vector((x'length-1) downto 0);
	begin
		for k in 0 to (x'length-1) loop
			if(x(k)='1') then y(k) := '1';
			else y(k) := '0';
			end if;
		end loop;
		return y;
  end to_std_logic_vector;

---------------------std_logic_to_chr------------------------------------------------------
  function chr(sl: std_logic) return character is
  	variable c: character;
  begin
    case sl is
  	  when 'U' => c:= 'U';
      when 'X' => c:= 'X';
      when '0' => c:= '0';
      when '1' => c:= '1';
      when 'Z' => c:= 'Z';
      when 'W' => c:= 'W';
      when 'L' => c:= 'L';
      when 'H' => c:= 'H';
      when '-' => c:= '-';
    end case;
    return c;
  end chr;
-----------------------std_logic_vec_to_str-------------------------------------------------
  function str(slv: std_logic_vector) return string is
    variable result : string (1 to slv'length);
    variable r : integer;
  begin
    r := 1;
    for i in slv'range loop
      result(r) := chr(slv(i));
      r := r + 1;
    end loop;
    return result;
  end str;
----------------------to_std_logic--------------------------------------------------------
  function to_std_logic(i : in bit) return std_logic is
		begin
			if (i = '0') then
				return '0';
			end if;
			return '1';
		end function;
---------------------------------------------------------------------------------------------
--signals that require to be defined
signal A1_sig,A2_sig,A3_sig:std_logic_vector(2 downto 0);
signal D1_sig,D2_sig:std_logic_vector(15 downto 0);
signal write_enable_sig,pc_enable_sig:std_logic;
signal D3_sig,R7_data_in_sig,R7_data_out_sig:std_logic_vector(15 downto 0);
signal clk:std_logic:= '0';
signal reset:std_logic:= '0';
--architecture begins
begin
	dut: Reg_File
		port map( A1=>A1_sig,A2=>A2_sig,A3=>A3_sig,
	        D1=>D1_sig, D2=>D2_sig,
	        write_enable=>write_enable_sig,clk=>clk,reset=>reset,
	        pc_enable=>pc_enable_sig,
	        D3=>D3_sig,
	        R7_data_in=>R7_data_in_sig,
	        R7_data_out=>R7_data_out_sig);

	clk <= not clk after 10 ns;
process
	variable err_flag : boolean := true;
   	File INFILE: text open read_mode is "tracefile_RF.txt";
    	FILE OUTFILE: text  open write_mode is "OUT_RF.txt";

	------------------------------------------------------
	variable vpc_en:bit;
	variable vwrite_enable:bit;
	variable vA1,vA2,vA3:bit_vector(2 downto 0);
	variable vD1,vD2,vD3,vR7_data_in,vR7_data_out:bit_vector(15 downto 0);
	
	variable INPUT_LINE: Line;
	variable OUTPUT_LINE: Line;
	variable LINE_COUNT: integer := 0;

	begin
	
	while not endfile(INFILE) loop
   	
   	LINE_COUNT := LINE_COUNT + 1;
	readline(INFILE, INPUT_LINE);
	
	--testing line
	report "line_count" & integer'image(LINE_COUNT);
	read(INPUT_LINE, vpc_en);
	pc_enable_sig<=to_std_logic(vpc_en);
	
	read(INPUT_LINE, vwrite_enable);
	write_enable_sig<=to_std_logic(vwrite_enable);

	read(INPUT_LINE, vA1);
	A1_sig<=to_std_logic_vector(vA1);

	read(INPUT_LINE, vA2);
	A2_sig<=to_std_logic_vector(vA2);
	
	read(INPUT_LINE, vA3);
	A3_sig<=to_std_logic_vector(vA3);

	read(INPUT_LINE, vR7_data_in);
	R7_data_in_sig<=to_std_logic_vector(vR7_data_in);
	
	read(INPUT_LINE, vD3);
	D3_sig<=to_std_logic_vector(vD3);

	read(INPUT_LINE, vR7_data_out);	--output variable

	read(INPUT_LINE, vD1);	--output variable
	
	read(INPUT_LINE, vD2); --output variable	
	
	--wait statement
	wait for 10 ns;

	write(OUTPUT_LINE, LINE_COUNT);
	report "line_count again " & integer'image(LINE_COUNT);
	write(OUTPUT_LINE, to_string(" "));
	write(OUTPUT_LINE, str(R7_data_out_sig));
	report "r7 data out " & str(R7_data_out_sig);
	write(OUTPUT_LINE, to_string(" "));
	write(OUTPUT_LINE, str(D1_sig));
	write(OUTPUT_LINE, to_string(" "));
	write(OUTPUT_LINE, str(D2_sig));
	
	writeline(OUTFILE, OUTPUT_LINE);
	if((R7_data_out_sig /= to_std_logic_vector(vR7_data_out)) or (D1_sig /= to_std_logic_vector(vD1)) or (D2_sig /= to_std_logic_vector(vD2))) then
		err_flag := false;
	end if;
	wait for 10 ns;
	end loop;
	
	assert (not err_flag) report "SUCCESS, all tests passed." severity note;
    assert (err_flag) report "FAILURE, some tests failed." severity error;
    
	wait;
	end process;
	end behave;
