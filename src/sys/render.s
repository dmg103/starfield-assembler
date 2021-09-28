.globl man_entity_forall
.globl cpct_getScreenPtr_asm

;;Prerequirements:
;;  Hl should have a pointer to the memory direction of the entity
;;Changes a, b, c 
sys_render_one_entity:
    ld a, #0x05
        inc_hl:
        inc hl
        dec a
    jr nz, inc_hl

    ;;After inc hl five times, we are in the prevptr memory position
    ld c, (hl)
    ld a, #0x00
    sub c
    jr z, preptr_0 

    ld a, (hl)
    ld c, a
    
    inc hl 

    ld a, (hl)
    ld b, a

    ld a, #0x00
    ld (bc), a

    dec hl

    preptr_0:

    ;;Hl is now pointing to the prevptr of the entity
    ld a, #0x05
        dec_hl:
        dec hl
        dec a
    jr nz, dec_hl

    ;;Hl is now pointing towards the type of the entity
    ld a, (hl)
    ld c, #0x80
    and c
    jr nz, and_no_zero

    push hl

    ld de, #0xC000
    inc hl
    ld c, (hl)
    inc hl
    ld b, (hl)

    call cpct_getScreenPtr_asm

    ld (hl), #0x88

    ;;Bc contains now the pointer to x and y in the screen memory
    ld b, h
    ld c, l

    pop hl

    ;;After the pop hl is still pointing towards the type of the entity
    ld a, #0x05
        final_inc_hl:
        inc hl
        dec a
    jr nz, final_inc_hl

    ld (hl), c
    inc hl
    ld (hl), b

    ld a, #0x06
        final_dec_hl:
        dec hl
        dec a
    jr nz, final_dec_hl
    
    ;;After this hl is still pointing to the entity

    and_no_zero:
ret

sys_render_update::
    ld de, #sys_render_one_entity
    call man_entity_forall
ret