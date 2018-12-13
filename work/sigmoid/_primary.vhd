library verilog;
use verilog.vl_types.all;
entity sigmoid is
    generic(
        n               : integer := 32;
        sx              : integer := 2;
        f               : integer := 24
    );
    port(
        x               : in     vl_logic_vector;
        y               : out    vl_logic_vector
    );
end sigmoid;
