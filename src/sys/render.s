.globl man_entity_forall
.globl cpct_getScreenPtr_asm
.globl entity_dead

;;Prerequirements:
;;  Hl should have a pointer to the memory direction of the entity
;;Changes a, b, c 
sys_render_one_entity:
    
    ld de, #0x06
    add hl, de

    ;;Now hl, is pointing to the prevptr (last positioin) = 00 C8 <---------
    ld a, #0x00
    ld d, (hl)

    sub d

    jr nz, to_erase

    jr to_draw

    to_erase:
        ld b, (hl)
        dec hl
        ld c, (hl)

        ;;Now, de is the prevptr DE = C8 00, erase the last draw
        ld a, #0x00
        ld (bc), a 
        ;;Positioning hl at the beginning of the entity
        inc hl

    to_draw:

        dec hl
        dec hl
        dec hl
        dec hl
        dec hl
        dec hl

        ;;Now, we should check if the start is dead, hl is pointing to the beginning of the entity
        ld a, (hl) ;;Type of the star
        ld b, #entity_dead 

        and b
        
        jr nz, star_dead_no_render


    ;;The star is alive, we should render it
    ld de, #0xC000

    inc hl
    ld c, (hl)
    inc hl
    ld b, (hl)
    dec hl
    dec hl

    push hl

    call cpct_getScreenPtr_asm

    ld (hl), #0x88
    
    ld c, l
    ld b, h

    pop hl

    ;;Now we have, BC with new prevptr, and HL is pointing to the beginnning of the entity (type)
    ld de, #0x05
    add hl, de

    ld (hl), c
    
    inc hl
    
    ld (hl), b

    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl

    star_dead_no_render:

ret

sys_render_update::
    ld de, #sys_render_one_entity
    call man_entity_forall
ret