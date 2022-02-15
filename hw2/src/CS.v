module CS(
  input                                 clk, 
  input                                 reset,
  input                           [7:0] X,
  output                          [9:0] Y
);

parameter number = 4'd9;
reg [7:0] approx;
reg [7:0] SR[8:0];
reg [11:0] sum;
reg [3:0] i;

always@(posedge clk or posedge reset)begin
  if(reset)begin
    sum <= 12'd0;
    SR[0] <= 8'd0;
    SR[1] <= 8'd0;
    SR[2] <= 8'd0;
    SR[3] <= 8'd0;
    SR[4] <= 8'd0;
    SR[5] <= 8'd0;
    SR[6] <= 8'd0;
    SR[7] <= 8'd0;
    SR[8] <= 8'd0;
  end
  else begin
      //shift register
      SR[0] <= SR[1]; //X1 <- X2
      SR[1] <= SR[2]; //X2
      SR[2] <= SR[3]; //X3
      SR[3] <= SR[4]; //X4
      SR[4] <= SR[5]; //X5
      SR[5] <= SR[6]; //X6
      SR[6] <= SR[7]; //X7
      SR[7] <= SR[8]; //X8
      SR[8] <= X;     //X9
      
      sum <= sum + X - SR[0];

  end

end

//shift 3 + itself = mul 9
assign Y = (sum + (($unsigned(approx) <<3) + approx))>>3; 


always@(*)begin
	approx = 0;
 	for(i = 0;i<number;i=i+1)begin
  	//sum = avg*number, so if SR*number<=sum, SR<=avg
  	//approx is always < avg, so the bigger the approx, the closer it is to avg

  		if((($unsigned(SR[i])<<3)+SR[i]) <= sum && SR[i] > approx) begin 
  			approx = SR[i];
  		end
  end
end





endmodule
