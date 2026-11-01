`timescale 1ns/1ps
// SPI 슬레이브 수신 (Mode 0, 8비트, MSB 먼저). 학생 작성.
// 외부 SCK·MOSI·CS_n을 시스템 클록으로 2단 동기화한 뒤 SCK 상승 에지를 검출해 MOSI를 읽는다.
// CS_n이 HIGH가 되면 비트 카운터를 0으로 돌려, 중간에 끊긴 바이트는 버리고 다음 바이트를 처음부터 받는다.
module spi_slave_rx(
    input  wire clk, rst_p,
    input  wire sck, mosi, cs_n,
    output reg  [7:0] data,
    output reg  valid            // 8비트를 다 받은 클록에 1클록 HIGH
);
    (* ASYNC_REG="TRUE" *) reg [1:0] sck_s, mosi_s, cs_s;
    reg sck_d;
    reg [2:0] bitcnt;
    reg [6:0] shift;
    wire sck_rise = sck_s[1] & ~sck_d;
    always @(posedge clk) begin
        if (rst_p) begin
            sck_s <= 0; mosi_s <= 0; cs_s <= 2'b11; sck_d <= 0;
            bitcnt <= 0; shift <= 0; data <= 0; valid <= 0;
        end else begin
            sck_s <= {sck_s[0], sck}; mosi_s <= {mosi_s[0], mosi}; cs_s <= {cs_s[0], cs_n};
            sck_d <= sck_s[1];
            valid <= 0;
            if (cs_s[1]) bitcnt <= 0;                 // 선택 해제: 다음 바이트를 처음부터
            else if (sck_rise) begin                  // 상승 에지에서 MOSI 읽기
                if (bitcnt == 3'd7) begin
                    data <= {shift, mosi_s[1]};       // 8번째 비트까지 모아 완성
                    valid <= 1;
                    bitcnt <= 0;
                end else begin
                    shift <= {shift[5:0], mosi_s[1]};
                    bitcnt <= bitcnt + 1'b1;
                end
            end
        end
    end
endmodule
