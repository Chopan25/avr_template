#include <avr/io.h>
#include <util/delay.h>

int main(void) {
    // Set PB5 (Arduino Uno Pin 13) as an output
    DDRB |= (1 << PB5);

    while (1) {
        // Toggle the LED state using an XOR operation
        PORTB ^= (1 << PB5);

        // Use the built-in hardware-accurate delay
        _delay_ms(500);
    }

    return 0;
}