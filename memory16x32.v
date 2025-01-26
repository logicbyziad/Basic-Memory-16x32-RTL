module memory16x32 #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter MEMO_DEPTH = (1 << ADDR_WIDTH)
)(
    input   [DATA_WIDTH-1:0] Data_in,
    input   [ADDR_WIDTH-1:0] Address,
    input   EN, CLK, RST,
    output  reg [DATA_WIDTH-1:0] Data_out,
    output  reg Valid_out
);

reg [DATA_WIDTH-1:0] memory [0:MEMO_DEPTH-1];
integer i;

always @(posedge CLK or posedge RST)
begin

    if(RST) begin
        Data_out  <= 'b0;
        Valid_out <= 1'b0;

        for (i = 0; i < MEMO_DEPTH; i = i + 1) begin
            memory[i] <= 'b0;
        end

    end else begin
        //Enable high = write
        if(EN) begin
            memory[Address] <= Data_in;
            Valid_out <= 1'b0;
        end
        
        //Enable low = read
        else begin
            Data_out <= memory[Address];
            Valid_out <= 1'b1;
        end
    end

end

endmodule