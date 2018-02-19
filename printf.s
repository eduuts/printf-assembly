#string to be printed
text:
     .ascii "My name is edu. I think I’ll get a %d for my exam. What does %r do? And %%?\n"
#save the size of the string in STR_SIZE
pstr_end:
     .set STR_SIZE, pstr_end - text

eduard:
     .ascii "edu\0"

.text

.global main

#the custom printf subroutine
eduprintf:			

#this loop goes through each char for the string, 
loop1:	
	cmpb  $0x25, (%rsi) 	#check if the char to be ouputted is %
	je format		#if it is %, jump to format, to see if the given format is supported
				#else it just prints the character

#normal output	
output:	
	movq $1, %rdx		#print just the first char from the string
	movq $1, %rdi		#output to stdout
	movq $1, %rax		#syscall nr for outputting
	
	syscall

	dec %r12		#r12 had the initial value of STR_SIZE,
				#and after each char being decremented, keeping the number
				#of chars remaining in the string
	inc %rsi		#make rsi point to the next char in string
	cmp $0, %r12            #if r12 is still greater than 0, repeat loop,
				#else end the subroutine           
	jg loop1
	popq %r13
	popq %r12
	jmp end
format:
#check if the next char after the % is:
	cmpb $0x75, 1(%rsi) 	# u for unsigned
	je unsigned

	cmpb $0x64, 1(%rsi)	# d for signed
	je signed

	cmpb $0x73, 1(%rsi)	# s for string
	je string

	cmpb $0x25, 1(%rsi)	# or # for just outputting an '#'
	je hashtag	
	
	jmp output		#if it's none of the above, output normally



unsigned:
	movq %rsi, %r14		#save the address of the main string 

	movq $322, %rax		#VALUE FOR UNSIGNED---------------------------------------
	xorq %r13, %r13		#decimals count
loopie:
	inc %r13
	cmpq $9, %rax		#if value is bigger than 9, it has to be split into one decimal hexa numbers
	jg bigger
	push %rax
	jmp loopie2
bigger:	
	movq $10, %r15		#we divide the number by 10, and push the modullo into stack for later use
	xorq %rdx, %rdx
	divq %r15		#and we do it until rax is <= than 9
	push %rdx

	jmp loopie
	
loopie2:
	cmpq $0, %r13		#now we pop from stack and output decimal by decimal
	je enduns
	popq %r8
	addq $0x30,%r8		#value has to be hexa, so we add 0x30
	
	push %rbp
	movq %rsp, %rbp
				#rsi needs an adress, not a specific character,
				#so we make it point to the adress in the stack
				#which has the number in it
	subq $8, %rsp	
	movq %r8, -4(%rbp)
	leaq -4(%rbp), %rsi
	popq %rbp
	addq $8, %rsp
	movq $1, %rax
	movq $1, %rdx
	movq $1, %rdi
	syscall			#syscall for printing the decimal
			
	dec %r13		#decrement counter
	jmp loopie2
enduns:
	movq %r14, %rsi		#restore the adress of the main string back into rsi
	dec %r12		#we used two chars from the string, so dec the counter
				#by 2,and increment the adress to point to the next
				#characters
	dec %r12
	inc %rsi
	inc %rsi
	jmp loop1


signed:
	movq %rsi, %r14		#save the adress of the main string
	
	movq $-322, %rax	#rax now holds a negative number
				#-------------------------------------------value for signed
	xorq %r13, %r13
loopies:
	inc %r13		
	cmpq $0, %rax		#if rax is negative, we jump to negative
	jb skip
				#negative first outputs an '-'
				#then reverses rax
				#number is afterwards processed just like the unsigned one
negative:
	movq $0x2D,%r8
	push %rbp
	movq %rsp, %rbp
				
	sub $8, %rsp
	movq %rax, %r15	
	movq %r8, -4(%rbp)
	lea -4(%rbp), %rsi
	popq %rbp
	
	addq $8, %rsp
	movq $1, %rax
	movq $1, %rdx
	movq $1, %rdi
	syscall
	
	movq %r15, %rax
	negq %rax
skip:	
	cmpq $9, %rax
	jg bigger
	push %rax
	jmp loopie2s
biggers:
	movq $10, %r15
	xorq %rdx, %rdx
	divq %r15
	push %rdx

	jmp loopies
	
loopie2s:
	cmpq $0, %r13
	je ends
	popq %r8
	addq $0x30,%r8
	push %rbp
	movq %rsp, %rbp
	sub $8, %rsp		#rsi needs an adress, not a specific character,
				#so we make it point to the adress in the stack
	movq %rax, %r11			#which has the '#' in it
	movq %r8, -4(%rbp)
	lea -4(%rbp), %rsi
	popq %rbp
	addq $8, %rsp
	movq $1, %rax
	movq $1, %rdx
	movq $1, %rdi
	syscall

	movq %r11, %rax
	dec %r13
	jmp loopie2s
ends:
	movq %r14, %rsi
	dec %r12		
	dec %r12
	inc %rsi
	inc %rsi
	jmp loop1


string:

	movq %rsi, %r14	
				#first saving the adress of the string in r14
				#r13 holds the string parameter
	movq %r13, %rsi
loop2:
	cmpb $0x00 ,(%rsi)	#check if the first char from the string to be outputted
				#is NUL
	je endstring
	movq $1, %rax		#if it isn't NUL, we follow the same patters as for the 
				#original string: output char one by one, until NUL
	movq $1, %rdx
	movq $1, %rdi
	syscall
	inc %rsi
	jmp loop2
endstring:
	movq %r14, %rsi		#make rsi point back to the first string
	dec %r12		# we used two characters from the string (%s),
				# so we decrement the number of the remaining
				# chars by 2
	dec %r12
	inc %rsi		
	inc %rsi
	jmp loop1
hashtag:
	movq %rsi, %r14
	push %rbp
	movq %rsp, %rbp
	sub $4, %rsp		#rsi needs an adress, not a specific character,
				#so we make it point to the adress in the stack
				#which has the '#' in it
	movq $0x25, -4(%rbp)
	lea -4(%rbp), %rsi
	movq $1, %rax
	movq $1, %rdx
	movq $1, %rdi
	syscall
	movq %r14, %rsi
	dec %r12
	dec %r12
	inc %rsi
	inc %rsi
	jmp loop1

main:
	
	push %r12		#store temporary registers that need to be restored
	push %r13
	movq $STR_SIZE, %r12    #make %r12 keep the count of the remaining chars
	movq $text, %rsi	#make rsi point to the input string
	movq $0, %r9		#param count
	movq $eduard, %r13 	#first parameter
	
	call eduprintf
end: 
	movq $0, %rdi
	call exit
