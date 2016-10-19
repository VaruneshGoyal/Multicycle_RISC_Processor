library ieee;
use ieee.std_logic_1164.all;
entity sign_extender_9to16 is
port(
	x: in std_logic_vector(8 downto 0);
	y : out std_logic_vector( 15 downto 0)
);
end sign_extender_9to16;

architecture Formula_SE_9to16 of sign_extender_9to16 is 



begin

	y(0) <= x(0);
	y(1) <= x(1);
	y(2) <= x(2);
	y(3) <= x(3);
	y(4) <= x(4);
	y(5) <= x(5);
	y(6) <= x(6);
	y(7) <= x(7);
	y(8) <= x(8);
	y(9) <= x(8);
	y(10) <= x(8);
	y(11) <= x(8);
	y(12) <= x(8);
	y(13) <= x(8);
	y(14) <= x(8);
	y(15) <= x(8);


end Formula_SE_9to16;


library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use work.all;

entity Testbench_senine is
end entity;

architecture behave of Testbench_senine is
	signal x: std_logic_vector(8 downto 0);
	signal y: std_logic_vector(15 downto 0);
	
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
	
	dut: entity sign_extender_9to16 port map(x=>x,y=>y);


  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "SE9-16.txt";
    FILE OUTFILE: text  open write_mode is "OUT_DE.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable active: bit_vector(8 downto 0);
    variable op: bit_vector(15 downto 0);
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
         
        if (y /= to_std_logic_vector(op)) then
            write(OUTPUT_LINE,to_string("ERROR: in RESULT, line "));
            write(OUTPUT_LINE, LINE_COUNT);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, op);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, str(y));
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, str(x));
            writeline(OUTFILE, OUTPUT_LINE);
            err_flag := true;
		else 
		   write(OUTPUT_LINE,to_string("CORRECT: in RESULT, line "));
		    write(OUTPUT_LINE, LINE_COUNT);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, op);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, str(y));
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, str(x));
		   writeline(OUTFILE, OUTPUT_LINE);
        end if;
        
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  	end process;

end behave;


