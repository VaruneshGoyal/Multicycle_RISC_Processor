library ieee;
use ieee.std_logic_1164.all;

entity ALU_XOR is
port( X,Y: in std_logic_vector(15 downto 0);
      Z : out std_logic_vector(15 downto 0)
 );
end ALU_XOR;


architecture Formula_XOR of ALU_XOR is

begin
Z <= ((not X) and  Y) or((not Y) and X) ;

end Formula_XOR;

library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use work.all;

entity Testbench_xor is
end entity;

architecture behave of Testbench_xor is
	signal X,Y: std_logic_vector(15 downto 0);
	signal Z : std_logic_vector(15 downto 0);
	
	
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
	
	dut: entity ALU_XOR port map(X=>x, Y=>y, Z=>z);


  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "xor.txt";
    FILE OUTFILE: text  open write_mode is "OUT_XOR.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable x_var: bit_vector(15 downto 0);
    variable y_var: bit_vector(15 downto 0);
	variable z_var: bit_vector(15 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
   begin
   	
   	while not endfile(INFILE) loop
   	
   		LINE_COUNT := LINE_COUNT + 1;
	    readline(INFILE, INPUT_LINE);
	    
	    read(INPUT_LINE, x_var);
        x <= to_std_logic_vector(x_var);
        
        read(INPUT_LINE, y_var);
        y <= to_std_logic_vector(y_var);
        
        read(INPUT_LINE, z_var);
        
         wait for 5 ns;
         
        if (z /= to_std_logic_vector(z_var)) then
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


