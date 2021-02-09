//Matthew Capuano -- EE 417 -- Feb. 10 2021
// 1. 8-3 Priority Encoder --> generates two 4-2 priority encoders --> generates 2 primites and a switching fn
// 2. Ones Counter --> generates four 1bit half adders and in parallel three 4 bit full adders --> generates four 1 bit full adders

module assignment_3(

//priority encoder IO:
input  [7:0] enc_inputs, 
output [3:0] enc_outputs, //bit 0 is "All_zero"


//Ones counter IO:
input  [7:0] cnt_inputs,
output [3:0] cnt_outputs
);


///////////////////////////////////////
//Priority Encoder Top Level Design://
/////////////////////////////////////
wire [2:0] four_two_MS;
wire [2:0] four_two_LS;
//instantiate two 4-2 encoders:
four_two_enc fte0(
.four_two_inputs  (enc_inputs[7:4]),
.four_two_outputs (four_two_MS)
);

four_two_enc fte1(
.four_two_inputs  (enc_inputs[3:0]),
.four_two_outputs (four_two_LS)
);

//perform top-level output logic:
assign enc_outputs[3] = ~four_two_MS[0]; //assert high if input on 4MSB triggers
assign enc_outputs[2] = (~four_two_MS[0] & four_two_MS[2]) | (four_two_MS[0] & four_two_LS[2]); //output MS encoder if any 4MSB triggers, otherwise output LS encoder
assign enc_outputs[1] = (~four_two_MS[0] & four_two_MS[1]) | (four_two_MS[0] & four_two_LS[1]); //output MS encoder if any 4MSB triggers, otherwise output LS encoder
assign enc_outputs[0] = four_two_MS[0] & four_two_LS[0];

///////////////////////////////////
//Ones Counter Top Level Design://
/////////////////////////////////
wire [1:0] ha0;
wire [1:0] ha1;
wire [1:0] ha2;
wire [1:0] ha3;
//instantiate 4 half adders to add every 2 bits 					 
two_bit_half_adder tbha0(
.add_in  (cnt_inputs[7:6]),
.add_out (ha3)
);

two_bit_half_adder tbha1(
.add_in  (cnt_inputs[5:4]),
.add_out (ha2)
);

two_bit_half_adder tbha2(
.add_in  (cnt_inputs[3:2]),
.add_out (ha1)
);

two_bit_half_adder tbha3(
.add_in  (cnt_inputs[1:0]),
.add_out (ha0)
);

wire [3:0] sum0;
wire [3:0] sum1;

//instantiate 2 full adders to add the outputs of the 4 previous half adders
four_bit_adder fba0(
.add_a ({2'b00, ha0}),
.add_b ({2'b00, ha1}),
.sum   (sum0)
);

four_bit_adder fba1(
.add_a ({2'b00, ha2}),
.add_b ({2'b00, ha3}),
.sum   (sum1)
);
//instantiate a third full adder to add the output of the 2 previous full adders
four_bit_adder fba2(
.add_a (sum0),
.add_b (sum1),
.sum   (cnt_outputs)
);


endmodule


////////////////////////////////										
//Priority Encoder Submodules://
///////////////////////////////
module four_two_enc(
input  [3:0] four_two_inputs,
output [2:0] four_two_outputs //bit 0 is "All_zero"
);
//instantiate primitve for MSB:
four_two_enc_MSB fteM0(four_two_outputs[2], four_two_inputs[3], four_two_inputs[2], four_two_inputs[1], four_two_inputs[0]);
//instantiate primitive for LSB:
four_two_enc_LSB fteL0(four_two_outputs[1], four_two_inputs[3], four_two_inputs[2], four_two_inputs[1], four_two_inputs[0]);
//switching fn for bit 0:
assign four_two_outputs[0] = ~(four_two_inputs[3] | four_two_inputs[2] | four_two_inputs[1] | four_two_inputs[0]);
endmodule

primitive four_two_enc_MSB(d1,a3, a2, a1, a0);

output d1;
input  a3;
input  a2;
input  a1;
input  a0;

table
//a3 a2 a1 a0 : d1
  1  ?  ?  ?  : 1;
  0  1  ?  ?  : 1;
  0  0  1  ?  : 0;
  0  0  0  1  : 0;
  0  0  0  0  : 0;//? //cannot have ? on output: quartus will accept it but modelsim will not!
endtable
endprimitive




primitive four_two_enc_LSB(
output d0,
input a3, a2, a1, a0
);
table
//a3 a2 a1 a0 : d0
  1  ?  ?  ?  : 1;
  0  1  ?  ?  : 0;
  0  0  1  ?  : 1;
  0  0  0  1  : 0;
  0  0  0  0  : 0;//?

endtable
endprimitive









/////////////////////////////
//Ones Counter Submodules://
///////////////////////////


//module for 1 bit half adder
module two_bit_half_adder(
input  [1:0] add_in,
output [1:0] add_out
);
assign add_out[0] = add_in[1] ^ add_in[0];
assign add_out[1] = add_in[1] & add_in[0];
endmodule

//module for 4 bit full adder
module four_bit_adder(
input  [3:0] add_a,
input  [3:0] add_b,
output [3:0] sum
);

wire cout0, cout1, cout2;
two_bit_full_adder tbfa0(
.add_a (add_a[0]),
.add_b (add_b[0]),
.c_in   (1'b0),
.sum    (sum[0]),
.c_out  (cout0)
);

two_bit_full_adder tbfa1(
.add_a (add_a[1]),
.add_b (add_b[1]),
.c_in   (cout0),
.sum    (sum[1]),
.c_out  (cout1)
);

two_bit_full_adder tba2(
.add_a (add_a[2]),
.add_b (add_b[2]),
.c_in   (cout1),
.sum    (sum[2]),
.c_out  (cout2)
);

two_bit_full_adder tbfa3(
.add_a (add_a[3]),
.add_b (add_b[3]),
.c_in   (cout2),
.sum    (sum[3]),
.c_out  ()
);

endmodule

//module for 1 bit full adder 
module two_bit_full_adder(
input  add_a,
input add_b,
input c_in,
output sum,
output c_out
);
assign sum = c_in ^ (add_a ^ add_b);
assign c_out = (add_a & add_b) | (add_b & c_in) | (add_a & c_in);   
endmodule








