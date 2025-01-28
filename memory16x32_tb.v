module memory16x32_tb #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter MEMO_DEPTH = (1 << ADDR_WIDTH)
);

parameter clk_period = 10;

reg [DATA_WIDTH-1:0] Data_in_tb;
reg [ADDR_WIDTH-1:0] Address_tb;
reg EN_tb, CLK_tb, RST_tb;
reg [DATA_WIDTH-1:0] memory [0:MEMO_DEPTH-1];

wire [DATA_WIDTH-1:0] Data_out_tb;
wire Valid_out_tb;

integer error_count, correct_count, i;



////////////////////////////////////////////////////////////
//////////////////// Test Cases & Sim //////////////////////
////////////////////////////////////////////////////////////

initial begin

    initialize();
    checkreset(Data_out_tb,Valid_out_tb);

    //todo

end

////////////////////////////////////////////////////////////
//////////////////// Tasks & Functions /////////////////////
////////////////////////////////////////////////////////////

task initialize;
    begin
        Data_in_tb = 'b0;
        Address_tb = 'b0;
        EN_tb = 'b0;
        RST_tb = 'b0;
        correct_count = 0;
        error_count = 0;
    end
endtask


task reset;
    begin
        RST_tb = 'b1;
        #clk_period
        RST_tb = 'b0;
    end
endtask

task checkreset;
    input [DATA_WIDTH-1:0] Data_out;
    input Valid_out;

    begin
        reset();
        if(Data_out || Valid_out != 0) begin
            $display("Error in Reset Function");
            error_count = error_count + 1;
        end else begin
            correct_count = correct_count + 1;
        end
    end
endtask

task checkvalid;
    input [DATA_WIDTH-1:0] Data_in;
    input [ADDR_WIDTH-1:0]Address;
    input EN;
    input [DATA_WIDTH-1:0] Data_out;
    input Valid_out;

    begin
        //todo
    end
endtask

task goldenmodel;
    input [DATA_WIDTH-1:0] Data_in_g;
    input [ADDR_WIDTH-1:0] Address_g;
    input EN_g;
    input RST_g;
    output [DATA_WIDTH-1:0] Data_out_g;
    output Valid_out_g;

    input reg [DATA_WIDTH-1:0] memory_current_g [0:MEMO_DEPTH-1];
    output reg [DATA_WIDTH-1:0] memory_out_g [0:MEMO_DEPTH-1];

    begin
        if(RST_g) begin
            Data_out_g  = 'b0;
            Valid_out_g = 'b0;
            for (i = 0; i < MEMO_DEPTH; i = i + 1) begin
                memory_out_g[i] = 'b0;
            end
        end else begin
            for (i = 0; i < MEMO_DEPTH; i = i + 1) begin
                memory_out_g[i] = memory_current_g[i];
            end
            @(posedge CLK_tb)
            //Write Operation
            if(EN_g) begin
                memory_out_g[Address_g] = Data_in_g;
                Valid_out_g = 'b0;
            end 
            //Read Operation
            else begin
                Data_out_g = memory_out_g[Address_g];
                Valid_out_g = 'b1;
            end
        end
    end
endtask

////////////////////////////////////////////////////////////
//////////////////// CLK Generation ////////////////////////
////////////////////////////////////////////////////////////

initial begin
    CLK_tb = 0;
    forever #(0.5*clk_period) CLK_tb = ~CLK_tb;
end

////////////////////////////////////////////////////////////
/////////////////// DUT Instantiation //////////////////////
////////////////////////////////////////////////////////////

memory16x32 DUT(
.Data_in(Data_in_tb),
.Address(Address_tb),
.EN(EN_tb),
.CLK(CLK_tb),
.RST(RST_tb),
.Data_out(Data_out_tb),
.Valid_out(Valid_out_tb)
);

endmodule