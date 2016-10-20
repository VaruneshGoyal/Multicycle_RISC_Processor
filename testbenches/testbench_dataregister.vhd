

---------------------------------Component-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0) := (others => '0');
	      clk, enable: in std_logic);
end entity;
architecture Behave of DataRegister is
	signal zero_16: std_logic_vector(15 downto 0);
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               Dout <= Din;
           end if;
       end if;
    end process;
end Behave;
----------------------------------Testbench--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use work.all;

entity Testbench_dataregister is
end entity;

architecture behave of Testbench_dataregister is
	signal x: std_logic_vector(15 downto 0);
	signal y: std_logic_vector(15 downto 0);
	signal e: std_logic := '0';
	signal clk: std_logic := '1';
---------------------to string---------------------------------------------
	function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
	  begin  
		  ret_val := lx;
		  return(ret_val);
	  end to_string;
----------------------to_std_logic--------------------------------------------------------
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
----------------------to_std_logic--------------------------------------------------------
  function to_std_logic(i : in bit) return std_logic is
		begin
			if (i = '0') then
				return '0';
			end if;
			return '1';
		end function;
  
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
------------------------------------------------------------------------------------------------
   
   begin
   
   	dut: entity DataRegister generic map (data_width=>16)
				port map (Din=>x,
				  Dout=>y,
				  enable=>e,
				  clk=>clk);
   
---------------!!!!!!!!!!!!!!!!!!!!!!!!!!!--------------------------------------------------
	clk <= not clk after 10 ns;
	process
	    variable err_flag : boolean := true;
		File INFILE: text open read_mode is "tracefile_dataregister.txt";
		FILE OUTFILE: text  open write_mode is "OUT_DR.txt";
		variable input_bv: bit_vector (15 downto 0);
		variable exp_output:bit_vector (15 downto 0);
		variable e_var : bit;
		
		variable INPUT_LINE: Line;
		variable OUTPUT_LINE: Line;
		variable LINE_COUNT: integer := 0;

		   begin
   	
   		while not endfile(INFILE) loop
   	
   		LINE_COUNT := LINE_COUNT + 1;
	    readline(INFILE, INPUT_LINE);
	    
	    read(INPUT_LINE, e_var);
        e <= to_std_logic(e_var);
        
        read(INPUT_LINE, input_bv);
        x <= to_std_logic_vector(input_bv);

		read(INPUT_LINE, exp_output);
		
		wait for 20 ns;
		
		    write(OUTPUT_LINE, LINE_COUNT);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, e_var);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, exp_output);            
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, input_bv);
            write(OUTPUT_LINE, to_string(" "));
            write(OUTPUT_LINE, str(y));
            writeline(OUTFILE, OUTPUT_LINE);
            
        if (y /= to_std_logic_vector(exp_output)) then
            err_flag := false;
        end if;
        
        
	end loop;
	
	assert (not err_flag) report "SUCCESS, all tests passed." severity note;
    assert (err_flag) report "FAILURE, some tests failed." severity error;
    
	wait;
	end process;
	end behave;


















