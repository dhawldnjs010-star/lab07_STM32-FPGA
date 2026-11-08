# lab07 실험 후 자료 (2026-11-02 실습, STM32_3 · SPI)

영상은 원본을 720p H.264로 줄이고 소리를 뺀 사본이다. 사진은 긴 변 1600px로 줄였다.
LED 값은 LED1을 최상위 비트로 읽었다 (켜짐 = 1).

## STM32 (NUCLEO-G474RE) · `stm32/`
소스는 `Core/Src/ece2_474_routine.c` (`STM32_3_ROLE` 0 = 마스터, 1 = 슬레이브). 저장소 기본값은 0이며, 과제11은 1로 바꿔 빌드했다.

| 파일 | 내용 |
|---|---|
| `task8_scope_55.jpg`, `_A5`, `_00`, `_FF` | 과제8: CH1 SCK 781.3~781.6 kHz, CH2 MOSI. `_A5`, `_FF`는 CH2 측정값이 최대 0.2 V·최소 −3.3 V로 나온 사진 (본문 참고) |
| `task8_serial.jpg` | 과제8: VCP 출력 `TX=55/A5/00/FF, result=0` 반복 |
| `task9_mcu_to_mcu_demo.mp4`, `task9_frames.jpg` | 과제9: 송신 MCU(마스터) `TX=55/A5/00/FF, result=0`, 수신 MCU(ROLE 1, COM8) `RX=55/A5/00/FF` 같은 순서 |
| `task10_mcu_to_fpga_demo.mp4`, `task10_serial.jpg`, `task10_fpga_led_frames.jpg`, `task10_probe_setup.jpg` | 과제10: COM8(MCU) `TX=…`와 COM9(FPGA) `RX=…`가 같은 순서, FPGA LED 55 → A5 → 00 → FF |
| `task11_fpga_to_mcu_demo.mp4`, `task11_serial.jpg`, `task11_wiring.jpg` | 과제11: DIP_SW1 = 1(0x55 고정), COM9(FPGA) `TX=55`, COM8(MCU) `RX=55` |

과제9·12는 두 보드 모두 우리 조 장비로 진행해 역할 교대를 조교 승인 후 생략했다.
과제11은 실험 때 네 값 순환도 확인했으나 영상은 0x55 고정 상태만 찍었다.

## FPGA (Combo II-DLD, Vivado 2026.1) · `fpga/`
- `vivado_tcl_console_lab07.txt`: spi_rx·spi_tx 프로그래밍 기록 (11/02)
- `../../fpga/spi_rx/evidence/post/`: XSim 파형, 구현 결과, 과제12 영상·LED 프레임
- `../../fpga/spi_tx/evidence/post/`: XSim 파형, 구현 결과, 과제11 오실로스코프 사진 4장
- 각 프로젝트 `reports/post.md`에 실측 요약
