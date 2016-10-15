library ieee;
use ieee.std_logic_1164.all;


entity Mux_10bit is
port(
	s: in std_logic;
	x,y: in std_logic_vector( 9 downto 0);
	z : out std_logic_vector( 9 downto 0)
);
end Mux_10bit;
architecture Formula_mux_10b of Mux_10bit is

begin

z(0) <= (x(0) and (not s)) or (y(0) and s);
z(1) <= (x(1) and (not s)) or (y(1) and s);
z(2) <= (x(2) and (not s)) or (y(2) and s);
z(3) <= (x(3) and (not s)) or (y(3) and s);

z(4) <= (x(4) and (not s)) or (y(4) and s);
z(5) <= (x(5) and (not s)) or (y(5) and s);
z(6) <= (x(6) and (not s)) or (y(6) and s);
z(7) <= (x(7) and (not s)) or (y(7) and s);

z(8) <= (x(8) and (not s)) or (y(8) and s);
z(9) <= (x(9) and (not s)) or (y(9) and s);

end Formula_mux_10b;


library ieee;
use ieee.std_logic_1164.all;


entity sign_extender_6to16 is
port(
	x: in std_logic_vector(5 downto 0);
	y : out std_logic_vector( 15 downto 0)
);
end sign_extender_6to16;

architecture Formula_SE_6to16 of sign_extender_6to16 is 



begin

	y(0) <= x(0);
	y(1) <= x(1);
	y(2) <= x(2);
	y(3) <= x(3);
	y(4) <= x(4);
	y(5) <= x(5);
	y(6) <= x(5);
	y(7) <= x(5);
	y(8) <= x(5);
	y(9) <= x(5);
	y(10) <= x(5);
	y(11) <= x(5);
	y(12) <= x(5);
	y(13) <= x(5);
	y(14) <= x(5);
	y(15) <= x(5);


end Formula_SE_6to16;


library ieee;
use ieee.std_logic_1164.all;


entity sign_extender_9to16 is
port(
	x: in std_logic_vector(9 downto 0);
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
	y(9) <= x(5);
	y(10) <= x(8);
	y(11) <= x(8);
	y(12) <= x(8);
	y(13) <= x(8);
	y(14) <= x(8);
	y(15) <= x(8);


end Formula_SE_9to16;

