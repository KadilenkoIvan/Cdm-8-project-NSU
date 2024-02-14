#inputs
asect 0xf1
vxy:
asect 0xf2
ball_x:
asect 0xf3
ball_y:

#output
asect 0xf4
output:

asect 0x00


#FOR TEST
#ldi r0, ball_x
#ldi r1, 15
#st r0, r1
#ldi r0, ball_y
#ldi r1, 80
#st r0, r1
#ldi r0, vxy
#ldi r1, 0b00101010
#st r0, r1
#FOR TERST
 
main:
	
	ldi r1, vxy
	ld r1, r1
	ldi r0, 0b00000100
	if #checking the direction of the ball X
		and r0, r1
	is z
		ldi r1, ball_x
		ld r1, r1
		ldi r0, 208
		sub r0, r1 # 208 - x
		
		shr r1
		ldi r0, 0b01111111
		and r0, r1 # (208 - x) / 2
		move r1, r0 # res in r0
		
		ldi r1, vxy
		ld r1, r1
		shr r1
		shr r1
		shr r1
		ldi r2, 0b00000111
		and r2, r1 #vY in r1
	
		ldi r2, 0b00000100 #check more or less that 0
		if
			and r1, r2
		is z #vY >= 0
			ldi r2, ball_y
			ld r2, r2
			ldi r3, 0 #correction
			sub r2, r3
			move r3, r2
			ldi r3, 0 #count of C
			while
				tst r1
			stays gt
				if
					add r0, r2
				is cs
					inc r3
				fi
				dec r1
			wend
			move r2, r0 #y + (208 - x) / 2 * vY (for possitive vX) IN r0
		else #vY < 0
			neg r1
			ldi r2, 0b00000111
			and r2, r1
			
			ldi r2, ball_y
			ld r2, r2
			ldi r3, 0 #correction
			sub r3, r2
			
			ldi r3, 0 #count of C
			while
				tst r1
			stays gt
				if
					add r0, r2 
				is cs
					inc r3
				fi
				dec r1
			wend
			ldi r1, 0
			sub r1, r2
			move r2, r0 #y + (208 - x) / 2 * vY (for negative vY) IN r0
		fi
		
		#Carry check
		ldi r1, 1
		if
			and r1, r3
		is nz
			ldi r1, 0
			sub r1, r0
		fi
		#Carry check
		
		ldi r1, output
		st r1, r0 #res in output
	fi
br main

halt
end