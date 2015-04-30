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
brand_text        db        10,13,'|      BlameCo Pianos & Organs           |$'
newline            db        10,13, '$'
divider            dd        123428
frequency        db        0
octave            db        1     ;octave detemines how to multiply and divide the input frequency
input            dw        'a','s','d','f','g','h','j','k','l','w','r','t','i','o','x',10
notes            dw        1,2,3

.code
main        proc
mov            dx,@data
mov            ds,dx
;extern        getdec:near, putdec:near
main_label:

; enable speakers
 
;call    print_ln         ; test code demonstrates that the clear_screen method works
call    print_keyboard
;call    clear_screen
;call    print_keyboard
call    print_ln
call    print_ln

play_loop:
call            get_char
mov        si,offset notes
xor        ah,ah ; input char is in al
mov        frequency,al
add        si,ax
mov        bx,[si]


mov        bh,bl
xor        bl,bl
call    play_sound

cmp        frequency,'x'
jne        play_loop

break_loop:
;mov        bx,450 ; test code to sample sounds
;call    play_sound
;mov        bx,300
;call    play_sound
;mov        bx,500
;call    play_sound
;mov        bx,800
;call    play_sound
;mov        bx,1000
;call    play_sound
;mov        bx,200
;call    play_sound

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
ret
print_keyboard endp

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
call    speakers_on
; Wait CX clock ticks
cli                             ;no interrupts

; convert a freque
d_row4    db        10,13,'| | a | s | d | f | g | h | j | k | l ||$'
info_text        db        10,13,'| x=exit    < or > =move octave        |$'
brand_text        db        10,13,'|      BlameCo Pianos & Organs           |$'
newline            db        10,13, '$'
divider            dd        123428
frequency        db        0
octave            db        1     ;octave detemines how to multiply of divide the input frequency
input            dw        'a','s','d','f','g','h','j','k','l','w','r','t','i','o','x',10
notes            dw        1,2,3

.code
main        proc
mov            dx,@data
mov            ds,dx
extern        getdec:near, putdec:near
main_label:

; enable speakers
 
;call    print_ln         ; test code demonstrates that the clear_screen method works
call    print_keyboard
;call    clear_screen
;call    print_keyboard
call    print_ln
call    print_ln

play_loop:
call    getdec
mov        si,offset notes
;cmp        ax,078h
;je        break_loop

add        si,ax
mov        bx,[si]

;mov        dl,bl
;mov        ah,02h
;int        21h
mov        bh,bl
xor        bl,bl
call    play_sound

mov        cx,'x'
cmp        [si],cx
jne        play_loop

break_loop:
;mov        bx,450 ; test code to sample sounds
;call    play_sound
;mov        bx,300
;call    play_sound
;mov        bx,500
;call    play_sound
;mov        bx,800
;call    play_sound
;mov        bx,1000
;call    play_sound
;mov        bx,200
;call    play_sound

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
ret
print_keyboard endp

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
call    speakers_on
; Wait CX clock ticks
cli                             ;no interrupts

; convert a frequency to a useable value
;push    edx
xor        edx,edx
mov        eax,divider
div     bx
mov     cx,ax
;pop        edx 

mov     al,10110110b            ;get ready byte, 181 in decimal
out     043h,al
mov     al,cl                  ;frequency divisor low byte
out     042h,al
mov     al,ch                  ;frequency  divisor high byte
out     042h,al

push ds
sti                             ;must allow clock interrupt
        
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
pop  ds
    
call    speakers_off
ret
play_sound endp
;-----------------------------------------------

clear_screen    proc
;function exists to clear the screen and allow the possibility of highlighting a key
mov        ah,02h ; set the cursor to the top left
xor        bx,bx
xor        dx,dx
int        10h

mov        ah,06h  ; clear the screen
mov        al,0fh
mov        dh,80
mov        dl,80
xor        cx,cx
int        010h
ret
clear_screen    endp

;-------------------------------------------------

get_input    proc
; get input method recieves a char from the keyboard, and returns a frequency based on an array
; needs a way to return and exit or a octave shift
ret
get_input    endp

;-------------------------------------------------
declare_frequency_array proc
mov    si,offset notes ;a
mov    cx,97
add    si,cx
mov    cx,    440
mov    [si],cx
mov    si,offset notes ;c
mov    cx,100
add    si,cx
mov    cx,    523
mov    [si],cx
mov    si,offset notes ;d
mov    cx,102
add    si,cx
mov    cx,    587
mov    [si],cx
mov    si,offset notes ;e
mov    cx,103
add    si,cx
mov    cx,    659
mov    [si],cx
mov    si,offset notes ;f
mov    cx,104
add    si,cx
mov    cx,    698
mov    [si],cx
mov    si,offset notes ;g#
mov    cx,105
add    si,cx
mov    cx,    831
mov    [si],cx
mov    si,offset notes ;g
mov    cx,106
add    si,cx
mov    cx,    784
mov    [si],cx
mov    si,offset notes ;a
mov    cx,107
add    si,cx
mov    cx,    880
mov    [si],cx
mov    si,offset notes ;b
mov    cx,108
add    si,cx
mov    cx,    988
mov    [si],cx
mov    si,offset notes ;a#
mov    cx,111
add    si,cx
mov    cx,    932
mov    [si],cx
mov    si,offset notes ;c#
mov    cx,114
add    si,cx
mov    cx,    554
mov    [si],cx
mov    si,offset notes ;b
mov    cx,115
add    si,cx
mov    cx,    494
mov    [si],cx
mov    si,offset notes  ;d#
mov    cx,116
add    si,cx
mov    cx,    622
mov    [si],cx
mov    si,offset notes  ;f#
mov    cx,117
add    si,cx
mov    cx,    740
mov    [si],cx
mov    si,offset notes ;a#
mov    cx,119
add    si,cx
mov    cx,    831
mov    [si],cx

mov    si,offset notes ;x for exit
mov    cx,'x'
add    si,cx
mov    cx,'x'
mov    [si],cx
ret
declare_frequency_array endp
end     main ; end program

