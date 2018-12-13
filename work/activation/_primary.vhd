library verilog;
use verilog.vl_types.all;
entity activation is
    generic(
        n               : integer := 32;
        sx              : integer := 2;
        f               : integer := 24
    );
end activation;
