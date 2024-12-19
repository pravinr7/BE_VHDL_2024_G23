Library ieee;
use ieee.std_logic_1164.all;

ENTITY port_et IS 
   PORT (
      a,b          :  IN STD_logic;
      s            :  OUT STD_LOGIC);
END port_et;


ARCHITECTURE beh of port_et is 
BEGIN 
      s<=a AND b;
END beh;