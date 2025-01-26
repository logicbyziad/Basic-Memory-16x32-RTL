module memort16x32;

input [31:0] Data_in;
input [3:0] Address;
input EN, CLK, RST;
output reg [31:0] Data_out;
output reg [3:0] Valid_out;

always@(posedge clk or posedge rst)
begin

    if(rst) begin
        Data_out  <= 'b0;
        Valid_out <= 'b0;
    end else begin

    
    end

end



endmodule