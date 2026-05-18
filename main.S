#include <avr/io.h>

.global main

main:
    sbi   _SFR_IO_ADDR(DDRB), 5

blink_loop:
    sbi   _SFR_IO_ADDR(PORTB), 5
    rcall delay_half_sec
    cbi   _SFR_IO_ADDR(PORTB), 5
    rcall delay_half_sec
    rjmp  blink_loop

delay_half_sec:
    ldi   r18, 41
delay_3:
    ldi   r16, 255
delay_1:
    ldi   r17, 255
delay_2:
    dec   r17
    brne  delay_2
    dec   r16
    brne  delay_1
    dec   r18
    brne  delay_3
    ret