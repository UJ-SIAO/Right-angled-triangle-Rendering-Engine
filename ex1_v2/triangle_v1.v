module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);

input clk, reset, nt;
input [2:0] xi, yi;
output busy, po;
output [2:0] xo, yo;

reg busy;
reg po;
reg [2:0]xo;
reg [2:0]yo;

reg [2:0]x[2:0];
reg [2:0]y[2:0];
reg [1:0]recive_cnt=0;
reg [2:0]x_index;
reg [2:0]y_index;
reg 	 next_x;
reg 	 next_y;
reg [2:0]temp_line;
reg [2:0]temp_locat;
reg x_add;
reg y_add;

wire in ;
wire signed [9:0]compare_loaction1;
wire signed [9:0]compare_loaction2;
wire x_in;
wire y_in;
wire loc_in;

always@(posedge clk or  posedge reset)begin
	if(reset)
		recive_cnt<=0;
	else begin
		if(recive_cnt==2)
			recive_cnt<=3;
		else if(!busy)
			recive_cnt<=recive_cnt+1;
	end
end

always@(posedge clk or  posedge reset)begin
	if(reset)begin
		x[0]<=0;
		x[1]<=0;
		x[2]<=0;
	end
	else begin
		case(recive_cnt)
			0	:	begin
						
							x[0]<=xi;
					end
			1	:	begin
						
							x[1]<=xi;
					end
			2	:	begin
						
							x[2]<=xi;
					end
			default : ;
		endcase
	end
end

always@(posedge clk or  posedge reset)begin
	if(reset)begin
		y[0]<=0;
		y[1]<=0;
		y[2]<=0;
	end
	else begin
		case(recive_cnt)
			0	:	begin
						
							y[0]<=yi;
					end
			1	:	begin
						
							y[1]<=yi;
					end
			2	:	begin
						
							y[2]<=yi;
					end
			default : ;
		endcase
	end
end

always@(posedge clk or  posedge reset)begin
	if(reset)
		busy<=0;
	else begin
		if(recive_cnt==1)
			busy<=1;
		else if(x_index >= x[2] && y_index >= y[2] && recive_cnt==3 )
			busy<=0;
	end
end

/* always@(posedge clk or  posedge reset)begin
	if(reset)
		next_x<=0;
	else begin
		if()
			next_x<=1;
		else
			next_x<=0;
	end
end

always@(posedge clk or  posedge reset)begin
	if(reset)
		next_x<=0;
	else begin
		if()
			next_x<=1;
		else
			next_x<=0;
	end
end */

always@(posedge clk or  posedge reset)begin
	if(reset)begin
		x_index<=0;
		y_add<=0;
	end
	else begin
		if(busy)begin
			if(x_index==7) begin
				x_index<=0;
				y_add<=0;
			end
			else if (x_index == 6 ) begin
				y_add<=1;
				x_index<=x_index+1;
			end
			else 
				x_index<=x_index+1;
		end
		else
			x_index<=0;
	end
end

always@(posedge clk or  posedge reset)begin
	if(reset) begin
		y_index<=0;
	end
	else begin
		if(busy)begin
			if(y_index==7 && x_index==7) begin
				y_index<=0;
			end
			else if (y_add)
				y_index<=y_index+1;
		end
		else
			y_index<=0;
	end
end


assign compare_loaction1 = (x_index-x[1])*(y[2]-y[1]);
assign compare_loaction2 = (y_index-y[1])*(x[2]-x[1]);



	
assign x_in   = (x[0] <= x_index &&  x_index<= x[1])	? 1 : 0 ;
assign y_in   = (y[0] <= y_index &&  y_index<= y[2])	? 1 : 0 ;
assign loc_in = (compare_loaction1 <= compare_loaction2) ? 1 : 0 ;
assign in = x_in && y_in && loc_in ;
			
/*always(*)begin
	if(compare_loaction1[9] && compare_loaction2[9])begin
		if(compare_loaction1)
	end
		
end*/

always@(posedge clk or  posedge reset)begin
	if(reset)begin
		xo<=0;
		yo<=0;
	end
	else begin
		if(busy==1)begin
			if(x_in && y_in && loc_in && recive_cnt == 3)begin
				xo<=x_index;
				yo<=y_index;
			end
		end
		else begin
			xo<=0;
			yo<=0;
		end
	end
end

always@(posedge clk or  posedge reset)begin
	if(reset)begin
		po<=0;
	end
	else begin
		if(busy==1)begin
			if(in && recive_cnt == 3)
				po<=1;
			else 
				po<=0;
		end
		else
			po<=0;
	end
end
	

endmodule
