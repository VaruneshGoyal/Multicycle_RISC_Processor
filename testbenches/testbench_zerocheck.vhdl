library ieee;
use ieee.std_logic_1164.all;

entity zero_checker is
port( X :in std_logic_vector(15 downto 0);
      Z:out std_logic
      
 );
end zero_checker;

architecture Formula_ZC of zero_checker is
begin
Z <= not(X(0) or X(1) or X(2) or X(3) or X(4) or X(5) or X(6) or X(7));
end Formula_ZC;


library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use work.all;

entity Testbench_zerocheck is
end entity;

architecture behave of Testbench_zerocheck is
	signal z: std_logic;
	signal x: std_logic_vector(15 downto 0);
	
	
	
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
	
	dut: entity zero_checker port map(X=>x,Z=>z);


  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "zerocheck.txt";
    FILE OUTFILE: text  open write_mode is "OUT_ZC.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable active: bit_vector(15 downto 0);
    variable op: bit;
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
   begin
   	
   	while not endfile(INFILE) loop
   	
   		LINE_COUNT := LINE_COUNT + 1;
	    readline(INFILE, INPUT_LINE);
	    
	    read(INPUT_LINE, active);
        x <= to_std_logic_vector(active);
        
        read(INPUT_LINE, op);
        
         wait for 5 ns;
         
        if (z /= to_std_logic(op)) then
            write(OUTPUT_LINE,to_string("ERROR: in RESULT, line "));
            write(OUTPUT_LINE, LINE_COUNT);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, op);
            write(OUTPUT_LINE, to_string(" "));
           -- write(OUTPUT_LINE, str(y));
           -- write(OUTPUT_LINE, to_string(" "));
           -- write(OUTPUT_LINE, str(x));
            writeline(OUTFILE, OUTPUT_LINE);
            err_flag := true;
		else 
		   write(OUTPUT_LINE,to_string("CORRECT: in RESULT, line "));
		    write(OUTPUT_LINE, LINE_COUNT);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, op);
            write(OUTPUT_LINE, to_string(" "));
           -- write(OUTPUT_LINE, str(y));
           -- write(OUTPUT_LINE, to_string(" "));
           -- write(OUTPUT_LINE, str(x));
		   writeline(OUTFILE, OUTPUT_LINE);
        end if;
        
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  	end process;

end behave;
