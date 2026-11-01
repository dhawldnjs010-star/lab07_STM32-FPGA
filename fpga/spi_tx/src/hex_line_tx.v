`timescale 1ns/1ps
// 바이트 하나를 "<P0><P1><P2>HH\r\n" 형식의 글자 7개로 UART에 보낸다 (예: "RX=55\r\n"). 학생 작성.
// 보내는 중에 새 값이 오면 무시한다 (1초 간격 전송에서는 생기지 않음).
module hex_line_tx #(parameter [23:0] PREFIX = "RX=")(
    input  wire clk, rst_p,
    input  wire start,
    input  wire [7:0] value,
    input  wire tx_ready,
    output reg  tx_valid,
    output reg  [7:0] tx_data
);
    function [7:0] hex(input [3:0] n); hex = (n < 10) ? ("0" + n) : ("A" + n - 10); endfunction
    reg [7:0] v;
    reg [2:0] idx;
    reg busy, wait_ready;
    always @(posedge clk) begin
        if (rst_p) begin v <= 0; idx <= 0; busy <= 0; wait_ready <= 0; tx_valid <= 0; tx_data <= 0; end
        else begin
            tx_valid <= 0;
            if (!busy) begin
                if (start) begin v <= value; idx <= 0; busy <= 1; end
            end else if (wait_ready) begin
                if (!tx_valid && tx_ready) wait_ready <= 0;      // 이전 글자 송신 시작 후 ready 복귀 대기
            end else if (tx_ready) begin
                case (idx)
                    3'd0: tx_data <= PREFIX[23:16];
                    3'd1: tx_data <= PREFIX[15:8];
                    3'd2: tx_data <= PREFIX[7:0];
                    3'd3: tx_data <= hex(v[7:4]);
                    3'd4: tx_data <= hex(v[3:0]);
                    3'd5: tx_data <= 8'h0D;
                    default: tx_data <= 8'h0A;
                endcase
                tx_valid <= 1; wait_ready <= 1;
                if (idx == 3'd6) busy <= 0; else idx <= idx + 1'b1;
            end
        end
    end
endmodule
