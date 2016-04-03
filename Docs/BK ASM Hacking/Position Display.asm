[Print]: 0x802F7870
[IToA]: 0x8033D8A4
[Return]: 0x8024EE90

[XPos]: 0x8037C5A0
[YPos]: 0x8037C5A4
[ZPos]: 0x8037C5A8

[XVelocity]: 0x8037C4B8
[YVelocity]: 0x8037C4BC
[ZVelocity]: 0x8037C4C0

[SlopeTimer]: 0x8037C2E4

[StringBufferSize]: 33
[TextSize]: 0x3F800000 // 0xBF000666

[OSDXOffset]: 0x10
[OSDXOffsetValue]: 0x40

.org 0x80400000
PUSH ra
PUSH a0
PUSH a1
PUSH a2
PUSH a3

// Print X Position Label
LI a1 0x10 // Y Pos
LI a2 @TextSize
LA a3 XPosStr
JAL @Print
LI a0 @OSDXOffset

// Convert X position to String
LA a0 XPosValueStr
LA a1 @XPos
JAL FloatToString
NOP

// Print X Position Value
LI a1 0x10 // Y Pos
LI a2 @TextSize
LA a3 XPosValueStr
JAL @Print
LI a0 @OSDXOffsetValue

// Print Y Position Label
LI a1 0x20 // Y Pos
LI a2 @TextSize
LA a3 YPosStr
JAL @Print
LI a0 @OSDXOffset

// Convert Y position to String
LA a0 YPosValueStr
LA a1 @YPos
JAL FloatToString
NOP

// Print Y Position Value
LI a1 0x20 // Y Pos
LI a2 @TextSize
LA a3 YPosValueStr
JAL @Print
LI a0 @OSDXOffsetValue

// Print Z Position Label
LI a1 0x30 // Y Pos
LI a2 @TextSize
LA a3 ZPosStr
JAL @Print
LI a0 @OSDXOffset

// Convert Z position to String
LA a0 ZPosValueStr
LA a1 @ZPos
JAL FloatToString
NOP

// Print Z Position Value
LI a1 0x30 // Y Pos
LI a2 @TextSize
LA a3 ZPosValueStr
JAL @Print
LI a0 @OSDXOffsetValue

// Convert Slope Timer to String
LA a0 SlopeTimerValueStr
LA a1 @SlopeTimer
JAL FloatToString
NOP

// Print Slope Timer Value
LI a1 0x50 // Y Pos
LI a2 @TextSize
LA a3 SlopeTimerValueStr
JAL @Print
LI a0 @OSDXOffsetValue

POP a3
POP a2
POP a1
POP a0
POP ra
J @Return
NOP

FloatToString:
// a0 char[] buffer, should be 33 bytes long since itoa can output a 32 byte string supposedly
// a1 float* source
PUSH ra
PUSH a0
PUSH a1
PUSH a2
PUSH a3

// Clear the string buffer
LI t1 0 // i = 0
ClearByte:
ADDU t0 a0 t1 // j = string + i
SB r0 0(t0) // write(j, 0)
ADDIU t1 t1 1 // i++
BNEI t1 @StringBufferSize ClearByte // if i != StringBufferSize goto ClearByte
NOP

// Convert float to signed 32 bit int
LWC1 f31 0(a1)
LA t1 PrecisionMultiplier
LWC1 f30 0(t1)
MUL.S f31 f31 f30
CVT.W.S f31 f31
MFC1 a1 f31

// Convert int to string
LI a2 10 // Radix (base)
JAL @IToA
NOP

// Add decimal place
LI t1 0 // i = 0
CheckByte:
ADDU t0 a0 t1
LB t2 0(t0) // t2 = string[i]
ADDIU t1 t1 1 // i++
BNEZ t2 CheckByte // if t2 == 0 goto ClearByte
NOP

SUBI t0 t0 3 // i -= 3

//BLT a0 t0 SkipDecimalPoint // Don't add decimal place if the string is less than 3 characters long
//NOP

LB t4 2(t0) // Move last 3 decimal places forward by 1 to add a byte space for decimal point
SB t4 3(t0)
LB t4 1(t0)
SB t4 2(t0)
LB t4 0(t0)
SB t4 1(t0)

LI t4 0x2E // Decimal point
SB t4 0(t0)

SkipDecimalPoint:
POP a3
POP a2
POP a1
POP a0
POP ra
JR RA
NOP

PrecisionMultiplier:
.word 0x447A0000 // 100
XPosStr:
.asciiz "X:"
YPosStr:
.asciiz "Y:"
ZPosStr:
.asciiz "Z:"
XVelocityStr:
.asciiz "X VEL:"
YVelocityStr:
.asciiz "Y VEL:"
ZVelocityStr:
.asciiz "Z VEL:"
SlopeTimerStr:
.asciiz "SLOPE:"
XPosValueStr:
.asciiz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
YPosValueStr:
.asciiz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
ZPosValueStr:
.asciiz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
SlopeTimerValueStr:
.asciiz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"