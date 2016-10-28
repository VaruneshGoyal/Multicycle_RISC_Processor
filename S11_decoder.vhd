library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity S11_decoder is
port( z_Rpe: in std_logic;
      S11_decoder_out : out std_logic_vector(3 downto 0)
 );
end S11_decoder;


architecture combinational of S11_decoder is
	--signal state : std_logic_vector(3 downto 0);
begin
	--S1 : LM&Rpe=0
	--S11: LM&Rpe!=0
	--NA : others
	S11_decoder_out(0) <= z_Rpe;
	S11_decoder_out(1) <= '0';
	S11_decoder_out(2) <= not z_Rpe;
	S11_decoder_out(3) <= not z_Rpe;
end combinational;
      
