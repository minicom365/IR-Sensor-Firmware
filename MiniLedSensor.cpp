/*
 * MiniLedSensor.cpp - ATtiny13/85 호환 버전
 *
 * Created: 03/05/2015 11:06:12
 *  Author: David Crocker, Escher Technologies Ltd.
 * Licensed under the GNU General Public License version 3.
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <avr/wdt.h>
#include <avr/sleep.h>

// MCU 타입 감지 및 디버그 정보
#if defined(__AVR_ATtiny13__) || defined(__AVR_ATtiny13A__)
    #define MCU_TYPE "ATtiny13"
    #define IS_ATTINY13 1
#elif defined(__AVR_ATtiny85__)
    #define MCU_TYPE "ATtiny85" 
    #define IS_ATTINY13 0
#else
    #define MCU_TYPE "Unknown"
    #define IS_ATTINY13 0
    #warning "Unknown MCU type - using default fuse settings"
#endif

// 조건부 퓨즈 설정
#if IS_ATTINY13
    // ATtiny13 전용 퓨즈: BOD 4.3V, SPIEN 활성화로 ATtiny85와 동일한 기능
    __fuse_t __fuse __attribute__((section (".fuse"))) = {
        0xE0u,  // Low Fuse: BOD 4.3V (BODLEVEL[1:0] = 00)
        0xF7u,  // High Fuse: SPIEN=0, RSTDISBL=1, 기타 동일
        0xFFu   // Extended Fuse: 기본값
    };
    
    // 컴파일 타임 메시지
    #pragma message "Compiling for ATtiny13 with custom fuse settings"
    #pragma message "Low Fuse: 0xE0 (BOD 4.3V)"
    #pragma message "High Fuse: 0xF7 (SPIEN enabled)"
    
#elif defined(__AVR_ATtiny85__)
    // ATtiny85 원본 퓨즈 설정
    __fuse_t __fuse __attribute__((section (".fuse"))) = {
        0xE2u,  // Low Fuse: 원본 설정
        0xDFu,  // High Fuse: 원본 설정  
        0xFFu   // Extended Fuse: 원본 설정
    };
    
    #pragma message "Compiling for ATtiny85 with original fuse settings"
    #pragma message "Low Fuse: 0xE2, High Fuse: 0xDF"
    
#else
    // 기타 ATtiny 시리즈용 안전한 기본 설정
    // 주의: 0xFF는 SPIEN=1로 설정되어 SPI 프로그래밍이 비활성화됨
    // 대신 0xD7을 사용하여 SPI 프로그래밍을 활성화 상태로 유지
    __fuse_t __fuse __attribute__((section (".fuse"))) = {
        0x62u,  // Low Fuse: 내부 8MHz 오실레이터, 안전한 기본값
        0xD7u,  // High Fuse: SPIEN=0 (SPI 활성화), 안전한 기본값  
        0xFFu   // Extended Fuse: 안전한 기본값
    };
    
    #pragma message "Using safe default fuse settings for ATtiny series"
    #pragma message "Low Fuse: 0x62 (8MHz internal), High Fuse: 0xD7 (SPI enabled)"
#endif

#define ISR_DEBUG	(0)		// set nonzero to use PB2 as debug output pin
#define BITVAL(_x) static_cast<uint8_t>(1u << (_x))

// Pin assignments (ATtiny13/85 공통)
// PB0/MOSI			far LED drive, active high
// PB1/MISO			near LED drive, active high
// PB2/ADC1/SCK	        	output to Duet via 12K resistor
// PB3/ADC3			output to Duet via 10K resistor
// PB4/ADC2			input from phototransistor
// PB5/ADC0/RESET       	not available, used for programming

const unsigned int AdcPhototransistorChan = 2;				// ADC channel for the phototransistor
const unsigned int AdcPortBDuet10KOutputChan = 3;			// ADC channel for the 10K output bit, when we use it as an input
const unsigned int PortBNearLedBit = 1;
const unsigned int PortBFarLedBit = 0;
const unsigned int PortBDuet10KOutputBit = 3;
const unsigned int PortBDuet12KOutputBit = 2;
const uint8_t OutputOn = BITVAL(PortBDuet10KOutputBit) | BITVAL(PortBDuet12KOutputBit);
const uint8_t PortBUnusedBitMask = 0;

// 메모리 사용량 체크 (ATtiny13용)
#if IS_ATTINY13
    #if defined(__AVR_ATtiny13__) && (__AVR_ATtiny13__ == 1)
        #pragma message "WARNING: ATtiny13 has only 1KB flash memory - code size optimization recommended"
    #endif
#endif

ISR(ADC_vect) { // ADC interrupt handler
}

void startADC() {
  ADCSRA = BITVAL(ADEN) | BITVAL(ADSC) | BITVAL(ADIE); // enable ADC, start conversion
  sleep_enable();
  do {
    sei();
    sleep_cpu();
    cli();
  } while(ADCSRA & BITVAL(ADSC));
  sleep_disable();
}

// Run the IR sensor and the fan
void runIRsensor() {
    cli();
    TIFR = BITVAL(OCF0B); // clear any pending interrupt

    ADMUX = (uint8_t)AdcPortBDuet10KOutputChan; // select the 10K resistor output bit, single ended mode
    ADCSRA = BITVAL(ADEN) | BITVAL(ADIE);	// enable ADC
    ADCSRB = 0; // ADC manual invocation
    set_sleep_mode( SLEEP_MODE_ADC );
    sleep_enable();

    // Change back to normal operation mode
    ADMUX = (uint8_t)AdcPhototransistorChan; // select input 1 = phototransistor, single ended mode
    DDRB |= BITVAL(PortBDuet10KOutputBit);  // set the pin back to being an output

    uint8_t output = BITVAL(PortBDuet12KOutputBit) | BITVAL(PortBDuet10KOutputBit); // Full output via both resistors
    PORTB = output;
    sei();

    // Start normal operation
    for (;;) {
      startADC();
      uint16_t offVal = ADC;       // get the ADC reading from the previous conversion
      PORTB = output | BITVAL(PortBNearLedBit);     // turn near LED on

      startADC(); // waste some time, initial value after switch doesn't look stable
      startADC();
      uint16_t nearVal = ADC;       // get the ADC reading from the previous conversion
      PORTB = output | BITVAL(PortBFarLedBit);     // turn far LED on
      startADC(); // waste some time, initial value after switch doesn't look stable
      startADC();
      uint16_t farVal = ADC;       // get the ADC reading from the previous conversion
      PORTB = output;                       // turn of LEDs

      uint16_t nearClean = (nearVal > offVal) ? nearVal - offVal : 0;
      uint16_t farClean = (farVal > offVal) ? farVal - offVal : 0;

      // Differential modulated IR sensor mode								
      if (nearVal > farVal) {
        output = OutputOn;
      } else {
        output = 0;
      }
      PORTB = output;
    }
  }

// Main program
int main(void) {
  cli();
  DIDR0 = BITVAL(AdcPhototransistorChan); // disable digital input buffers on ADC pins

  // Set ports and pullup resistors
  PORTB = PortBUnusedBitMask; // enable pullup on unused I/O pins

  // Enable outputs
  DDRB = BITVAL(PortBNearLedBit) | BITVAL(PortBFarLedBit) | BITVAL(PortBDuet10KOutputBit) | BITVAL(PortBDuet12KOutputBit);

  sei();

  runIRsensor(); // doesn't return
  return 0; // to keep gcc happy
}

// End
