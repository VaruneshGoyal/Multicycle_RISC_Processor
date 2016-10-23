library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity S6_decoder is
port( i1, z_Rpe: in std_logic;
      S6_decoder_out : out std_logic_vector(3 downto 0)
 );
end S6_decoder;


architecture combinational of S6_decoder is
	--signal state : std_logic_vector(3 downto 0);
begin
	--S1 : SW
	--S7 : SM&Rpe=0
	--S14: SM&(Rpe!=0)
	--NA : others
	S6_decoder_out(0) <= z_Rpe or ((not z_Rpe) and (not i1));
	S6_decoder_out(1) <= i1;
	S6_decoder_out(2) <= i1;
	S6_decoder_out(3) <= (not z_Rpe) and i1;
end combinational;
      
