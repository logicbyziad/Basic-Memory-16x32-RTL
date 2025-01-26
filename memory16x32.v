module memort16x32 #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter MEMO_DEPTH = (1 << ADDR_WIDTH)
)(
    input   [DATA_WIDTH-1:0] Data_in;
    input   [ADDR_WIDTH-1:0] Address;
    input   EN, CLK, RST;
    output  reg [DATA_WIDTH-1:0] Data_out;
    output  reg Valid_out;
);

reg [DATA_WIDTH-1:0] memory [0:MEMO_DEPTH-1];

always@(posedge CLK or posedge RST)
begin

    if(rst) begin
        Data_out  <= 'b0;
        Valid_out <= 'b0;
    end else begin
        //Enable high = write
        if(EN) begin
            memory[Address] <= Data_in;
            Valid_out <= 'b0;
        end
        
        //Enable low = read
        else begin
            Data_out <= memory[Address];
            Valid_out <= 'b1;
        end
    end

end

endmodule