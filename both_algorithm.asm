# ALUNOS:
#
# Igor Batista Paiva - 18/0018728 
# Rhuan Carlos Pereira de Queiroz - 18/0054848
#
# Universidade de Brasília Campus Gama

.data


.text
	read_integer:
		li $v0, 5
		syscall

		jr $ra

	print_integer:
		li $v0, 1
		syscall

		jr $ra

	multfac:
		# $s0 it's HIGH
		add $s0, $zero, $zero
		# $s1 é LOW
		add $s1, $a1, $zero
		# aux bit
		add $s2, $zero, $zero

		addi $t3, $zero, 1
		addi $t4, $zero, 32

		loop:
			beq $t3, $t4, return

			andi $t0, $s1, 1

			bne $t0, $zero, p0_is_1

			beq $s2, $zero, arithmetic_right_shift

			# s0 = s0 + a1
			add $s0, $s0, $a1

			j arithmetic_right_shift
		p0_is_1:
			bne $s2, $zero, arithmetic_right_shift

			sub $s0, $s0, $a1

			j arithmetic_right_shift
		arithmetic_right_shift:
			# LESS SIGNIFICANT BIT OF HIGH IS SAVE ON $t0
			andi $t0, $s0, 1
			# LESS SIGNIFICANT BIT OF LOW IS SAVE ON $t1
			andi $t1, $s1, 1
			# SAVE THE LESS SIGNIFICANT BIT OF LOW IN (AUXILIAR BIT)?
			add $s2, $t1, $zero

			# MAKE ARITHMETIC SHIFT ON HIGH
			sra $s0, $s0, 1
			# MAKE RIGHT LOGICAL SHIFT ON LOW 
			srl $s1, $s1, 1
			# SHIFT LEFT LOGICAL ON MOST SIGNIFICANT BIT OF HIGH
			# TO ADD IT TO THE LOW
			sll $t0, $t0, 31

			# SUM LOW WITH MOST SIGNIFICANT BIT OF HIGH
			add $s1, $s1, $t0

			addi $t3, $t3, 1
			j loop

		return:
			mthi $s0 
			mtlo $s1

			jr $ra
	main:
		jal read_integer
		add $a0, $v0, $zero

		jal read_integer
		add $a1, $v0, $zero

		jal multfac

		mfhi $a0

		jal print_integer

		mflo $a0

		jal print_integer

	exit:
		li $v0, 10
		syscall
