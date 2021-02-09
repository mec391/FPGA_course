`timescale 1ns/1ns

module assignment_3_tb();

//priority encoder IO:
reg  [7:0] enc_inputs; 
wire [3:0] enc_outputs;

//Ones counter IO:
reg  [7:0] cnt_inputs;
wire [3:0] cnt_outputs;

//route to unit under test
assignment_3 UUT(
 
.enc_inputs 	(enc_inputs),
.enc_outputs 	(enc_outputs),
.cnt_inputs 	(cnt_inputs),
.cnt_outputs 	(cnt_outputs)

);

//feed input logic to UUT
initial begin
enc_inputs = 0;
cnt_inputs = 0;


//Priority Encoder should keep same value for 2 time delays
//ones counter should count up every 1 time delay
#1 enc_inputs = 8'b1000_0000; cnt_inputs = 8'b0000_0001;
#1 enc_inputs = 8'b1111_1111; cnt_inputs = 8'b0000_0011;
#1 enc_inputs = 8'b0100_0000; cnt_inputs = 8'b0000_0111;
#1 enc_inputs = 8'b0111_1111; cnt_inputs = 8'b0000_1111;
#1 enc_inputs = 8'b0010_0000; cnt_inputs = 8'b0001_1111;
#1 enc_inputs = 8'b0011_1111; cnt_inputs = 8'b0011_1111;
#1 enc_inputs = 8'b0001_0000; cnt_inputs = 8'b0111_1111;
#1 enc_inputs = 8'b0001_1111; cnt_inputs = 8'b1111_1111;
#1 enc_inputs = 8'b0000_1000;
#1 enc_inputs = 8'b0000_1111;
#1 enc_inputs = 8'b0000_0100;
#1 enc_inputs = 8'b0000_0111;
#1 enc_inputs = 8'b0000_0010;
#1 enc_inputs = 8'b0000_0011;
#1 enc_inputs = 8'b0000_0001;
//this should trigger a 1 for all_zero
#1 enc_inputs = 0;


end



//generate monitor
initial begin
$monitor($time,,"enc_inputs = %b enc_outputs = %b cnt_inputs = %b cnt_outputs = %d",enc_inputs, enc_outputs, cnt_inputs, cnt_outputs);
end 

endmodule