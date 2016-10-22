
library ieee;
use ieee.std_logic_1164.all;


entity full_adder is
port(  
	x,y,c_in: in std_logic;
	s, c_out: out std_logic
       
 );
end full_adder;


architecture Formula_FA of full_adder is
	signal P,G :std_logic;
begin

	P<=  ((not x) and y) or ((not y) and x);
	G<= x and y;
	c_out<= (P and c_in ) or G;
	s<= ((not P) and c_in) or ((not c_in) and P);
end Formula_FA;

library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use work.all;

entity Testbench_fulladder is
end entity;

architecture behave of Testbench_fulladder is
	signal x: std_logic;
	signal y: std_logic;
	signal c_in: std_logic;
	signal c_out: std_logic;
	signal s: std_logic;
	
	
----------------------to_std_logic--------------------------------------------------------
  	function to_std_logic(i : in bit) return std_logic is
		begin
			if (i = '0') then
				return '0';
			end if;
			return '1';
	end function;
	
---------------------to string---------------------------------------------
	function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
	  begin  
		  ret_val := lx;
		  return(ret_val);
	  end to_string;
----------------------to_std_logic_vector------------------------------------------
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
	
	dut: entity full_adder port map(x=>x,y=>y,c_in=>c_in,s=>s,c_out=>c_out);


  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "fulladder.txt";
    FILE OUTFILE: text  open write_mode is "OUT_FA.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable x_var: bit;
    variable y_var: bit;
    variable cin_var: bit;
    variable cout_var: bit;
    variable s_var: bit;
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
   begin
   	
   	while not endfile(INFILE) loop
   	
   		LINE_COUNT := LINE_COUNT + 1;
	    readline(INFILE, INPUT_LINE);
	    
	    read(INPUT_LINE, x_var);
        x <= to_std_logic(x_var);
        
        read(INPUT_LINE, y_var);
        y <= to_std_logic(y_var);
        
        read(INPUT_LINE, cin_var);
        c_in <= to_std_logic(cin_var);
        
        read(INPUT_LINE, s_var);
        
        read(INPUT_LINE, cout_var);
        
         wait for 5 ns;
         
        if (c_out /= to_std_logic(cout_var) or s /= to_std_logic(s_var)) then
            write(OUTPUT_LINE,to_string("ERROR: in RESULT, line "));
            write(OUTPUT_LINE, LINE_COUNT);
            writeline(OUTFILE, OUTPUT_LINE);
            err_flag := true;
		else 
		   write(OUTPUT_LINE,to_string("CORRECT: in RESULT, line "));
		   write(OUTPUT_LINE, LINE_COUNT);
		   writeline(OUTFILE, OUTPUT_LINE);
        end if;
        
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  	end process;

end behave;


