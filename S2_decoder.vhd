library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity S2_decoder is
port( i0, i2, i3, p0, p1, z, c: in std_logic;
      S2_decoder_out : out std_logic_vector(3 downto 0)
 );
end S2_decoder;


architecture combinational of S2_decoder is
	--signal state : std_logic_vector(3 downto 0);
begin
        --S1 : ADC&C0, ADZ&Z0, NDC&C0, NDZ&Z0
	--S3 : ADD, ADC&C1, ADZ&Z1, ADI, NDU, NDC&C1, NDZ&Z1, LW, SW, BEQ
	--S9 : JLR
	--NA : LM, SM, LHI, JAL
	S2_decoder_out(0) <= '1';
	S2_decoder_out(1) <= i2 or (i0 and (not i3)) or ((not i0) and (not i3) and ( (p0 and z) or (p1 and c) or ((not p0) and (not p1)) ) );
	S2_decoder_out(2) <= '0';
	S2_decoder_out(3) <= (not i2) and i3;
end combinational;
      
