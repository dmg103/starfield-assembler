.globl man_entity_free_space
.globl man_entity_create
.globl cpct_memcpy_asm
.globl cpct_getRandom_mxor_u8_asm
.globl __moduchar

init_e:
	.db #0x01	; 1 ;type
	.db #0x4f	; 79	'O' ;pos_x
	.db #0x01	; 1	;pos_y
	.db #0xff	; -1 ;vel_x
	.db #0xff	; 255 ;color
	.dw #0x0000	;previous ptr

generate_new_star::  

    call man_entity_create

    ;;After call man_entity_create, de has the next free entity memory direction 
    push de

	ld hl, #init_e
	ld bc, #0x0007

	call cpct_memcpy_asm

    pop de

    ;;DE still has the entity memory direction

    ;;change e-> y random
	inc	de
	inc	de
	push	bc
	push	de
	call    cpct_getRandom_mxor_u8_asm
	ld	h, l
	ld	a, #0xc8
	push	af
	inc	sp
	push	hl
	inc	sp
	call	__moduchar
	pop	af
	ld	a, l
	pop	de
	pop	bc
	ld	(de), a

    ;;change e-> vx random
    inc de

    call cpct_getRandom_mxor_u8_asm

    ld a, #0x03
    and l

    ld b, #0xFE
    
    or b

    dec a

    ld (de), a 

    pop bc

ret


sys_generator_update::
    call man_entity_free_space
    ;;A contains the free space 0, 1 , 2 o >
    push af 

    dec a
    ld b, #0xFF
    sub b
    jr z, was_cero  

    pop af

    dec a
    jr z, was_one

    dec a
    jr z, was_two_or_more

    was_two_or_more:
        call generate_new_star
    was_one:
        call generate_new_star
        jr final
    was_cero:
        pop af

    final:

ret