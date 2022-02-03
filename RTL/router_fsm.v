module router_fsm(clk,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,write_enb_reg,detect_add,ld_state,
                   laf_state,lfd_state,full_state,rst_int_reg,busy);

input clk,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid;
input [1:0] data_in;
output  write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

parameter decode_address= 3'b000,
          load_first_data=3'b001,
          load_data=3'b010,
          load_parity=3'b011,
          fifo_full_state=3'b100,
          load_after_full=3'b101,
          wait_till_empty=3'b110,
          check_parity_error=3'b111;

reg [2:0] present_state,next_state;

always@(posedge clk)
begin
  if(!resetn)
     present_state <= decode_address;
   else if((soft_reset_0 && (data_in==2'b00))||(soft_reset_1 && (data_in==2'b01))||(soft_reset_2 && (data_in==2'b10)))
          present_state <= decode_address;
  else
    present_state <= next_state;
end

always@(*)
begin
     next_state =decode_address;
     case(present_state)
   decode_address: begin
                   if((pkt_valid && (data_in[1:0]==2'b00) && fifo_empty_0) ||(pkt_valid && (data_in[1:0]==2'b01) && fifo_empty_1)||(pkt_valid && (data_in[1:0]==2'b10) && fifo_empty_2))
                      next_state = load_first_data;
         else if((pkt_valid && (data_in[1:0]==2'b00) && ~fifo_empty_0) ||(pkt_valid && (data_in[1:0]==2'b01) && ~fifo_empty_1)||(pkt_valid && (data_in[1:0]==2'b10) && ~fifo_empty_2))
                      next_state = wait_till_empty;
                  else
                       next_state = decode_address;
                  end

  
   load_first_data: begin next_state = load_data; end

    load_data: begin
               if(fifo_full==1)
                    next_state = fifo_full_state;
             else if(!fifo_full && !pkt_valid)
                   next_state = load_parity;
              else
                   next_state = load_data;
               end

    load_parity: begin 
                next_state= check_parity_error; 
                    end

    check_parity_error: begin
                        if(fifo_full==0)
                         next_state = decode_address;
                   else 
                        next_state = fifo_full_state;
                     end
  
   fifo_full_state: if(fifo_full==0)
                      next_state =load_after_full;
                    else
                       next_state = fifo_full_state;

  load_after_full: begin
                    if((!parity_done) && (!low_pkt_valid))
                     next_state = load_data;
               else if(!parity_done && low_pkt_valid)
                      next_state = load_parity;
               else
                     begin
                          if(parity_done==1)
                                 next_state = decode_address;
                         else
                               next_state = load_after_full;
                      end
                 end
       endcase
end

assign detect_add= (present_state == decode_address);
assign lfd_state= (present_state == load_first_data);
assign busy=((present_state==load_first_data)||(present_state==load_parity)||
               (present_state==fifo_full_state)||(present_state==load_after_full)||
                (present_state==wait_till_empty)||(present_state==check_parity_error));
assign ld_state=(present_state==load_data);
assign write_enb_reg=((present_state==load_data)||(present_state==load_parity)||(present_state==load_after_full));
assign full_state=(present_state==fifo_full_state);
assign laf_state=(present_state==load_after_full);
assign rst_int_reg=(present_state==check_parity_error);


endmodule

                        


   
