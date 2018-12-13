library verilog;
use verilog.vl_types.all;
entity \map\ is
    generic(
        n               : integer := 32;
        sx              : integer := 2
    );
    port(
        x               : in     vl_logic_vector;
        y               : out    vl_logic_vector
    );
end \map\;
