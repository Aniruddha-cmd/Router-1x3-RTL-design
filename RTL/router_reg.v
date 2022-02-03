module router_reg(clk,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,laf_state,
                     full_state,lfd_state,rst_int_reg,err,parity_done,low_pkt_valid,dout);
input clk,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;
input [7:0] data_in;
output reg [7:0]dout;
output reg err,parity_done,low_pkt_valid;
reg [7:0] header_byte,fifo_fullstate_byte,internal_parity,packet_parity_byte;

always@(posedge clk)
begin
 if(!resetn)
     header_byte <= 8'b0;
else if (detect_add && pkt_valid)
         header_byte <=data_in;
     
   else
        header_byte <=header_byte;
end

always@(posedge clk)
begin
   if(!resetn)
       fifo_fullstate_byte <= 8'b0;
 else if(fifo_full && ld_state)
        fifo_fullstate_byte <= data_in;
 else
      fifo_fullstate_byte <= fifo_fullstate_byte;
end

 always@(posedge clk)
begin
    if(!resetn)
        internal_parity <= 8'b0;
   else if(lfd_state)
          internal_parity <= internal_parity^header_byte;
   else if (ld_state && pkt_valid && !full_state)
            internal_parity <=internal_parity^data_in;
     
   else
       internal_parity <=internal_parity;
end

always@(posedge clk)
begin
     if(!resetn)
         packet_parity_byte <=8'b0;
    else if(!pkt_valid && ld_state)       
            packet_parity_byte <=data_in;
     else
           packet_parity_byte<= packet_parity_byte;
end

always@(posedge clk)
begin
   if(!resetn)
      dout <=8'b0;
   else if(lfd_state)
        dout <= header_byte;
    else if(ld_state)
         dout <= data_in;
   else 
       if (laf_state)
             dout <= fifo_fullstate_byte;
   else
            dout <=dout;
       
end

always@(posedge clk)
begin
    if(!resetn)
        low_pkt_valid<=0;
   else
      begin
        if(rst_int_reg)
           low_pkt_valid <=1'b0;
        if(ld_state && !pkt_valid)
            low_pkt_valid <=1'b1;
       end
end

always@(posedge clk)
begin
     if(!resetn)
         parity_done <=0;
   else if(detect_add)
            parity_done <=0;
     else if(ld_state && !fifo_full && !pkt_valid)
           parity_done <=1'b1;
       else 
         begin
               if(laf_state && low_pkt_valid && !parity_done)
                 parity_done <= 1'b1;
      
         end
end

always@(posedge clk)
begin 
   if(!resetn)
       err<=0;
   else
        begin
          if(parity_done)
             begin
              if(internal_parity != packet_parity_byte)
                 err<=1'b1;
              else
                 err<= 1'b0;
              end
          else
                err<=0;
      end
end

endmodule
          
    
        
    
        
