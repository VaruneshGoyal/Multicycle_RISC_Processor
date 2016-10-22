library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library std;
use std.textio.all;
library work;
use work.Microprocessor_project.all;

entity Testbench_datamux is
end entity;

architecture behave of Testbench_datamux is
	signal x1: std_logic_vector(15 downto 0);
	signal x2: std_logic_vector(15 downto 0);
	signal x3: std_logic_vector(15 downto 0);
	signal x4: std_logic_vector(15 downto 0);
	signal control_bits: std_logic_vector(1 downto 0) := "00";
	signal y: std_logic_vector(15 downto 0);

	component Data_MUX is
		generic (control_bit_width:integer);
		port(Din:in Data_in(2**control_bit_width-1 downto 0);
					Dout:out std_logic_vector(15 downto 0);
					control_bits:in std_logic_vector(control_bit_width-1 downto 0));
	end component;
	
---------------------to string---------------------------------------------
	function to_string(x: string) return string is
  	variable ret_val: string(1 to x'length);
  	alias lx : string (1 to x'length) is x;
	begin  
	  ret_val := lx;
	  return(ret_val);
	end to_string;
----------------------to_std_logic------------------------------------------
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
  
----------------------std_logic_to_chr------------------------------------------------------
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
---------------------------------------------------------------------------------------------

begin	
	dut: Data_MUX generic map (control_bit_width => 2)
						port map(Din(0)=>x1,
							Din(1)=>x2,
							Din(2)=>x3,
							Din(3)=>x4,
							Dout=>y,
							control_bits=>control_bits);

  process 
    variable err_flag : boolean := true;
    File INFILE: text open read_mode is "tracefile_datamux.txt";
    FILE OUTFILE: text  open write_mode is "OUT_Dmux.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable control_bits_var: bit_vector(1 downto 0);
    variable ip1: bit_vector(15 downto 0);
    variable ip2: bit_vector(15 downto 0);
    variable ip3: bit_vector(15 downto 0);
    variable ip4: bit_vector(15 downto 0);
    variable op: bit_vector(15 downto 0);
    ----------------------------------------------------
	variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
   begin
   	
   	while not endfile(INFILE) loop
   	
    
   	LINE_COUNT := LINE_COUNT + 1;
    readline(INFILE, INPUT_LINE);
    
    read(INPUT_LINE, control_bits_var);
    control_bits <= to_std_logic_vector(control_bits_var);
    
    read(INPUT_LINE, ip1);
    x1 <= to_std_logic_vector(ip1);
    
    read(INPUT_LINE, ip2);
    x2 <= to_std_logic_vector(ip2);
    
    read(INPUT_LINE, ip3);
    x3 <= to_std_logic_vector(ip3);
    
    read(INPUT_LINE, ip4);
    x4 <= to_std_logic_vector(ip4);
    
    read(INPUT_LINE, op);
    y <= to_std_logic_vector(op);
    
    wait for 10 ns;
    
            write(OUTPUT_LINE, LINE_COUNT);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, control_bits_var);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, op);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, str(y));
            writeline(OUTFILE, OUTPUT_LINE);
		assert (y = to_std_logic_vector(op))
		report "Error" severity error;
    
    end loop;
    wait;
    end process;
    end behave;
	


















