.data
displayAddress:	.word	0x10008000
dot: .word 29, 15, 30, 15 #left of square dude (y, x, y, x)
p1: .word 31, 11 #top left y then x coordinates of the platforms
p2: .word 20, 1
p3: .word 10, 21
total: .word 1024 #number of pixels to paing bg
red: .word 0xff0000
beige: .word 0xb58b1d
blue: .word 0x87ceff
keyboardStroke: .word 0xffff0000
keyboardLetter: .word 0xffff0004
promptA: .asciiz "J was pressed"
newLine: .asciiz "\n"
	
	
.text
START:
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
	li $a2, 10
	la $t2, p1 #sets array for platform
	jal STEP #STEP does math to find position for painting
	jal PAINT 
	lw $t0, displayAddress
	li $a1, 0
	li $a2, 10
	la $t2, p2
	jal STEP
	jal PAINT
	lw $t0, displayAddress
	li $a1, 0
	li $a2, 10
	la $t2, p3
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
	


KEY:
NONE:
WHILE:	
	
	lui $a0, 0xffff
	lw $t5, 0($a0)
	
	bnez $t5, MOVE
	
	
	lui $a0, 0xffff
	lw $t5, 0($a0)
	
	
	li $v0, 1
	add $a0, $t5, $zero
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	
	j REFRESH
	
	
	
	

REFRESH:
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
	li $a2, 10
	la $t2, p1 #sets array for platform
	jal STEP #STEP does math to find position for painting
	jal PAINT 
	lw $t0, displayAddress
	li $a1, 0
	li $a2, 10
	la $t2, p2
	jal STEP
	jal PAINT
	lw $t0, displayAddress
	li $a1, 0
	li $a2, 10
	la $t2, p3
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
	
	li $v0, 32
	la $a0, 200
	syscall
	
	j WHILE

	

MOVE:
	lui $a0, 0xffff
	lw $v0, 4($a0)
	addi $a0, $v0, 0

	li $t7, 0x0000006a
	li $t8, 0x0000006b

	beq $a0, $t7, LEFT
	beq $a0, $t8, RIGHT
	
	
	jr $ra
	
LEFT:
    la $t2, dot
    lw $t3, 4($t2)
    subi $t3, $t3, 1
    andi $t3, $t3, 31
    sw $t3, 4($t2)
    la $t2, dot
    lw $t3, 12($t2)
    subi $t3, $t3, 1
    andi $t3, $t3, 31
    sw $t3, 12($t2)
    jr $ra

RIGHT:
    la $t2, dot
    lw $t3, 4($t2)
    addi $t3, $t3, 1
    andi $t3, $t3, 31
    sw $t3, 4($t2)
    la $t2, dot
    lw $t3, 12($t2)
    addi $t3, $t3, 1
    andi $t3, $t3, 31
    sw $t3, 12($t2)
    jr $ra

UP:
    li $t1, 32
    
    la $t2, p1
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, new2
    li $t3, 0
    sw $t3, 0($t2)
    li $v0, 42
    li $a1, 22
    syscall
    li $v0, 1   # 1 is the system call code to show an int number
    syscall     # as I said your generated number is at $a0, so it will be printed
    sw $a0, 4($t2)
    
    new2:
    la $t2, p2
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, new3
    li $t3, 0
    sw $t3, 0($t2)
    li $v0, 42
    li $a1, 22
    syscall
    li $v0, 1   # 1 is the system call code to show an int number
    syscall     # as I said your generated number is at $a0, so it will be printed
    sw $a0, 4($t2)
    
    new3:
    la $t2, p3
    lw $t3, 0($t2)
    addi $t3, $t3, 1
    sw $t3, 0($t2)
    bne $t1, $t3, moveDude
    li $t3, 0
    sw $t3, 0($t2)
    li $v0, 42
    li $a1, 22
    syscall
    li $v0, 1   # 1 is the system call code to show an int number
    syscall     # as I said your generated number is at $a0, so it will be printed
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
EXIT:
	
	
	li $v0, 10 # terminate
	syscall

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
	
		
	
	
	