onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /node_tb/clk
add wave -noupdate -format Logic /node_tb/rst
add wave -noupdate -divider Group
add wave -noupdate -format Literal -radix hexadecimal /node_tb/nx
add wave -noupdate -format Literal -radix hexadecimal /node_tb/nw
add wave -noupdate -divider Separated
add wave -noupdate -format Literal -radix hexadecimal -expand /node_tb/node11/x
add wave -noupdate -format Literal -radix hexadecimal /node_tb/node11/w
add wave -noupdate -format Literal /node_tb/b
add wave -noupdate -divider Process
add wave -noupdate -format Literal /node_tb/mac
add wave -noupdate -format Literal /node_tb/z
add wave -noupdate -format Literal /node_tb/y
add wave -noupdate -divider Tests
add wave -noupdate -format Literal /node_tb/seed
add wave -noupdate -format Literal /node_tb/ref1
add wave -noupdate -format Literal /node_tb/ref2
add wave -noupdate -format Literal /node_tb/ref3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {274 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {902 ns}
