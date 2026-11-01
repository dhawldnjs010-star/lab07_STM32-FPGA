/* PC 모의 실행용 main.h: ece2_474_routine.c가 쓰는 HAL 이름만 흉내 낸다. */
#ifndef MOCK_MAIN_H
#define MOCK_MAIN_H
#include <stdint.h>
typedef enum { HAL_OK = 0, HAL_ERROR = 1, HAL_BUSY = 2, HAL_TIMEOUT = 3 } HAL_StatusTypeDef;
typedef enum { GPIO_PIN_RESET = 0, GPIO_PIN_SET = 1 } GPIO_PinState;
typedef struct { int id; } GPIO_TypeDef;
typedef struct { int id; } TIM_TypeDef;
typedef struct { int id; } USART_TypeDef;
typedef struct { TIM_TypeDef *Instance; } TIM_HandleTypeDef;
typedef struct { USART_TypeDef *Instance; } UART_HandleTypeDef;
typedef struct { uint32_t Mode, NSS; } SPI_InitTypeDef;
typedef struct { SPI_InitTypeDef Init; } SPI_HandleTypeDef;
typedef struct { uint32_t Pin, Mode, Pull, Speed, Alternate; } GPIO_InitTypeDef;
extern GPIO_TypeDef GPIOA_obj, GPIOB_obj;
extern TIM_TypeDef TIM6_obj;
extern USART_TypeDef USART2_obj, USART3_obj;
#define GPIOA (&GPIOA_obj)
#define GPIOB (&GPIOB_obj)
#define TIM6 (&TIM6_obj)
#define USART2 (&USART2_obj)
#define USART3 (&USART3_obj)
#define GPIO_PIN_4 0x0010U
#define SPI_CS_ece2_Pin 0x0040U
#define SPI_CS_ece2_GPIO_Port GPIOB
#define BUTTON_ece2_Pin 0x2000U
#define GPIO_IN_PULLUP_ece2_Pin 0x0001U
#define GPIO_IN_PULLDOWN_ece2_Pin 0x0002U
#define SPI_MODE_SLAVE 0U
#define SPI_MODE_MASTER 0x104U
#define SPI_NSS_HARD_INPUT 0U
#define GPIO_MODE_AF_PP 2U
#define GPIO_PULLUP 1U
#define GPIO_SPEED_FREQ_LOW 0U
#define GPIO_AF5_SPI1 5U
uint32_t HAL_GetTick(void);
void HAL_GPIO_WritePin(GPIO_TypeDef *p, uint16_t pin, GPIO_PinState s);
void HAL_GPIO_Init(GPIO_TypeDef *p, GPIO_InitTypeDef *g);
HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *h, uint8_t *d, uint16_t n, uint32_t t);
HAL_StatusTypeDef HAL_SPI_Receive(SPI_HandleTypeDef *h, uint8_t *d, uint16_t n, uint32_t t);
HAL_StatusTypeDef HAL_SPI_DeInit(SPI_HandleTypeDef *h);
HAL_StatusTypeDef HAL_SPI_Init(SPI_HandleTypeDef *h);
void Error_Handler(void);
#endif
