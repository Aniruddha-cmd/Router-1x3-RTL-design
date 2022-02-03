module router_fifo(clk,resetn,soft_reset,w_en,r_en,lfd_state,data_in,full,empty,data_out);

input clk,resetn,soft_reset,w_en,r_en,lfd_state;
output  full,empty;
input[7:0] data_in;
output reg [7:0] data_out;
reg [8:0] fifo[15:0];
reg[4:0] w_ptr,r_ptr;
reg [5:0] counter;
integer i;

//write operation
always@(posedge clk)
begin
    if(!resetn)
        begin
      for(i=0;i<16;i=i+1)
        fifo[i] <=0;
         end
   else if(soft_reset)
         begin
       for(i=0;i<16;i=i+1)
        fifo[i] <=0;
         end
   else
         if(w_en && !full)
          {fifo[w_ptr[3:0]][8],fifo[w_ptr][7:0]} <={lfd_state,data_in};   
           
 end

//read operation
always@(posedge clk)
begin
     if(!resetn)
       data_out <=0;
 else if(soft_reset)
        data_out <=8'dz;
  else if(r_en && !empty)
         data_out <= fifo[r_ptr[3:0]];
   else if(counter==0 && data_out !=0)
           data_out <=8'dz;
       
end

//pointer increment
always@(posedge clk)
begin
    if(!resetn || soft_reset)
          begin
          w_ptr <=0;
          r_ptr <=0;
        end
    else
        begin
         if(w_en && !full)
           w_ptr <= w_ptr+1;
         if(r_en && !empty)
            r_ptr <=r_ptr+1;
        end
end


//counter logic
always@(posedge clk)
begin
   if(!resetn) 
      counter <=0;
     else if(soft_reset)
      counter <=0;
else if(fifo[r_ptr][8] && r_en && !empty)
      counter <= fifo[r_ptr[3:0]][7:2]+1;
else if(counter !=0 && r_en && !empty)
        counter <=counter-1;
 end




 //assign full=((w_ptr==15) && (r_ptr==0))? 1'b1:1'b0;
assign full=((r_ptr[4] != w_ptr[4])&&(w_ptr[3:0]==r_ptr[3:0]))?1'b1:1'b0;
assign empty=(r_ptr==w_ptr);
  
endmodule
    

     



