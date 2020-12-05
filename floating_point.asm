.global _start
	_start:
    ldr r1,  =0x3F800000    ;value of the first operand  0.5
		ldr r2,  =0x40000000    ;value of the first operand 3.0
		
		ldr r10, =0x7f800000    ;value to get the exponents 
		ldr r3,  =0x7FFFFF      ;value to get the mantissas
		ldr r8,  =0xFF7FFFFF    ;value to put 1 bit to the left of the mantissa	
		
		and r4, r1, r10 	      ;using bitmask to capture the exponent of r1
		and r5, r2, r10	        ;using bitmask to capture the exponent of r2		
		
		and r6, r1, r3 	        ;using bitmask to capture r1's mantissa
		eor r9, r6, r8          ;xor to the greater mantissa
		mvn r6, r9	            ;puting 1 bit to the left of the mantissa
		
		and r7, r2, r3          ;using bitmask to capture r2's mantissa
		eor r9, r7, r8          ;xor to the greater mantissa
		mvn r7, r9	            ;puting 1 bit to the left of the mantissa
		
		mov r4, r4, lsr #23     ;getting the real values to substract
		mov r5, r5, lsr #23
		
		cmp r4, r5
		blt case                ;go to case if r4 < 45
		beq case2               ;go to case2 if r4 == r5
		sub r9, r4, r5          ;subtraction of exponents 
		lsl r4, r4, #23         ;putting the exponent of r1 to his original position
		lsr r7, r7, r9          ;shifting to the right the smaller mantisa
		orr r0, r7, r6          ;getting the sum of the mantissas
		and r0, r0, r3          ;getting reed of the 1 put on the front
		orr r11, r4, r0         ;assembling the sign, exponent and the mantissa
		case:
			sub r9, r5, r4        ;subtraction of exponents 
			lsl r5, r5, #23       ;putting the exponent of r2 to his original position
			lsr r6, r6, r9        ;shifting to the right the smaller mantisa
			orr r0, r7, r6        ;getting the sum of the mantissas
			and r0, r0, r3        ;getting reed of the 1 put on the front
			orr r11, r5, r0       ;assembling the sign, exponent and the mantissa
		case2:
			add r0, r6, r7        ;we simply add the mantissas because the exponents are the same
			lsr r0, r0, #1        ;we shift to the right to obtain just one 1 next to the mantissa
			and r0, r0, r3        ;we get reed of the one in the left
			add r5, r5, #1        ;we add 1 to the exponent 
			mov r5, r5, lsl #23   ;putting back the exponent into his original position
			orr r11, r5, r0       ;assembling the sign, exponent and the mantissa
	.end 