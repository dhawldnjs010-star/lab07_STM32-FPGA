#ifndef MOCK_ECE2_474_H
#define MOCK_ECE2_474_H
#include <stdio.h>
#include "main.h"
extern TIM_HandleTypeDef htim6, htim3;
extern UART_HandleTypeDef huart2, huart3;
extern SPI_HandleTypeDef hspi1;
void ece2_474_init(void);
void polling_routine(void);
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin);
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim);
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart);
#endif
