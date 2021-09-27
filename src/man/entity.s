
.globl cpct_memset_asm
m_entities: .ds 50
m_next_free_entity: .ds 2

max_entities: .db 10

m_function_given_forall: .dw #0x0000

;;Creates an entitiy coping zeros in their values
;;Intialize the pointer of the next free entity.
;;Changes de, a, bc, hl
man_entity_init::

    ;;Filling up with zeros
    ld de, #m_entities
    ld a, #0x00
    ld bc, #50

    call cpct_memset_asm
    
    ;;Next free entity should point towards m_entities
    ld hl, #m_entities
    ld (m_next_free_entity), hl
ret
    
;;Charges into de the next free entity memory direction
;;Changes de, bc, hl
man_entity_create::
    ;;Saving the next free memory direction of m_entities into de
    ld de, (m_next_free_entity)

    ld bc, #0x0005
    ld hl, (m_next_free_entity)
    
    add hl, bc
    ld (m_next_free_entity), hl
ret

;;Prerequirements
;;      -DE should have the memory direction for the function given
;;Changes a, hl, de
man_entity_forall::
    ld hl, #m_entities
    ;;Keeping the function adress in a variable to use it.
    ld (m_function_given_forall), de

    ld de, (#max_entities)
    ld d, #0x00
        repeat_man_entity_forall:
        ;;Compare against type to know if we should continue looping
        ld a, (hl)
        add a, #0x00 
        jr z, entity_no_valid

        ;;Call the funcion given registered in m_function_given_forall
		ld ix, #position_after_function_given
		push ix

		ld ix, (#m_function_given_forall)
		jp (ix)
		position_after_function_given:
        ;;Add 5 to hl to move to the next entitysys_physics_update_one_entity
        ld a, #0x05
            repeat_inc_hl:
            inc hl
            dec a
        jr nz, repeat_inc_hl

        ;;Decrement a to loop among the entities
        dec e
    jr nz, repeat_man_entity_forall
    entity_no_valid:
ret

