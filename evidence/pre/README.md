# lab07 실험 전 검증 자료 (STM32_3 · SPI 과제8~12)

## STM32 (NUCLEO-G474RE)
- 소스: `Core/Src/ece2_474_routine.c` (`STM32_3_ROLE` 0 = 마스터·송신, 1 = 슬레이브·수신. 슬레이브 초기화와 송수신 코드는 매뉴얼 그대로)
- `logs/build_debug_role0.txt`, `build_debug_role1.txt`: CMake Debug 빌드 출력, 오류·경고 0 (클라우드 작업 환경의 GNU Arm 13.2.1)
- `fw/`: HAL 함수만 흉내 낸 PC 모의 실행. `sh fw/run.sh`로 재현. 결과 `fw_log_role0.txt`(CS·송신 바이트·MSB 먼저 비트열), `fw_log_role1.txt`(슬레이브 초기화, RX 출력, 타임아웃)

## FPGA (Combo II-DLD, xc7s75fgga484-1)
- `../../fpga/spi_rx/evidence/pre/`, `../../fpga/spi_tx/evidence/pre/`: Icarus Verilog 12.0 PASS 로그, VCD, 오류 주입 로그, 과제12 loopback 로그
- `xdc_check.py`, `xdc_check_log.txt`: 최상위 포트와 XDC 핀 수·중복 점검
- 그림: `fig/` 스크립트
