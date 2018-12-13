`ifndef FIXED_POINT
  // Bit
  `define n 32
  // Fraction
  `define f 24
  // Integer
  `define i n-f-1   // The actual bit is added by 1.
  `define FIXED_POINT
`endif  