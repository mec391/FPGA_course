`timescale 1ns/1ns
module assignment_4_tb();
	reg  [3:0] bcd_in;
	wire [6:0] seven_seg_out;
	wire [6:0] hex0;
	wire [6:0] hex1;
	wire [6:0] d0;
	wire [6:0] d1;
	
assignment_4 UUT(
.bcd_in (bcd_in),
.seven_seg_out (seven_seg_out),
.hex0 (hex0),
.hex1 (hex1),
.d1 (d1),
.d0 (d0)

	);

initial begin
	bcd_in = 0;
end

always begin 
#1 bcd_in = bcd_in + 1;
end

initial begin
$monitor($time,,"BCD_IN = %d SEVEN_SEG_OUT = %b HEX1 = %b HEX0 = %b  D1 = %b  D0 = %b",bcd_in, seven_seg_out, hex1, hex0, d1, d0);
end 

endmodule