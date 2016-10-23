library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity S1_decoder is
port( i0, i1, i2, i3: in std_logic;
      S1_decoder_out : out std_logic_vector(3 downto 0)
 );
end S1_decoder;


architecture combinational of S1_decoder is
	--signal state : std_logic_vector(3 downto 0);
begin
        --S2 : ADD, ADC, ADZ, ADI, NDU, NDC, NDZ, LW, SW, BEQ, JLR
	--S5 : LHI
	--S8 : JAL
	--S10 : LM
	--S13 : SM
	S1_decoder_out(0) <= i1 and i0;
	S1_decoder_out(1) <= ((not i1) and (i0 or i2)) or ((not i0) and (not i3));
	S1_decoder_out(2) <= i1 and i0;
	S1_decoder_out(3) <= (i3 and (not i2) and (not i1) and (not i0)) or (i1 and i2);
end combinational;
      
