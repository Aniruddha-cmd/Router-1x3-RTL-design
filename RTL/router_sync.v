module router_sync(clk,resetn,data_in,detect_add,full_0,full_1,full_2,
                    empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
                     write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2);

input clk,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2;
input [1:0] data_in;
output reg [2:0] write_enb;
output vld_out_0,vld_out_1,vld_out_2;
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
reg [1:0]temp;
reg [4:0] counter0,counter1,counter2;

always@(posedge clk)
begin
    if(!resetn)
          temp <=0;
    else if(detect_add)
            temp <= data_in;
    else
          temp <= temp;
end

always@(write_enb_reg,temp)
begin
     if(write_enb_reg==1)
         begin
            case(temp)
       2'b00: write_enb =3'b001;
       2'b01: write_enb =3'b010;
       2'b10: write_enb =3'b100;
        default: write_enb=3'b000;
         endcase
         end
    else
         write_enb=3'b000;
end

assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

always@(*)
begin
   case(temp)
   2'b00: fifo_full = full_0;
   2'b01: fifo_full = full_1;
   2'b10: fifo_full = full_2;
   default: fifo_full= 1'b0;
   endcase
end

always@(posedge clk)
begin
      if(!resetn)
         begin
          counter0 <=0;
          soft_reset_0 <=0;
        end
   else if(vld_out_0)
         begin  
             if(!read_enb_0)
                begin
                 if(counter0==5'b11110)
                     soft_reset_0 <= 1'b1;
                 else
		 begin
                   counter0 <= counter0+1;
			soft_reset_0<=0;
				end
                 end
            else
               counter0 <=0;
         end
    else
        counter0 <=0;
end


always@(posedge clk)
begin
      if(!resetn)
         begin
          counter1 <=0;
          soft_reset_1 <=0;
        end
   else if(vld_out_1)
        begin
            if(!read_enb_1)
                begin
                 if(counter1==5'b11110)
                    soft_reset_1<= 1'b1;
                 else
				 begin
                    counter1 <= counter1+1;
                     soft_reset_1<=0;
                            end
		end
           else
              counter1 <=0;
          end
	else
	counter1<=0;
 end
 
   


always@(posedge clk)
begin
      if(!resetn)
         begin
          counter2 <=0;
          soft_reset_2 <=0;
        end
   else if(vld_out_2)
        begin
            if(!read_enb_2)
                begin
                 if(counter2==5'b11110)
                     soft_reset_2 <= 1'b1;
                 else
				 begin
                    counter2 <= counter2+1;
			soft_reset_2<=0;
			end
                 end
	else
	counter2<=0;
	end
end



endmodule
