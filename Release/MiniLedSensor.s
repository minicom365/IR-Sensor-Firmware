	.file	"MiniLedSensor.cpp"
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text._ZN6IrData10addReadingEj,"axG",@progbits,_ZN6IrData10addReadingEj,comdat
	.weak	_ZN6IrData10addReadingEj
	.type	_ZN6IrData10addReadingEj, @function
_ZN6IrData10addReadingEj:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r26,r24
	adiw r26,16
	ld r18,X+
	ld r19,X
	sbiw r26,16+1
	adiw r26,18
	ld r25,X
	sbiw r26,18
	mov r30,r25
	ldi r31,0
	lsl r30
	rol r31
	add r30,r26
	adc r31,r27
	add r18,r22
	adc r19,r23
	ld r20,Z
	ldd r21,Z+1
	sub r18,r20
	sbc r19,r21
	adiw r26,16+1
	st X,r19
	st -X,r18
	sbiw r26,16
	std Z+1,r23
	st Z,r22
	subi r25,lo8(-(1))
	andi r25,lo8(7)
	adiw r26,18
	st X,r25
	ret
	.size	_ZN6IrData10addReadingEj, .-_ZN6IrData10addReadingEj
	.section	.text.__vector_11,"ax",@progbits
.global	__vector_11
	.type	__vector_11, @function
__vector_11:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	in r22,0x4
	in r23,0x4+1
	andi r23,3
	lds r24,tickCounter
	lds r25,tickCounter+1
.L3:
	in r18,0x32
	cpi r18,lo8(24)
	brlo .L3
	andi r24,3
	clr r25
	cpi r24,2
	cpc r25,__zero_reg__
	breq .L5
	cpi r24,3
	cpc r25,__zero_reg__
	breq .L6
	sbiw r24,1
	breq .L7
	cbi 0x18,0
	rjmp .L8
.L7:
	lds r24,running
	tst r24
	breq .L9
	ldi r24,lo8(farData)
	ldi r25,hi8(farData)
	rcall _ZN6IrData10addReadingEj
.L9:
	sbi 0x18,1
	rjmp .L8
.L5:
	lds r24,running
	tst r24
	breq .L10
	ldi r24,lo8(offData)
	ldi r25,hi8(offData)
	rcall _ZN6IrData10addReadingEj
.L10:
	cbi 0x18,1
	rjmp .L8
.L6:
	lds r24,running
	tst r24
	breq .L11
	ldi r24,lo8(nearData)
	ldi r25,hi8(nearData)
	rcall _ZN6IrData10addReadingEj
.L11:
	sbi 0x18,0
.L8:
	lds r24,tickCounter
	lds r25,tickCounter+1
	adiw r24,1
	sts tickCounter+1,r25
	sts tickCounter,r24
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_11, .-__vector_11
	.section	.text._Z12SetOutputOffv,"axG",@progbits,_Z12SetOutputOffv,comdat
	.weak	_Z12SetOutputOffv
	.type	_Z12SetOutputOffv, @function
_Z12SetOutputOffv:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0x18,3
	cbi 0x18,2
	ret
	.size	_Z12SetOutputOffv, .-_Z12SetOutputOffv
	.section	.text._Z18SetOutputSaturatedv,"axG",@progbits,_Z18SetOutputSaturatedv,comdat
	.weak	_Z18SetOutputSaturatedv
	.type	_Z18SetOutputSaturatedv, @function
_Z18SetOutputSaturatedv:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x18,3
	sbi 0x18,2
	ret
	.size	_Z18SetOutputSaturatedv, .-_Z18SetOutputSaturatedv
	.section	.text._Z13CheckWatchdogv,"ax",@progbits
.global	_Z13CheckWatchdogv
	.type	_Z13CheckWatchdogv, @function
_Z13CheckWatchdogv:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  243 ".././MiniLedSensor.cpp" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r18,tickCounter
	lds r19,tickCounter+1
/* #APP */
 ;  245 ".././MiniLedSensor.cpp" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	lds r24,lastKickTicks
	lds r25,lastKickTicks+1
	sub r18,r24
	sbc r19,r25
	cpi r18,-12
	sbci r19,1
	brlo .L25
/* #APP */
 ;  256 ".././MiniLedSensor.cpp" 1
	wdr
 ;  0 "" 2
/* #NOAPP */
	subi r24,12
	sbci r25,-2
	sts lastKickTicks+1,r25
	sts lastKickTicks,r24
.L25:
	ret
	.size	_Z13CheckWatchdogv, .-_Z13CheckWatchdogv
	.section	.text._Z10DelayTicksj,"ax",@progbits
.global	_Z10DelayTicksj
	.type	_Z10DelayTicksj, @function
_Z10DelayTicksj:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r28,r24
/* #APP */
 ;  243 ".././MiniLedSensor.cpp" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r16,tickCounter
	lds r17,tickCounter+1
/* #APP */
 ;  245 ".././MiniLedSensor.cpp" 1
	sei
 ;  0 "" 2
/* #NOAPP */
.L28:
	rcall _Z13CheckWatchdogv
/* #APP */
 ;  243 ".././MiniLedSensor.cpp" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r18,tickCounter
	lds r19,tickCounter+1
/* #APP */
 ;  245 ".././MiniLedSensor.cpp" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	sub r18,r16
	sbc r19,r17
	cp r18,r28
	cpc r19,r29
	brlo .L28
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	_Z10DelayTicksj, .-_Z10DelayTicksj
	.section	.text._ZN6IrData4initEv,"ax",@progbits
.global	_ZN6IrData4initEv
	.type	_ZN6IrData4initEv, @function
_ZN6IrData4initEv:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	movw r18,r24
	subi r18,-16
	sbci r19,-1
.L31:
	st Z+,__zero_reg__
	st Z+,__zero_reg__
	cp r30,r18
	cpc r31,r19
	brne .L31
	movw r30,r24
	std Z+18,__zero_reg__
	std Z+17,__zero_reg__
	std Z+16,__zero_reg__
	ret
	.size	_ZN6IrData4initEv, .-_ZN6IrData4initEv
	.section	.text._Z11runIRsensorv,"ax",@progbits
.global	_Z11runIRsensorv
	.type	_Z11runIRsensorv, @function
_Z11runIRsensorv:
	push r28
	push r29
	in r28,__SP_L__
	clr r29
	subi r28,lo8(-(-8))
	out __SP_L__,r28
/* prologue: function */
/* frame size = 8 */
/* stack size = 10 */
.L__stack_usage = 10
	sts running,__zero_reg__
	ldi r24,lo8(nearData)
	ldi r25,hi8(nearData)
	rcall _ZN6IrData4initEv
	ldi r24,lo8(farData)
	ldi r25,hi8(farData)
	rcall _ZN6IrData4initEv
	ldi r24,lo8(offData)
	ldi r25,hi8(offData)
	rcall _ZN6IrData4initEv
/* #APP */
 ;  286 ".././MiniLedSensor.cpp" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	out 0x2c,__zero_reg__
	ldi r24,lo8(2)
	out 0x2a,r24
	out 0x33,__zero_reg__
	out 0x32,__zero_reg__
	ldi r24,lo8(124)
	out 0x29,r24
	out 0x28,__zero_reg__
	ldi r24,lo8(8)
	out 0x38,r24
	out 0x39,r24
	in r24,0x33
	ori r24,lo8(2)
	out 0x33,r24
	ldi r24,lo8(3)
	out 0x7,r24
	ldi r24,lo8(-90)
	out 0x6,r24
	ldi r24,lo8(5)
	out 0x3,r24
	sts tickCounter+1,__zero_reg__
	sts tickCounter,__zero_reg__
	sts lastKickTicks+1,__zero_reg__
	sts lastKickTicks,__zero_reg__
/* #APP */
 ;  303 ".././MiniLedSensor.cpp" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	rcall _Z12SetOutputOffv
	cbi 0x17,3
	ldi r24,lo8(4)
	ldi r25,0
	rcall _Z10DelayTicksj
	ldi r24,lo8(1)
	sts running,r24
	ldi r24,0
	ldi r25,lo8(125)
	rcall _Z10DelayTicksj
	sts running,__zero_reg__
	lds r24,offData+16
	lds r25,offData+16+1
	lds r20,nearData+16
	lds r21,nearData+16+1
	lds r18,farData+16
	lds r19,farData+16+1
	add r24,r20
	adc r25,r21
	add r24,r18
	adc r25,r19
	ldi r18,lo8(1)
	cpi r24,28
	sbci r25,2
	brsh .L34
	ldi r18,0
.L34:
	sts digitalOutput,r18
	ldi r24,lo8(2)
	out 0x7,r24
	sbi 0x17,3
	lds r24,digitalOutput
	cpse r24,__zero_reg__
	rjmp .L44
	ldi r17,lo8(4)
	rjmp .L36
.L44:
	ldi r17,lo8(2)
.L36:
	rcall _Z18SetOutputSaturatedv
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	rcall _Z10DelayTicksj
	rcall _Z12SetOutputOffv
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	rcall _Z10DelayTicksj
	subi r17,lo8(-(-1))
	brne .L36
	ldi r24,lo8(nearData)
	ldi r25,hi8(nearData)
	rcall _ZN6IrData4initEv
	ldi r24,lo8(farData)
	ldi r25,hi8(farData)
	rcall _ZN6IrData4initEv
	ldi r24,lo8(offData)
	ldi r25,hi8(offData)
	rcall _ZN6IrData4initEv
	ldi r24,lo8(1)
	sts running,r24
	ldi r24,lo8(32)
	ldi r25,0
	rcall _Z10DelayTicksj
.L43:
/* #APP */
 ;  350 ".././MiniLedSensor.cpp" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r22,nearData+16
	lds r23,nearData+16+1
	lds r20,farData+16
	lds r21,farData+16+1
	lds r24,offData+16
	lds r25,offData+16+1
/* #APP */
 ;  354 ".././MiniLedSensor.cpp" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	cpi r22,48
	ldi r26,27
	cpc r23,r26
	brsh .L37
	cpi r20,48
	ldi r27,27
	cpc r21,r27
	brlo .L38
.L37:
	rcall _Z18SetOutputSaturatedv
	rjmp .L39
.L38:
	cp r24,r22
	cpc r25,r23
	brsh .L45
	sub r22,r24
	sbc r23,r25
	rjmp .L40
.L45:
	ldi r22,0
	ldi r23,0
.L40:
	lds r18,digitalOutput
	cp r24,r20
	cpc r25,r21
	brsh .L46
	movw r14,r20
	sub r14,r24
	sbc r15,r25
	ldi r30,80
	cp r14,r30
	cpc r15,__zero_reg__
	brlo .L41
	cp r14,r22
	cpc r15,r23
	brsh .L41
	cpse r18,__zero_reg__
	rjmp .L37
	sbi 0x18,3
	cbi 0x18,2
	rjmp .L39
.L46:
	mov r14,__zero_reg__
	mov r15,__zero_reg__
.L41:
	cpse r18,__zero_reg__
	rjmp .L42
	ldi r31,80
	cp r14,r31
	cpc r15,__zero_reg__
	brlo .L42
	ldi r24,0
	ldi r25,0
	ldi r18,lo8(6)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	rcall __umulsidi3
	std Y+1,r18
	std Y+2,r19
	std Y+3,r20
	std Y+4,r21
	std Y+5,r22
	std Y+6,r23
	std Y+7,r24
	std Y+8,r25
	movw r22,r14
	ldi r24,0
	ldi r25,0
	ldi r18,lo8(5)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	rcall __umulsidi3
	movw r8,r18
	movw r10,r20
	ldd r24,Y+1
	ldd r25,Y+2
	ldd r26,Y+3
	ldd r27,Y+4
	cp r24,r8
	cpc r25,r9
	cpc r26,r10
	cpc r27,r11
	brlo .L42
	cbi 0x18,3
	sbi 0x18,2
	rjmp .L39
.L42:
	rcall _Z12SetOutputOffv
.L39:
	rcall _Z13CheckWatchdogv
	rjmp .L43
	.size	_Z11runIRsensorv, .-_Z11runIRsensorv
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  399 ".././MiniLedSensor.cpp" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(4)
	out 0x14,r24
	out 0x18,__zero_reg__
	ldi r24,lo8(15)
	out 0x17,r24
/* #APP */
 ;  408 ".././MiniLedSensor.cpp" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ldi r25,lo8(13)
	ldi r24,lo8(24)
/* #APP */
 ;  469 "c:\program files (x86)\atmel\studio\7.0\toolchain\avr8\avr8-gnu-toolchain\avr\include\avr\wdt.h" 1
	in __tmp_reg__,__SREG__
	cli
	wdr
	out 33, r24
	out __SREG__,__tmp_reg__
	out 33, r25
 	
 ;  0 "" 2
/* #NOAPP */
	rcall _Z11runIRsensorv
	.size	main, .-main
.global	running
	.section	.bss.running,"aw",@nobits
	.type	running, @object
	.size	running, 1
running:
	.zero	1
.global	digitalOutput
	.section	.bss.digitalOutput,"aw",@nobits
	.type	digitalOutput, @object
	.size	digitalOutput, 1
digitalOutput:
	.zero	1
.global	lastKickTicks
	.section	.bss.lastKickTicks,"aw",@nobits
	.type	lastKickTicks, @object
	.size	lastKickTicks, 2
lastKickTicks:
	.zero	2
.global	tickCounter
	.section	.bss.tickCounter,"aw",@nobits
	.type	tickCounter, @object
	.size	tickCounter, 2
tickCounter:
	.zero	2
.global	offData
	.section	.bss.offData,"aw",@nobits
	.type	offData, @object
	.size	offData, 19
offData:
	.zero	19
.global	farData
	.section	.bss.farData,"aw",@nobits
	.type	farData, @object
	.size	farData, 19
farData:
	.zero	19
.global	nearData
	.section	.bss.nearData,"aw",@nobits
	.type	nearData, @object
	.size	nearData, 19
nearData:
	.zero	19
.global	__fuse
	.section	.fuse,"aw",@progbits
	.type	__fuse, @object
	.size	__fuse, 3
__fuse:
	.byte	-30
	.byte	-33
	.byte	-1
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.5.3_1700) 4.9.2"
.global __do_clear_bss
