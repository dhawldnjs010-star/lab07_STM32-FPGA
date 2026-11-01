#!/bin/sh
# 모의 실행 재현: STM32_3_ROLE을 0(마스터), 1(슬레이브)로 바꿔 PC용 gcc로 컴파일하고 실행한다.
set -e
cd "$(dirname "$0")"
for r in 0 1; do
  sed "s/^#define STM32_3_ROLE      0/#define STM32_3_ROLE      $r/" ../../../Core/Src/ece2_474_routine.c > routine_r$r.c
  def=""; [ $r = 1 ] && def="-DROLE_SLAVE"
  gcc -std=c11 -Wall -Wextra $def -Imock -o harness_r$r harness.c routine_r$r.c
  ./harness_r$r > fw_log_role$r.txt
  rm -f routine_r$r.c harness_r$r
done
