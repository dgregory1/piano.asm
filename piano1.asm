;piano project: Steve Paytosh and Dustin Gregory
.model small
.586

.stack 100h

.data
keyboard_ledge    db        10,13,'----------------------------------------$'
keyboard_row1    db        10,13,'| |  |#|  |  |#| |#|  |  |#| |#| |#|  ||$'
keyboard_row2    db        10,13,'| |  |w|  |  |r| |t|  |  |u| |i| |o|  ||$'
keyboard_row3    db        10,13,'| | A | B | C | D | E | F | G | A | B ||$'
keyboard_row4    db        10,13,'| | a | s | d | f | g | h | j | k | l ||$'
info_text        db        10,13,'| x=exit    < or > =move octave        |$'
brand_text        db        10,13,'|      BlameCo Pianos & Organs         |$'
newline            db        10,13, '$'
;divider            dd        1234deh ;123428;
frequency        dw        0d
octave            dw        1d     ;octave detemines how to multiply and divide the input frequency
input            dw        'a','s','d','f','g','h','j','k','l','w','r','t','i','o','x'
input2            dw        0,440,494,523,587,659,698,784,880,988,466,554,622,740,831,932
notes            dw        1,2,3,4,5,6,7,8,9,10 ; 255 dup(0);1,2,3
mary_lamb        dw        1,2,3,2,1,1,1,2,2,2 ;'e','d','c','d','e','e','e','d','d','d','e','e','e'

.code
main        proc
mov            dx,@data
mov            ds,dx

main_label:
call    declare_frequency_array
call    print_keyboard

;call    play_mary
;jmp        break_loop

play_loop:
call    get_char
mov        si,offset notes
;xor        ah,ah ; input char is in al
;mov        frequency,ax  ; value of the input contained within al

; check if input was a valid input
cmp        al,'x'
je        break_loop
cmp        al,'<'
je        decrement_octave ;jump to decrement octave
cmp        al,'>'
je        increment_octave ;jump to increment octave
cmp        al, ',' 
je        decrement_octave ;jump to decrement octave
cmp        al, '.'
je        increment_octave ;jump to increment octave
    
add        si,ax
xor        ebx,ebx
mov        bx,[si]
mov        frequency,bx
call	   clear_screen
call	   print_pressed_keyboard
call       play_sound

jmp        play_loop

increment_octave:
inc        octave
jmp        play_loop
decrement_octave:
dec        octave
jmp        play_loop
break_loop:

xor        cx,cx
mov        si,offset notes


;increment_loop:
;mov        bx,[si]
;inc        frequency
;call    play_sound

;mov        ah,02h
;mov        dx,frequency
;int        21h
;inc        si
;inc        cx
;cmp        cx,40
;jl        increment_loop

mov        ah, 04ch ; needed to exit the interrupts
int        21h

main    endp ; end main proc

;=================================================
; FUNCTIONS
;=================================================

print_ln    proc
; method prints a generic new line, but saves registers
push    dx
push    cx
push    bx
push    ax
mov        dx,offset newline
call    print_out
pop        ax 
pop        bx
pop        cx
pop        dx
ret
print_ln    endp

;-----------------------------
print_out proc
; method prints out a given string, which is placed in dx
mov        ah, 09h
int        21h
ret 
print_out endp
;-----------------------------------

print_keyboard proc
; prints out a plain keboard, without showing any keys as pressed
mov        dx,offset keyboard_ledge
call    print_out
mov        dx,offset brand_text
call    print_out
mov        dx, offset info_text
call    print_out
mov        dx, offset keyboard_ledge
call    print_out
mov        dx,offset keyboard_row1
call    print_out
mov        dx,offset keyboard_row2
call    print_out
mov        dx,offset keyboard_row3
call    print_out
mov        dx,offset keyboard_row4
call    print_out
mov        dx,offset keyboard_ledge
call    print_out

call    print_ln
call    print_ln
ret
print_keyboard endp

;------------------------------------
print_pressed_keyboard proc
;prints keyboard with pressed key (in al) in different color (yellow)
;preserves registers
push	ax
push	bx
push	cx
push	dx
mov		bl, al
call    print_ln
mov        dx,offset keyboard_ledge
call    print_out
mov        dx,offset brand_text
call    print_out
mov        dx, offset info_text
call    print_out
mov        dx, offset keyboard_ledge
call    print_out

;row_1
mov		dx, offset keyboard_row1
call	print_out
call	print_ln

;row_2
mov		dl, '|'
mov		ah, 02h
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
cmp		bl, 'w'
jnz		not_w
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, 'w'
call	key_pressed
int		21h
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
jmp		not_r
not_w:
mov		dl, '|'
int		21h
mov		dl, 'w'
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
cmp		bl, 'r'
jnz		not_r
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, 'r'
call	key_pressed
int		21h
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
jmp		not_t
not_r:
mov		dl, '|'
int		21h
mov		dl, 'r'
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 't'
jnz		not_t
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, 't'
call	key_pressed
int		21h
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
jmp		not_u
not_t:
mov		dl, '|'
int		21h
mov		dl, 't'
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
int		21h
cmp		bl, 'u'
jnz		not_u
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, 'u'
call	key_pressed
int		21h
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
jmp		not_i
not_u:
mov		dl, '|'
int		21h
mov		dl, 'u'
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'i'
jnz		not_i
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, 'i'
call	key_pressed
int		21h
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
jmp		not_o
not_i:
mov		dl, '|'
int		21h
mov		dl, 'i'
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'o'
jnz		not_o
mov		dl, '|'
call	key_pressed
int		21h
mov		dl, 'o'
call	key_pressed
int		21h
mov		dl, '|'
call	key_pressed
int		21h
jmp		end_row_2
not_o:
mov		dl, '|'
int		21h
mov		dl, 'o'
int		21h
mov		dl, '|'
int		21h
end_row_2:
mov		dl, ' '
int		21h
int		21h
mov		dl, '|'
int		21h
int		21h

;row_3
mov		dx, offset keyboard_row3
call	print_out
call	print_ln

;row_4
mov		ah, 02h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'a'
jnz		not_a
mov		dl, 'a'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_s
not_a:
mov		dl, 'a'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 's'
jnz		not_s
mov		dl, 's'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_d
not_s:
mov		dl, 's'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'd'
jnz		not_d
mov		dl, 'd'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_f
not_d:
mov		dl, 'd'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'f'
jnz		not_f
mov		dl, 'f'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_g
not_f:
mov		dl, 'f'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'g'
jnz		not_g
mov		dl, 'g'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_h
not_g:
mov		dl, 'g'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'h'
jnz		not_h
mov		dl, 'h'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_j
not_h:
mov		dl, 'h'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'j'
jnz		not_j
mov		dl, 'j'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_k
not_j:
mov		dl, 'j'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'k'
jnz		not_k
mov		dl, 'k'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
jmp		not_l
not_k:
mov		dl, 'k'
int		21h
mov		dl, ' '
int		21h
mov		dl, '|'
int		21h
mov		dl, ' '
int		21h
cmp		bl, 'l'
jnz		not_l
mov		dl, 'l'
call	key_pressed
int		21h
mov		dl, ' '
int		21h
jmp		end_row_4
not_l:
mov		dl, 'l'
int		21h
mov		dl, ' '
int		21h
end_row_4:
mov		dl, '|'
int		21h
int		21h

mov     dx,offset keyboard_ledge
call    print_out

call    print_ln
call    print_ln

pop		dx
pop		cx
pop		bx
pop		ax
ret
print_pressed_keyboard endp

;-----------------------------------
key_pressed proc
;prints pressed key in yellow
;preserves registers
push	ax
push	bx
push	cx
push	dx
mov		ah, 09h
mov		bx, 0eh
mov		cx, 01h
int		10h
pop		dx
pop		cx
pop		bx
pop		ax
ret
key_pressed endp
;-----------------------------------
speakers_on proc
in      al,061h                   ;get port 61h contents
or      al,00000011b            ;enable speaker
out     061h,al
ret
speakers_on endp
;--------------------------------------
speakers_off proc
in      al,61h                   ;get port contents
and     al,11111100b            ;disable speaker
out     61h,al    
ret
speakers_off endp
;------------------------------------------

play_sound    proc
; code has issues with divide overflows
push    ax
push    bx
push    cx
push    dx
push    ds

cmp        frequency,0
je        end_play
call    speakers_on
call    speakers_off
; Wait CX clock ticks

cli                             ;no interrupts

; convert a frequency to a useable value
;push    edx
xor        edx,edx
xor        ebx,ebx
mov        ax,123428;1234deh ;divider value
mov        bx,frequency
div     bx
mov     cx,ax
;pop        edx 

xor        eax,eax
mov     al,10110110b ;00000011b            ;get ready byte, 181 in decimal
out     043h,al
mov     al,cl                  ;frequency divisor low byte
out     042h,al
mov     al,ch                  ;frequency  divisor high byte
out     042h,al

sti                             ;must allow clock interrupt
  
call    speakers_on  

mov cx,12                ; change to number in other students code        
mov ax,040h                   ;point DS to BIOS
mov es,ax
mov si,06ch        
mov ds,ax
waitlp:
mov ax,[si]              ;get low word of tick counter
wait1:  
cmp ax,[si]              ;wait for it to change
je  wait1
loop waitlp                    ;count CX changes

call    speakers_off

end_play:    
pop  ds
pop     dx
pop  cx
pop  bx
pop  ax
ret
play_sound endp
;-----------------------------------------------

clear_screen    proc
;function exists to clear the screen and allow the possibility of highlighting a key
;changed to save registers -- Dustin

push	ax
push	bx
push	cx
push	dx

;didn't seem to work with print_pressed_keyboard, just used print_ln to fill the screen instead -- Dustin
;mov        ah,06h  ; clear the screen
;mov        al,07h
;mov        dh,24
;mov        dl,79
;xor        cx,cx
;int        010h

xor		cx, cx
count:
inc		cx
call	print_ln
cmp		cx, 24
jnz		count

mov        ah,02h ; set the cursor to the top left
xor        bx,bx
xor        dx,dx
int        10h

pop		dx
pop		cx
pop		bx
pop		ax
ret
clear_screen    endp

;-------------------------------------------------


declare_frequency_array proc
mov    cx,0
mov    si,offset notes
; set the first 200 indexes to 0
clear_loop:
mov    bx,0
mov    [si],bx
inc cx
inc    si
cmp    cx,255
jne    clear_loop

; index for each frequency will be the offset plus the decimal value of each key
mov    si,offset notes ;a
mov    cx, 'a' ;97 ;a
add    si,cx
mov    cx,    1;440
mov    [si],cx
mov    si,offset notes ;c
mov    cx,'d' ;100 ;d
add    si,cx
mov    cx,2;    523
mov    [si],cx
mov    si,offset notes ;d
mov    cx, 102  ;f
add    si,cx
mov    cx,    3;587
mov    [si],cx
mov    si,offset notes ;e
mov    cx,5 ;103 ;g
add    si,cx
mov    cx,4; 659
mov    [si],cx
mov    si,offset notes ;f
mov    cx,104 ;h
add    si,cx
mov    cx,    5;698
mov    [si],cx
mov    si,offset notes ;g#
mov    cx,105 ;i
add    si,cx
mov    cx,    831
mov    [si],cx
mov    si,offset notes ;g
mov    cx,106 ;j
add    si,cx
mov    cx,    784
mov    [si],cx
mov    si,offset notes ;a
mov    cx,107 ;k
add    si,cx
mov    cx,    880
mov    [si],cx
mov    si,offset notes ;b
mov    cx,108 ;l
add    si,cx
mov    cx,    988
mov    [si],cx
mov    si,offset notes ;a#
mov    cx,111 ;o
add    si,cx
mov    cx,    932
mov    [si],cx
mov    si,offset notes ;c#
mov    cx,114 ;r
add    si,cx
mov    cx,    554
mov    [si],cx
mov    si,offset notes ;b
mov    cx,115 ;s
add    si,cx
mov    cx,    494
mov    [si],cx
mov    si,offset notes  ;d#
mov    cx,116 ;t
add    si,cx
mov    cx,    622
mov    [si],cx
mov    si,offset notes  ;f#
mov    cx,117 ;u
add    si,cx
mov    cx,    740
mov    [si],cx
mov    si,offset notes ;a#
mov    cx,119 ;w
add    si,cx
mov    cx,    831
mov    [si],cx

mov    si,offset notes ;a#
mov    cx,101 ;e
add    si,cx
mov    cx,    0
mov    [si],cx
mov    si,offset notes ;a#
mov    cx,'q' ;e
add    si,cx
mov    cx,    0
mov    [si],cx

ret
declare_frequency_array endp

;-------------------------------------------

get_char proc
mov        ah,07h
int        21h
ret
get_char endp

;---------------------------------------------

set_frequency proc
; takes a decimal input from frequency and run it through notes
ret
set_frequency endp

;----------------------------------------------

play_mary    proc
; canned song: mary has a little lamb. method helps demonstrate quality of notes played
; notes should be placed in an array
;xor        cx,cx
;mov        si,offset notes
;mary_loop:
;mov        bx,[si]
;mov        frequency,bx
;call    play_sound
;inc        si
;inc        cx
;cmp        cx,10
;jle        mary_loop

; edcdeee dddeee edcdeee eddedc
mov            frequency,7
call        play_sound
mov            frequency,2
call        play_sound
mov            frequency,4
call        play_sound
mov            frequency,2
call        play_sound
mov            frequency,7
call        play_sound
mov            frequency,7
call        play_sound
mov            frequency,7
call        play_sound


ret
play_mary     endp
end     main ; end program

