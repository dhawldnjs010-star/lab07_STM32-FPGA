/* STM32_3 SPI 모의 실행: 실제 ece2_474_routine.c를 PC용 gcc로 컴파일한다.
 * 마스터(ROLE 0): 1 ms 가상 시간으로 5초를 돌리며 CS 변화와 HAL_SPI_Transmit 바이트를 기록하고,
 *   Mode 0(SCK LOW 대기, 상승 에지에서 읽음, MSB 먼저)으로 보낼 때 MOSI 비트열을 [BITS]로 출력한다.
 * 슬레이브(ROLE 1): HAL_SPI_Receive가 0x55, 0xA5, 0x00, 0xFF를 차례로 받고 다음은 타임아웃을 돌려준다. */
#include <stdio.h>
#include "main.h"
#include "ece2_474.h"
GPIO_TypeDef GPIOA_obj, GPIOB_obj; TIM_TypeDef TIM6_obj; USART_TypeDef USART2_obj, USART3_obj;
TIM_HandleTypeDef htim6 = {&TIM6_obj}, htim3 = {0};
UART_HandleTypeDef huart2 = {&USART2_obj}, huart3 = {&USART3_obj};
SPI_HandleTypeDef hspi1 = {{SPI_MODE_MASTER, 0x200U}};
static uint32_t now_ms; static int cs = 1;
uint32_t HAL_GetTick(void) { return now_ms; }
void HAL_GPIO_WritePin(GPIO_TypeDef *p, uint16_t pin, GPIO_PinState s) {
    if (p == SPI_CS_ece2_GPIO_Port && pin == SPI_CS_ece2_Pin) { cs = s; printf("[CS] t=%u %s\n", now_ms, s ? "HIGH" : "LOW"); } }
void HAL_GPIO_Init(GPIO_TypeDef *p, GPIO_InitTypeDef *g) {
    printf("[GPIO] %s pin=0x%04X mode=AF_PP pull=%u af=%u\n", p == GPIOA ? "GPIOA" : "GPIOB", (unsigned)g->Pin, (unsigned)g->Pull, (unsigned)g->Alternate); }
HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *h, uint8_t *d, uint16_t n, uint32_t t) {
    (void)h; (void)t;
    for (uint16_t i = 0; i < n; i++) {
        printf("[SPI TX] t=%u cs=%d byte=0x%02X bits(MSB first)=", now_ms, cs, d[i]);
        for (int b = 7; b >= 0; b--) printf("%d", (d[i] >> b) & 1);
        printf("\n"); }
    return HAL_OK; }
static const uint8_t rx_feed[] = {0x55, 0xA5, 0x00, 0xFF}; static unsigned rx_k;
HAL_StatusTypeDef HAL_SPI_Receive(SPI_HandleTypeDef *h, uint8_t *d, uint16_t n, uint32_t t) {
    (void)h; (void)n;
    if (rx_k < sizeof rx_feed) { d[0] = rx_feed[rx_k++]; return HAL_OK; }
    now_ms += t; return HAL_TIMEOUT; }
HAL_StatusTypeDef HAL_SPI_DeInit(SPI_HandleTypeDef *h) { printf("[SPI] DeInit mode=%s\n", h->Init.Mode ? "MASTER" : "SLAVE"); return HAL_OK; }
HAL_StatusTypeDef HAL_SPI_Init(SPI_HandleTypeDef *h) { printf("[SPI] Init mode=%s nss=%s\n", h->Init.Mode ? "MASTER" : "SLAVE", h->Init.NSS ? "SOFT" : "HARD_INPUT"); return HAL_OK; }
void Error_Handler(void) { printf("Error_Handler\n"); }
int main(void) {
    ece2_474_init();
#if defined(ROLE_SLAVE)
    for (int k = 0; k < 5; k++) polling_routine();
#else
    for (now_ms = 1; now_ms <= 5000; now_ms++) polling_routine();
#endif
    return 0;
}
