library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end entity;
architecture Behave of Testbench is
  	signal from_memory_data, to_memory_address : std_logic_vector(15 downto 0); 
	signal mem_read_en_sig, mem_write_en_sig : std_logic;
	signal reset: std_logic := '0';
	signal clk: std_logic := '0';

	component IITB_RISC_Microprocessor is
		port(
			clk,reset: in std_logic;
			from_memory_data: in std_logic_vector(15 downto 0);
			to_memory_address: out std_logic_vector(15 downto 0);
			mem_read_en_sig, mem_write_en_sig : out std_logic  );
	end component;
	
	function bitvec_to_str ( x : bit_vector ) return String is
		variable L : line ;
		variable W : String (1 to x ' length ) :=( others => ' ') ;
		begin
			write (L , x ) ;
			W ( L . all ' range ) := L . all ;
			Deallocate ( L ) ;
		return W ;
	end bitvec_to_str ;

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

   function std_logic_vec_to_str(slv: std_logic_vector) return string is
     variable result : string (1 to slv'length);
     variable r : integer;
   begin
     r := 1;
     for i in slv'range loop
        result(r) := chr(slv(i));
        r := r + 1;
     end loop;
     return result;
   end std_logic_vec_to_str;
	
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

-------------------------------------------------------------------------------------------------------------------------------------
begin
	clk <= not clk after 20 ns;
	process
	file f : text open read_mode is "TRACEFILE_TOPLEVEL.txt" ;
	file g : text open write_mode is "error_log.txt" ;
	variable vfrom_memory_data : bit_vector (15 downto 0) ;
	--variable vto_memory_address : bit_vector (15 downto 0) ;
	--variable op_code : bit_vector (1 downto 0) ;
	variable L : line ;
	--variable to_check : string;
	variable expected_output : bit_vector (15 downto 0);
	variable expected_flags : bit_vector(1 downto 0);

	begin
		while not endfile(f) loop
			while (mem_read_en_sig = '0') loop
			end loop ;
			readline(f,L);
			read(L,vfrom_memory_data);
			--read(L,vto_memory_address);
			from_memory_data <= to_std_logic_vector(vfrom_memory_data);

			wait for 15 ns ;
			
		end loop ;

		--assert (error_flag = '0') report "Test completed. Errors present. See error_log.txt"
		--	severity error;
		--assert (error_flag = '1') report "Test completed. Successful!!!"
		--	severity note;
		wait ;
	end process ;


	dut : IITB_RISC_Microprocessor port map (clk => clk, reset => reset,
			from_memory_data => from_memory_data, to_memory_address => to_memory_address, 
			mem_read_en_sig => mem_read_en_sig, mem_write_en_sig => mem_write_en_sig );

end Behave ;




















