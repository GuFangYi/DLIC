module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output reg R,
    output reg G,
    output reg Y
);
reg [2:0] cur_state;
reg [2:0] next_state;
reg [10:0] countcycle;
reg [10:0] change_state_nb;
localparam FIRSTGREEN=3'd0;
localparam FIRSTNONE=3'd1;
localparam SECONDGREEN=3'd2;
localparam SECONDNONE=3'd3;
localparam THIRDGREEN=3'd4;
localparam YELLOW=3'd5;
localparam RED=3'd6;


//FSM
always@(posedge clk or posedge rst) begin //state control
	if(rst) begin
	  cur_state<=FIRSTGREEN;
	  countcycle<=11'd1;
	end
	else begin 
	  countcycle<=countcycle+11'd1;
	  if(countcycle==change_state_nb) begin
	      countcycle<=11'd1;
	      cur_state<=next_state;
	  end
	  if(pass)begin
		  if(cur_state!=FIRSTGREEN) begin
		   cur_state<=FIRSTGREEN;
		   countcycle<=11'd1;
		  end
		end
	end
	  
	
end

always@(cur_state) begin //next state condition

case(cur_state)
  FIRSTGREEN: begin
    change_state_nb=11'd1024;
    next_state=FIRSTNONE;
  end
  
  FIRSTNONE: begin
    change_state_nb=11'd128;
    next_state=SECONDGREEN;
  end  
  
  SECONDGREEN: begin
    change_state_nb=11'd128;
    next_state=SECONDNONE;
  end
  
  SECONDNONE: begin
    change_state_nb=11'd128;
    next_state=THIRDGREEN;
  end
  
  THIRDGREEN: begin
    change_state_nb=11'd128;
    next_state=YELLOW;
  end
  
  YELLOW: begin
   change_state_nb=11'd512;
   next_state=RED;
  end
  
  RED: begin
    change_state_nb=11'd1024;
    next_state=FIRSTGREEN;
  end
  
endcase 
end

always@(cur_state) begin //output
case(cur_state)
 FIRSTGREEN: begin
  G=1'b1;
  Y=1'b0;
  R=1'b0;
  end
  
  FIRSTNONE: begin
  G=1'b0;
  Y=1'b0;
  R=1'b0;
  end  
  
  SECONDGREEN: begin
  G=1'b1;
  Y=1'b0;
  R=1'b0;
  end
  
  SECONDNONE: begin
  G=1'b0;
  Y=1'b0;
  R=1'b0;
  end
  
  THIRDGREEN: begin
  G=1'b1;
  Y=1'b0;
  R=1'b0;
  end
  
  YELLOW: begin
  G=1'b0;
  Y=1'b1;
  R=1'b0;
  end
  
  RED: begin
  G=1'b0;
  Y=1'b0;
  R=1'b1;
  end
endcase
end

endmodule
