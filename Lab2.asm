AREA RESET, CODE, READONLY
		ENTRY
		ARM
		b main
		nop
		b swi_h
		ADR R0,SRC ; Load address of A to R4
		LDR R12,=DEST ; Load address of DST to R5
		
main	ADR R0,SRC ; Load address of A to R4
		LDR R12,=DEST ; Load address of DST to R5
		LDR R13,=0X40000100
		LDR R1,=0X10
		MSR cpsr_c ,R1
		LDM R0!,{R1-R8}
		STM R12!,{R1-R8}
		LDM R0!,{R1-R8}
		STM R12,{R1-R8}
		
		SWI 0x1240
		
stop1 b stop1		
swi_h	STM SP!,{R0-R12}
		ldr r1,[lr,#-4]
		LDR r0,=0x1240
		AND r1,0X00FFFFFF  
		SUBS R0,R1
		BEQ	ISR
		b stop2
		
ISR		LDR r1,=0x40000080
		LDR r0,=DEST
		MOV r3,#0x14; 20 in decimal
L1 		LDR r5,[r0]
		CMP R5,#'a'
		BEQ L2
		BLS L3
		CMPHI R5,#'z'
		ADDLS R12,R12,#1
		B L3
L2 		ADD R12,R12,#1
L3 		ADD R0,R0,#4
		SUBS R3,r3,#1
		BNE L1
		STR r12,[r1]
stop2	LDM SP!,{R0-R12}
		MOVS PC,LR
			
SRC 	DCD 'a','b','c','d','e','f','1','2','3','4','6','q','5','4','g','t','o','e','y','u'
		AREA RES, DATA, READWRITE
DEST    DCD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		
		END