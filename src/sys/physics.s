.globl man_entity_forall
.globl man_entity_destroy
.globl man_entity_set4destruction

;;Prerequirements:
;;  Hl should have a pointer to the memory direction of the entity
;;Changes a, bc 
sys_physics_update_one_entity::

    ;;B is the current entity pos_x
    inc hl
    ld b, (hl)
    ;;C is the current entity vel_x
    inc hl
    inc hl
    ld c, (hl)

    ;;Pos_x + Vel_x to know the new position of the entity
    ld a, #0x00
    add a, b
    add a, c
    ;;If the sumn causes zero in a, the entity should be destroyed
    jr z, destroy_entity ;;OJO, funciona? TODO

    ;;Coming back to the pos_x memory direction fo the entity to modify it
    dec hl
    dec hl

    ld (hl), a 

    dec hl

    jr no_zero
    
    destroy_entity:
        dec hl
        dec hl
        dec hl
        call man_entity_destroy
    no_zero:

ret

sys_physics_update::
    ld de, #sys_physics_update_one_entity
    call man_entity_forall

ret