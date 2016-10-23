library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity S3_decoder is
port( i0, i2, i3, z: in std_logic;				--z from alu (not reg)
      S3_decoder_out : out std_logic_vector(3 downto 0)
 );
end S3_decoder;


architecture combinational of S3_decoder is
	--signal state : std_logic_vector(3 downto 0);
begin
	--S1 : BEQ&Z1
	--S7 : BEQ&Z0
	--S6 : SW
	--S4 : ADD, ADC, ADZ, ADI, NDU, NDC, NDZ
	--S40: LW
	--NA : LM, SM, JAL, JLR, LHI
	S3_decoder_out(0) <= i2 and (not i0);
	S3_decoder_out(1) <= ((not z) and i2) or ((not i3) and z);
	S3_decoder_out(2) <= (not z) or (z and (not i3));
	S3_decoder_out(3) <= i2 or (not i0) or (not i3);
end combinational;
      
