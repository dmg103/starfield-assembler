.globl man_entity_forall
.globl cpct_getScreenPtr_asm

;;Prerequirements:
;;  Hl should have a pointer to the memory direction of the entity
;;Changes a, b, c 
sys_render_one_entity:

    ;;Pointer to the start of the screen
    ld de, #0xC000

    ;;Pos_X
    inc hl
    ld a, (hl) 
    ld c, a

    ;;Pos_Y
    inc hl
    ld a, (hl) 
    ld b, a

    ;;Coming back to the original entity direction
    dec hl
    dec hl

    push hl
    call cpct_getScreenPtr_asm

    ld (hl), #0x88

    pop hl
ret

sys_render_update::
    ld de, #sys_render_one_entity
    call man_entity_forall
ret