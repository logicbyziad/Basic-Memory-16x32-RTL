module memory16x32_tb #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter MEMO_DEPTH = (1 << ADDR_WIDTH)
);

localparam clk_period = 10;

reg [DATA_WIDTH-1:0] Data_in_tb;
reg [ADDR_WIDTH-1:0] Address_tb;
reg EN_tb, CLK_tb, RST_tb;
wire [DATA_WIDTH-1:0] Data_out_tb;
wire Valid_out_tb;

integer error_count, correct_count, i, test_ID;



////////////////////////////////////////////////////////////
//////////////////// Test Cases & Sim //////////////////////
////////////////////////////////////////////////////////////

initial begin

    initialize();
    checkreset(Data_out_tb,Valid_out_tb);

    //todo

    //Address Exhaustive Testing
    repeat(10) begin    
        for (i = 0; i < ADDR_WIDTH; i = i + 1) begin
            @(posedge CLK_tb)
            EN_tb = 1'b1;
            Address_tb = i;
            checkvalid(Data_in_tb,Address_tb,EN_tb,RST_tb,Data_out_tb,Valid_out_tb);  
            test_ID = test_ID + 1;

            @(posedge CLK_tb)
            EN_tb = 1'b0;
            checkvalid(Data_in_tb,Address_tb,EN_tb,RST_tb,Data_out_tb,Valid_out_tb);
            Data_in_tb = Data_in_tb + 1;  
            test_ID = test_ID + 1;
        end
    end

    $display("Error Count = %0d", error_count);
    $display("Correct Count = %0d", correct_count);

    $stop;
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
        test_ID = 0;
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
            $display("Error in Reset function");
            error_count = error_count + 1;
        end else begin
            correct_count = correct_count + 1;
        end
    end
endtask

task checkvalid;
    input [DATA_WIDTH-1:0] Data_in;
    input [ADDR_WIDTH-1:0]Address;
    input EN,RST;
    input reg [DATA_WIDTH-1:0] Data_out;
    input reg Valid_out;

    reg [DATA_WIDTH-1:0] Data_out_g;
    reg Valid_out_g;

    begin
        @(negedge CLK_tb)
        goldenmodel(Data_in, Address, EN, RST, Data_out_g, Valid_out_g);
        if(Data_out_g != Data_out) begin
            $display("###########################");
            $display("Error in Data test case: %0d", test_ID);
            $display("Golden: %0b , Actual: %0b", Data_out_g, Data_out);
            error_count = error_count + 1;
        end else begin
            correct_count = correct_count + 1;
        end

        if(Valid_out_g != Valid_out) begin
            $display("###########################");
            $display("Error in Valid test case: %0d", test_ID);
            $display("Golden: %0d , Actual: %0d", Valid_out_g, Valid_out);
            error_count = error_count + 1;
        end else begin
            correct_count = correct_count + 1;
        end

    end
endtask

task goldenmodel;
    input [DATA_WIDTH-1:0] Data_in_g;
    input [ADDR_WIDTH-1:0] Address_g;
    input EN_g, RST_g;
    output reg [DATA_WIDTH-1:0] Data_out_g;
    output Valid_out_g;

    reg [DATA_WIDTH-1:0] memory_out_g [0:MEMO_DEPTH-1]; 

    begin
        if(RST_g) begin
            Data_out_g  = 'b0;
            Valid_out_g = 'b0;
            for (i = 0; i < MEMO_DEPTH; i = i + 1) begin
                memory_out_g[i] = 'b0;
            end
        end else begin
            @(posedge CLK_tb)
            //Write Operation
            if(EN_g) begin
                memory_out_g[Address_g] = Data_in_g;
                Valid_out_g = 'b0;
            end else begin
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