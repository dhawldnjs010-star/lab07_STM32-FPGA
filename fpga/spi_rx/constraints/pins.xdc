# STM32_3 과제10·12 수신 측 (최상위: spi_rx_top). SPI Mode 0, UART 9600 8N1
# 핀 출처: Xilinx S7 Pin Map의 BreadBoard I/O 표 (BDIO00 F8, BDIO01 E8, BDIO02 A7), 조교 LAB3 lab3_uart_echo.xdc (B6, K4, F6)
# lab06에서 확장 커넥터 EX1·EX2는 신호등 모듈이 쓰고 있어, 브레드보드 영역 PORT A를 쓴다. 보드의 PORT A ENABLE 스위치를 켠다.
# 연결 (과제10, MCU 마스터): MCU PB3(SCK, Arduino D3) -> I/O 00, PA7(MOSI, D11) -> I/O 01, PB6(CS, D10) -> I/O 02, GND 공통
# 연결 (과제12, FPGA 마스터): 송신 FPGA의 I/O 00·01·02 -> 이 보드의 I/O 00·01·02, GND 공통
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property PACKAGE_PIN K4 [get_ports rst_p]      ;# SW_1
set_property PACKAGE_PIN F8 [get_ports spi_sck]    ;# PORT A I/O 00
set_property PACKAGE_PIN E8 [get_ports spi_mosi]   ;# PORT A I/O 01
set_property PACKAGE_PIN A7 [get_ports spi_cs_n]   ;# PORT A I/O 02
set_property PACKAGE_PIN F6 [get_ports uart_txd]   ;# USB-UART -> PC
set_property PACKAGE_PIN L4  [get_ports {led_out[7]}]   ;# LED_D1
set_property PACKAGE_PIN M4  [get_ports {led_out[6]}]   ;# LED_D2
set_property PACKAGE_PIN M2  [get_ports {led_out[5]}]   ;# LED_D3
set_property PACKAGE_PIN N7  [get_ports {led_out[4]}]   ;# LED_D4
set_property PACKAGE_PIN M7  [get_ports {led_out[3]}]   ;# LED_D5
set_property PACKAGE_PIN M3  [get_ports {led_out[2]}]   ;# LED_D6
set_property PACKAGE_PIN M1  [get_ports {led_out[1]}]   ;# LED_D7
set_property PACKAGE_PIN N5  [get_ports {led_out[0]}]   ;# LED_D8
set_property IOSTANDARD LVCMOS33 [get_ports *]
set_property PULLUP true [get_ports spi_cs_n]      ;# 선이 빠지면 선택 해제(HIGH)
set_property PULLDOWN true [get_ports spi_sck]     ;# 선이 빠지면 SCK LOW 대기
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]
set_false_path -from [get_ports {rst_p spi_sck spi_mosi spi_cs_n}]
