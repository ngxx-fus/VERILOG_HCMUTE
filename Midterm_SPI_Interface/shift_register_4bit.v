/*
    Thanh ghi dịch 8bit
    Ngõ vào:
        - Xung CLK 
        - CLEAR : đạt toàn bộ ngõ ra trong thanh ghi dịch về 0
        - [4] P_DATA_IN : giá trị để đặt trước (vào song song)
        - S_DATA_IN : vào nối tiếp
        - SH_LD : đặt trước giá trị hoặc dịch
            + SH_LD = 0, ngưng dịch, vào song song (bằng cách động vào chân CLR, PRE của từng FF-D)
            + SH_LD = 1, dịch
    Ngõ ra
        - [4] P_DATA_OUT : kết nối tới từng FF-D bên trong
*/

`include "d_ff.v"

module SHIFT_REGISTER_4BIT (
    input CLK,
    input CLR,
    input [3:0] P_DATA_IN,
    input S_DATA_IN,
    input SH_LD,
    output  [3:0] P_DATA_OUT
);
    //Khai báo dây d?n bên trong
    wire notSH_LD;
    wire notCLR;
    wire [3:0]D_CLR;// tín hi?u cu?i cùng d?n d-ff (tín hi?u clr theo data set-up ho?c bu?c reset)
    wire [3:0]S_CLR;// tín hi?u t? DATA set-up
    wire [3:0]D_DATA;// dây d?n n?i d?n chân D c?a t?ng d-ff
    wire [3:0]D_PRE;
    wire [3:0]S_PRE;
    
    d_ff dff0 (.CLK(CLK), .CLR(D_CLR[0]), .PRE(D_PRE[0]), .DATA(S_DATA_IN),     .Q(P_DATA_OUT[3]) );
    d_ff dff1 (.CLK(CLK), .CLR(D_CLR[1]), .PRE(D_PRE[1]), .DATA(P_DATA_OUT[3]), .Q(P_DATA_OUT[2]) );
    d_ff dff2 (.CLK(CLK), .CLR(D_CLR[2]), .PRE(D_PRE[2]), .DATA(P_DATA_OUT[2]), .Q(P_DATA_OUT[1]) );
    d_ff dff3 (.CLK(CLK), .CLR(D_CLR[3]), .PRE(D_PRE[3]), .DATA(P_DATA_OUT[1]), .Q(P_DATA_OUT[0]) );

    not(notSH_LD, SH_LD);
    // assign notSH_LD=SH_LD;
    not(notCLR, CLR);

    and(S_PRE[0], notSH_LD, D_DATA[3]); nor(S_CLR[0], SH_LD, D_DATA[3]);
    and(S_PRE[1], notSH_LD, D_DATA[2]); nor(S_CLR[1], SH_LD, D_DATA[2]);
    and(S_PRE[2], notSH_LD, D_DATA[1]); nor(S_CLR[2], SH_LD, D_DATA[1]);
    and(S_PRE[3], notSH_LD, D_DATA[0]); nor(S_CLR[3], SH_LD, D_DATA[0]);

    and(D_PRE[0], S_PRE[0], notCLR); or(D_CLR[0], S_CLR[0], CLR);
    and(D_PRE[1], S_PRE[1], notCLR); or(D_CLR[1], S_CLR[1], CLR);
    and(D_PRE[2], S_PRE[2], notCLR); or(D_CLR[2], S_CLR[2], CLR);
    and(D_PRE[3], S_PRE[3], notCLR); or(D_CLR[3], S_CLR[3], CLR);


    assign D_DATA = P_DATA_IN;
    // assign D_DATA = (SH_LD==0)?(P_DATA_IN):(4'bzzzz); // cách ly ngõ vào thi?t l?p c?a t?ng FF-D v?i ngõ vào song song khi không có tín hi?u LD (load)

endmodule

