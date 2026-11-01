`timescale 1ns/1ps
// SPI 마스터 송신 (Mode 0, 8비트, MSB 먼저). 학생 작성.
// start가 들어오면 CS_n을 LOW로 내리고 MOSI에 최상위 비트를 준비한 뒤, SCK를 HALF클록마다 반전한다.
// 수신 측은 SCK 상승 에지에서 읽고, 이 회로는 하강 에지에서 다음 비트로 바꾼다. 8번째 하강 뒤 CS_n HIGH.
// SCK = CLK_HZ / (2 × HALF). 기본 HALF = 50 → 50 MHz에서 500 kHz (매뉴얼 조건 1 MHz 이하).
module spi_master_tx #(parameter integer HALF = 50)(
    input  wire clk, rst_p,
    input  wire start,
    input  wire [7:0] data,
    output reg  sck, mosi, cs_n,
    output wire busy,
    output reg  done             // 한 바이트를 보내고 CS_n을 올린 클록에 1클록 HIGH
);
    localparam IDLE = 2'd0, SETUP = 2'd1, SHIFT = 2'd2, HOLD = 2'd3;
    reg [1:0] state;
    reg [31:0] cnt;
    reg [2:0] bitn;
    reg [7:0] sh;
    assign busy = (state != IDLE);
    always @(posedge clk) begin
        if (rst_p) begin
            state <= IDLE; cnt <= 0; bitn <= 0; sh <= 0;
            sck <= 0; mosi <= 0; cs_n <= 1; done <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: if (start) begin
                    sh <= data; mosi <= data[7]; cs_n <= 0; sck <= 0;   // 첫 상승 에지 전에 MSB 준비
                    cnt <= 0; bitn <= 0; state <= SETUP;
                end
                SETUP: if (cnt == HALF-1) begin cnt <= 0; sck <= 1; state <= SHIFT; end   // 첫 상승 에지
                       else cnt <= cnt + 1;
                SHIFT: if (cnt == HALF-1) begin
                    cnt <= 0;
                    if (sck) begin                                   // 하강 에지
                        sck <= 0;
                        if (bitn == 3'd7) state <= HOLD;             // 8비트 끝
                        else begin bitn <= bitn + 1'b1; sh <= {sh[6:0], 1'b0}; mosi <= sh[6]; end
                    end else sck <= 1;                               // 상승 에지 (수신 측이 읽음)
                end else cnt <= cnt + 1;
                HOLD: if (cnt == HALF-1) begin cnt <= 0; cs_n <= 1; mosi <= 0; done <= 1; state <= IDLE; end
                      else cnt <= cnt + 1;
            endcase
        end
    end
endmodule
