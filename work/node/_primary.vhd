library verilog;
use verilog.vl_types.all;
entity node is
    generic(
        n               : integer := 32;
        sx              : integer := 2;
        f               : integer := 24
    );
    port(
        nx              : in     vl_logic_vector;
        nw              : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        y               : out    vl_logic_vector
    );
end node;
