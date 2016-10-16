library ieee;
use ieee.std_logic_1164.all;



entity zero_checker is
port( X :in std_logic_vector(15 downto 0);
      Z:out std_logic
      
 );
end zero_checker;

architecture Formula_ZC of zero_checker is

begin
Z <= not(X(0) or X(1) or X(2) or X(3) or X(4) or X(5) or X(6) or X(7));
end Formula_ZC;


