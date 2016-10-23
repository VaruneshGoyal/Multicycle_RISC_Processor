library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

package Microprocessor_project is
type Data_in is array (natural range <>) of std_logic_vector(15 downto 0);
type Data_in_3 is array (natural range <>) of std_logic_vector(2 downto 0);
type Data_in_8 is array (natural range <>) of std_logic_vector(7 downto 0);
type Data_in_1 is array (natural range <>) of std_logic_vector(0 downto 0);
--type FsmState is ( instruction_fetch, S2, S3, S4, S40, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);

component priority_encoder is
port(  
	x: in std_logic_vector(7 downto 0);
	y: out std_logic_vector(2 downto 0)
       
 );
end component;

component encode_modifier is
port( encode_bits : in std_logic_vector(2 downto 0);
      priority_bits_in : in std_logic_vector(7 downto 0);
      priority_bits_out	: out std_logic_vector( 7 downto 0)
	);

end component;


component decoder_pe is
port(  x: in std_logic_vector(2 downto 0);
	y: out std_logic_vector(7 downto 0)
	
       
 );
end component;

component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable,reset: in std_logic);
end component;

component Data_MUX is
generic (control_bit_width:integer);
port(Din:in Data_in( (2**control_bit_width)-1 downto 0);
	Dout:out std_logic_vector(15 downto 0);
	control_bits:in std_logic_vector(control_bit_width-1 downto 0)
);
end component;

component Memory is
port ( Din: in std_logic_vector(15 downto 0);
	Dout: out std_logic_vector(15 downto 0);
	write_enable,read_enable,clk: in std_logic;
	Addr: in std_logic_vector(15 downto 0)
);
end component;

component Reg_File is

port( A1,A2,A3: in std_logic_vector(2 downto 0);
      D1, D2: out std_logic_vector(15 downto 0);
      write_enable,clk: in std_logic;
      pc_enable:in std_logic;
      D3: in std_logic_vector( 15 downto 0);
      R7_data_in : in std_logic_vector(15 downto 0);
      R7_data_out : out std_logic_vector(15 downto 0)
);
end component;

component ALU is
port( X,Y: in std_logic_vector(15 downto 0);
      Z : out std_logic_vector(15 downto 0);
      carry_flag,zero_flag :out std_logic;
      Control_bits: in std_logic_vector(1 downto 0)
      
 );
end component;


component ALU_adder is
port(  
	x,y: in std_logic_vector(15 downto 0);
	c_in : in std_logic;
	s: out std_logic_vector(15 downto 0);
       	c_out: out std_logic
 );
end component;

component ALU_XOR is
port( X,Y: in std_logic_vector(15 downto 0);
      Z : out std_logic_vector(15 downto 0)
 );
end component;

component ALU_NAND is
port( X,Y: in std_logic_vector(15 downto 0);
      Z : out std_logic_vector(15 downto 0)
 );
end component;

component full_adder is
port(  
	x,y,c_in: in std_logic;
	s, c_out: out std_logic
       
 );
end component;



component zero_checker is
port( X :in std_logic_vector(15 downto 0);
      Z:out std_logic
      
 );
end component;


component inverter is
port( X : in std_logic_vector(16 downto 0);
      Y : out std_logic_vector(16 downto 0)
 );
end component;

-- used to multiplex 8 bit data fed to priority encoder
component Data_MUX_8 is
generic (control_bit_width:integer);
port(Din:in Data_in_8( (2**control_bit_width)-1 downto 0);
	Dout:out std_logic_vector(7 downto 0);
	control_bits:in std_logic_vector(control_bit_width-1 downto 0)
);
end component;
--- used to multiplex 3 bit data fed to A1 RF
component Data_MUX_3 is
generic (control_bit_width:integer);
port(Din:in Data_in_3( (2**control_bit_width)-1 downto 0);
	Dout:out std_logic_vector(2 downto 0);
	control_bits:in std_logic_vector(control_bit_width-1 downto 0)
);
end component;

--data extender
component data_extender_9to16 is
port(
	x: in std_logic_vector(8 downto 0);
	y: out std_logic_vector( 15 downto 0)
);
end component;

--sign extender 6 to 16
component sign_extender_6to16 is
port(
	x: in std_logic_vector(5 downto 0);
	y: out std_logic_vector( 15 downto 0)
);
end component;
--sign extender 6 to 16
component sign_extender_9to16 is
port(
	x: in std_logic_vector(8 downto 0);
	y: out std_logic_vector( 15 downto 0)
);
end component;

--data mux for zero flag
component Data_MUX_1 is
generic (control_bit_width:integer);
port(Din:in Data_in_1( (2**control_bit_width)-1 downto 0);
	Dout:out std_logic_vector(0 downto 0);
	control_bits:in std_logic_vector(control_bit_width-1 downto 0)
);
end component;

component S1_decoder is
port( i0, i1, i2, i3: in std_logic;
      S1_decoder_out : out std_logic_vector(3 downto 0)
 );
end component;

component S2_decoder is
port( i0, i2, i3, p0, p1, z, c: in std_logic;
      S2_decoder_out : out std_logic_vector(3 downto 0)
 );
end component;

component S3_decoder is
port( i0, i2, i3, z: in std_logic;
      S3_decoder_out : out std_logic_vector(3 downto 0)
 );
end component;

component S6_decoder is
port( i1, z_Rpe: in std_logic;
      S6_decoder_out : out std_logic_vector(3 downto 0)
 );
end component;

component S12_decoder is
port( z_Rpe: in std_logic;
      S12_decoder_out : out std_logic_vector(3 downto 0)
 );
end component;

component ALUnFLAG_decoder is
port( IR15, IR14, IR13: in std_logic;
      ALU_decoder_out : out std_logic_vector(1 downto 0);
      carry_decoder_out, zero_decoder_out : out std_logic
 );
end component;



end package;

