library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity S12_decoder is
port( z_Rpe: in std_logic;
      S12_decoder_out : out std_logic_vector(3 downto 0)
 );
end S12_decoder;


architecture combinational of S12_decoder is
	--signal state : std_logic_vector(3 downto 0);
begin
	--S1 : LM&Rpe=0
	--S11: LM&Rpe!=0
	--NA : others
	S12_decoder_out(0) <= '1';
	S12_decoder_out(1) <= not z_Rpe;
	S12_decoder_out(2) <= '0';
	S12_decoder_out(3) <= not z_Rpe;
end combinational;
      
