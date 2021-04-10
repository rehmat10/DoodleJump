#####################################################################
#
# CSC258H5S Winter 2021 Assembly Programming Project
# University of Toronto Mississauga
#
# Group members:
# - Student 1: Rehmat Munir, 1006136842
# - Student 2: Catherine Tianlin Xia, 1005990509
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Displays score on screen and on game-over
# 2. Realistic physics/acceleration on jump
# 3. Increasing difficulty. Specifically shrinks platforms the higher you go
#
# Any additional information that the TA needs to know:
# In order for the sprite of the charachter to stay updated, you should not hold down j or k or tap too fast
#
#####################################################################

.data
displayAddress:	.word	0x10008000
dot: .word 29, 15, 30, 15 #left of square dude (y, x, y, x)
p1: .word 31, 11 #top left y then x coordinates of the platforms
p2: .word 23, 2
p3: .word 15, 20
p4: .word 7, 11
total: .word 1024 #number of pixels to paing bg
red: .word 0xff0000
beige: .word 0xb58b1d
blue: .word 0x87ceff
black: .word 0x000000
darkBlue: .word 0x0000ff
keyboardStroke: .word 0xffff0000
keyboardLetter: .word 0xffff0004
promptA: .asciiz "J was pressed"
newLine: .asciiz "\n"
sequence: .word 0, -4, -2, -2, -1, -1, 1, 1, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4
count: .word 0
platformCount: .word 0
platformLength: .word 10
highestPlatform: .word 99
digit1: 27, 4
digit2: 27, 0

.text
START:
	la $t2, p2
    	li $a1, 20 
    	li $v0, 42
    	syscall 
    	addi $a0, $a0, 2
    	sw $a0, 4($t2)
    	
    	la $t2, p3
    	li $a1, 20 
    	li $v0, 42
    	syscall 
    	addi $a0, $a0, 2
    	sw $a0, 4($t2)
    	
    	la $t2, p4
    	li $a1, 20 
    	li $v0, 42
    	syscall 
    	addi $a0, $a0, 2
    	sw $a0, 4($t2)
    	begin:
	#paint bg
	lw $t0, displayAddress #sets address fof frame
	lw $t1, blue #sets color
	li $a1, 0 #i use $a1 and $a2 as counter for how many times paint should be done
	lw $a2, total
	jal PAINT
	
	#paint platforms
	lw $t0, displayAddress
	lw $t1, beige
	li $a1, 0
	lw $a2, platformLength
	la $t2, p1 #sets array for platform
	jal STEP #STEP does math to find position for painting
	jal PAINT 
	lw $t0, displayAddress
	li $a1, 0
	lw $a2, platformLength
	la $t2, p2
	jal STEP
	jal PAINT
	lw $t0, displayAddress
	li $a1, 0
	lw $a2, platformLength
	la $t2, p3
	jal STEP
	jal PAINT
	lw $t0, displayAddress
	li $a1, 0
	lw $a2, platformLength
	la $t2, p4
	jal STEP
	jal PAINT
	
	#paint dude
	lw $t0, displayAddress
	lw $t1, red
	li $a1, 0
	li $a2, 2
	la $t2, dot #use first (y, x)
	jal STEP #treat dude as small platform 
	jal PAINT #top half
	lw $t0, displayAddress
	li $a1, 0
	li $a2, 2
	add $t2, $t2, 8 #move to second (y, x)
	jal STEP
	jal PAINT #bottom half
	
	la $a3, digit1
	lw $t0, platformCount
	
	li $t2, 10
	div $t0, $t0, $t2
	
	mfhi $a1

	
	
	
	li $t1, 1
	beq $a1, $t1, Digit1One
	
	li $t1, 2
	beq $a1, $t1, Digit1Two
	
	li $t1, 3
	beq $a1, $t1, Digit1Three
	
	li $t1, 4
	beq $a1, $t1, Digit1Four
	
	li $t1, 5
	beq $a1, $t1, Digit1Five
	
	li $t1, 6
	beq $a1, $t1, Digit1Six
	
	li $t1, 7
	beq $a1, $t1, Digit1Seven
	
	li $t1, 8
	beq $a1, $t1, Digit1Eight
	
	li $t1, 9
	beq $a1, $t1, Digit1Nine
	
	Digit1Zero:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1One:
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Two:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Three:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Four:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Five:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Six:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	subi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Seven:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Eight:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	Digit1Nine:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End
	
	End:
	la $a3, digit2
	lw $t0, platformCount
	
	li $t2, 10
	div $t0, $t0, $t2
	
	div $t0, $t0, $t2
	
	mfhi $a1

	
	beqz $a1, Digit2Zero
	
	li $t1, 1
	beq $a1, $t1, Digit2One
	
	li $t1, 2
	beq $a1, $t1, Digit2Two
	
	li $t1, 3
	beq $a1, $t1, Digit2Three
	
	li $t1, 4
	beq $a1, $t1, Digit2Four
	
	li $t1, 5
	beq $a1, $t1, Digit2Five
	
	li $t1, 6
	beq $a1, $t1, Digit2Six
	
	li $t1, 7
	beq $a1, $t1, Digit2Seven
	
	li $t1, 8
	beq $a1, $t1, Digit2Eight
	
	li $t1, 9
	beq $a1, $t1, Digit2Nine
	
	Digit2Zero:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2One:
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Two:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Three:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Four:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Five:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Six:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	subi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Seven:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Eight:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	Digit2Nine:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1
	
	End1:
	
	la $t2, digit1
	li $t0, 27
	sw $t0, 0($t2)
	li $t0, 4
	sw $t0, 4($t2)
	
	la $t2, digit2
	li $t0, 27
	sw $t0, 0($t2)
	li $t0, 0
	sw $t0, 4($t2)
	
	li $v0, 32
	la $a0, 100
	syscall
	


	
WHILE:	#find sequence location
	la $t1, sequence
	lw $t2, count
	sll $t4, $t2, 2
	add $t1, $t1, $t4
	lw $t3, ($t1)
	#update count
	addi $t2, $t2, 1
	sw $t2, count
	
	#redraw dot
	la $t1, dot
	lw $t2, 0($t1)
	add $a2, $t2, $t3
	sw $a2, 0($t1) #$a2 stores new height
	lw $a3, 4($t1) #$a3 stores left
	lw $t2, 8($t1)
	add $t2, $t2, $t3
	sw $t2, 8($t1)
	
	#check if dot is on platform
	
	la $t1, p1
	lw $t3, 0($t1)
	add $t4, $a2, 2
	bne $t4, $t3, check2
	lw $t3, 4($t1)
	subi $t3, $t3, 2
	sub $t4, $a3, $t3
	blez $t4, check2
	lw $t5, platformLength
	addi $t5, $t5, 2 
	add $t4, $t3, $t5
	sub $t4, $t4, $a3
	blez $t4, check2
	li $t5, 1
	sw $t5, count
	lw $t3, 0($t1)
	lw $t4, highestPlatform
	bge $t3, $t4, check2
	sw $t3, highestPlatform
	lw $t4, platformCount
	addi $t4, $t4, 1
	sw $t4, platformCount
	check2:
	la $t1, p2
	lw $t3, 0($t1)
	add $t4, $a2, 2
	bne $t4, $t3, check3
	lw $t3, 4($t1)
	subi $t3, $t3, 2
	sub $t4, $a3, $t3
	blez $t4, check3
	lw $t5, platformLength
	addi $t5, $t5, 2
	add $t4, $t3, $t5
	sub $t4, $t4, $a3
	blez $t4, check3
	li $t5, 1
	sw $t5, count
	lw $t3, 0($t1)
	lw $t4, highestPlatform
	bge $t3, $t4, check3
	sw $t3, highestPlatform
	lw $t4, platformCount
	addi $t4, $t4, 1
	sw $t4, platformCount
	check3:
	la $t1, p3
	lw $t3, 0($t1)
	add $t4, $a2, 2
	bne $t4, $t3, check4
	lw $t3, 4($t1)
	subi $t3, $t3, 2
	sub $t4, $a3, $t3
	blez $t4, check4
	lw $t5, platformLength
	addi $t5, $t5, 2
	add $t4, $t3, $t5
	sub $t4, $t4, $a3
	blez $t4, check4
	li $t5, 1
	sw $t5, count
	lw $t3, 0($t1)
	lw $t4, highestPlatform
	bge $t3, $t4, check4
	sw $t3, highestPlatform
	lw $t4, platformCount
	addi $t4, $t4, 1
	sw $t4, platformCount
	check4:
	la $t1, p4
	lw $t3, 0($t1)
	add $t4, $a2, 2
	bne $t4, $t3, toohigh
	lw $t3, 4($t1)
	subi $t3, $t3, 2
	sub $t4, $a3, $t3
	blez $t4, toohigh
	lw $t5, platformLength
	addi $t5, $t5, 2
	add $t4, $t3, $t5
	sub $t4, $t4, $a3
	blez $t4, toohigh
	li $t5, 1
	sw $t5, count
	lw $t3, 0($t1)
	lw $t4, highestPlatform
	bge $t3, $t4, toohigh
	sw $t3, highestPlatform
	lw $t4, platformCount
	addi $t4, $t4, 1
	sw $t4, platformCount
	toohigh:
	subi $t6, $a2, 5
	bgez $t6, toolow
	uploop:
	beqz $t6, done
	addi $t6, $t6, 1
	jal UP
	j uploop
	toolow:
	li $t3, 31
	bgt $t3, $a2, done
	#la $t1, p1
	#lw $t3, 0($t1)
	#addi $t3, $t3, 1
	#bgt $t3, $a2, done
	#la $t1, p2
	#lw $t3, 0($t1)
	#addi $t3, $t3, 1
	#bgt $t3, $a2, done
	#la $t1, p3
	#lw $t3, 0($t1)
	#addi $t3, $t3, 1
	#bgt $t3, $a2, done
	#la $t1, p4
	#lw $t3, 0($t1)
	#addi $t3, $t3, 1
	#bgt $t3, $a2, done
	lw $t5, highestPlatform
	li $t5, 99
	sw $t5, highestPlatform
	lw $t5, platformLength
	li $t5, 10
	sw $t5, platformLength
	j REFRESH
	
	done:
	
	lw $t0, platformCount
	li $t1, 10
	ble $t0, $t1, after
	li $t2, 9
	sw $t2, platformLength
	li $t1, 20
	ble $t0, $t1, after
	li $t2, 8
	sw $t2, platformLength
	li $t1, 30
	ble $t0, $t1, after
	li $t2, 7
	sw $t2, platformLength
	li $t1, 40
	ble $t0, $t1, after
	li $t2, 6
	sw $t2, platformLength
	li $t1, 50
	ble $t0, $t1, after
	li $t2, 5
	sw $t2, platformLength
	li $t1, 60
	ble $t0, $t1, after
	li $t2, 4
	sw $t2, platformLength
	li $t1, 70
	ble $t0, $t1, after
	li $t2, 3
	sw $t2, platformLength
	li $t1, 80
	ble $t0, $t1, after
	li $t2, 1
	sw $t2, platformLength
	
	after:
	
	lui $a0, 0xffff #If the value at this address is non zero, currently a button is being pressed
	lw $t5, 0($a0)
	
	bnez $t5, MOVE
	
	
	
	
	li $v0, 1
	lw $t0, platformCount
	add $a0, $t0, $zero
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	
	j begin
	
	
	
	

REFRESH:
	lw $t0, displayAddress #sets address fof frame
	lw $t1, black #sets color
	li $a1, 0 #i use $a1 and $a2 as counter for how many times paint should be done
	lw $a2, total
	jal PAINT
	#dot
	la $t1, dot
	li $t2, 29
	sw $t2, 0($t1)
	li $t2, 15
	sw $t2, 4($t1)
	sw $t2, 12($t1)
	li $t2, 30
	sw $t2, 8($t1)
	#p1
	la $t1, p1
	li $t2, 31
	sw $t2, 0($t1)
	li $t2, 11
	sw $t2, 4($t1)
	#p2
	la $t1, p2
	li $t2, 23
	sw $t2, 0($t1)
	#p3
	la $t1, p3
	li $t2, 15
	sw $t2, 0($t1)
	#p4
	la $t1, p4
	li $t2, 7
	sw $t2, 0($t1)
	#count
	li $t2, 0
	sw $t2, count
	
	#platformLength
	li $t2, 10
	sw $t2, platformLength
	
	
	
	la $t0, digit1
	li $t1, 13
	sw $t1, 0($t0)
	li $t2, 16
	sw $t2, 4($t0)
	
	la $t0, digit2
	li $t1, 13
	sw $t1, 0($t0)
	li $t2, 12
	sw $t2, 4($t0)
	
	la $a3, digit1
	lw $t0, platformCount
	
	li $t2, 10
	div $t0, $t0, $t2
	
	mfhi $a1

	
	
	
	li $t1, 1
	beq $a1, $t1, Digit1OneR
	
	li $t1, 2
	beq $a1, $t1, Digit1TwoR
	
	li $t1, 3
	beq $a1, $t1, Digit1ThreeR
	
	li $t1, 4
	beq $a1, $t1, Digit1FourR
	
	li $t1, 5
	beq $a1, $t1, Digit1FiveR
	
	li $t1, 6
	beq $a1, $t1, Digit1SixR
	
	li $t1, 7
	beq $a1, $t1, Digit1SevenR
	
	li $t1, 8
	beq $a1, $t1, Digit1EightR
	
	li $t1, 9
	beq $a1, $t1, Digit1NineR
	
	Digit1ZeroR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1OneR:
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1TwoR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1ThreeR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1FourR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1FiveR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1SixR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	subi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1SevenR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1EightR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	Digit1NineR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j EndR
	
	EndR:
	la $a3, digit2
	lw $t0, platformCount
	
	li $t2, 10
	div $t0, $t0, $t2
	
	div $t0, $t0, $t2
	
	mfhi $a1

	
	beqz $a1, Digit2ZeroR
	
	li $t1, 1
	beq $a1, $t1, Digit2OneR
	
	li $t1, 2
	beq $a1, $t1, Digit2TwoR
	
	li $t1, 3
	beq $a1, $t1, Digit2ThreeR
	
	li $t1, 4
	beq $a1, $t1, Digit2FourR
	
	li $t1, 5
	beq $a1, $t1, Digit2FiveR
	
	li $t1, 6
	beq $a1, $t1, Digit2SixR
	
	li $t1, 7
	beq $a1, $t1, Digit2SevenR
	
	li $t1, 8
	beq $a1, $t1, Digit2EightR
	
	li $t1, 9
	beq $a1, $t1, Digit2NineR
	
	Digit2ZeroR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2OneR:
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2TwoR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2ThreeR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2FourR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2FiveR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2SixR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	subi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2SevenR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2EightR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	j End1R
	
	Digit2NineR:
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	

	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)	
	la $t2, ($a3)
	lw $t0, 4($t2)
	addi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 1
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	la $t2, ($a3)
	lw $t0, 0($t2)
	addi $t0, $t0, 1
	sw $t0, 0($t2)
	la $t2, ($a3)
	lw $t0, 4($t2)
	subi $t0, $t0, 2
	sw $t0, 4($t2)
	
	lw $t0, displayAddress
	lw $t1, darkBlue
	li $a1, 0
	li $a2, 3
	la $t2, ($a3)
	jal STEP
	jal PAINT
	
	
	End1R:
	li $t2, 0
	sw $t2, platformCount
	
	la $t2, digit1
	li $t0, 27
	sw $t0, 0($t2)
	li $t0, 4
	sw $t0, 4($t2)
	
	la $t2, digit2
	li $t0, 27
	sw $t0, 0($t2)
	li $t0, 0
	sw $t0, 4($t2)
	
	li $v0, 32
	la $a0, 3000
	syscall
	
	j START

	

MOVE:
	lui $a0, 0xffff
	lw $v0, 4($a0) #Location of which button is being pressed
	addi $a0, $v0, 0

	#Hexidecimal for 106 and 107 (ASCII of j and k)
	li $t7, 0x0000006a 
	li $t8, 0x0000006b

	beq $a0, $t7, LEFT
	beq $a0, $t8, RIGHT
	
	
	jr $ra
	
LEFT:
    la $t2, dot
    lw $t3, 4($t2)
    subi $t3, $t3, 2
    andi $t3, $t3, 31
    sw $t3, 4($t2)
    la $t2, dot
    lw $t3, 12($t2)
    subi $t3, $t3, 2
    andi $t3, $t3, 31
    sw $t3, 12($t2)
    jr $ra

RIGHT:
    la $t2, dot
    lw $t3, 4($t2)
    addi $t3, $t3, 2
    andi $t3, $t3, 31
    sw $t3, 4($t2)
    la $t2, dot
    lw $t3, 12($t2)
    addi $t3, $t3, 2
    andi $t3, $t3, 31
    sw $t3, 12($t2)
    jr $ra

UP:
    lw $t1, highestPlatform
    addi $t1, $t1, 1
    sw $t1, highestPlatform
	
    li $t1, 32
    
    la $t2, p1
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, new2
    li $t3, 0
    sw $t3, 0($t2)
    li $a1, 28
    lw $t5, platformLength
    sub $a1, $a1, $t5 
    li $v0, 42
    syscall
    addi $a0, $a0, 2 
    sw $a0, 4($t2)
    
    new2:
    la $t2, p2
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, new3
    li $t3, 0
    sw $t3, 0($t2)
    li $a1, 28
    lw $t5, platformLength
    sub $a1, $a1, $t5 
    li $v0, 42
    syscall
    addi $a0, $a0, 2 
    sw $a0, 4($t2)
    
    new3:
    la $t2, p3
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, new4
    li $t3, 0
    sw $t3, 0($t2)
    li $a1, 28
    lw $t5, platformLength
    sub $a1, $a1, $t5 
    li $v0, 42
    syscall
    addi $a0, $a0, 2 
    sw $a0, 4($t2)
    
    new4:
    la $t2, p4
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, moveDude
    li $t3, 0
    sw $t3, 0($t2)
    li $a1, 28
    lw $t5, platformLength
    sub $a1, $a1, $t5 
    li $v0, 42
    syscall
    addi $a0, $a0, 2 
    sw $a0, 4($t2)
    
    moveDude:
    la $t2, dot
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    lw $t3, 8($t2)
    addi $t3, $t3, 1
    sw $t3, 8($t2)
    jr $ra
    


PAINT:
	#this method does the actual painting for $a2-$a1 time in a continuous horizontal line
	
	sw $t1, ($t0)
	addi $t0, $t0, 4
	addi $a1, $a1, 1
	bne $a1, $a2, PAINT
	jr $ra

STEP:
	#this method does math needed to find location based on 32x32 naming system
	lw $t3, 0($t2) #y
	sll $t3, $t3, 7 #multiply by 2*7(128) to correct column
	add $t0, $t0, $t3 #add prev line to screen location)
	lw $t4, 4($t2) #x
	sll $t4, $t4, 2 #multiply by 4 to correct row
	add $t0, $t0, $t4 #add prev
	#ready to paint
	jr $ra
