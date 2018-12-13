library verilog;
use verilog.vl_types.all;
entity node_tb is
    generic(
        n               : integer := 32;
        sx              : integer := 2;
        f               : integer := 24
    );
end node_tb;
