
.globl cpct_memset_asm
.globl cpct_memcpy_asm

m_entities: .ds 50 ;;Reserved memory for the entity array
max_entities: .db 10 ;;Num of maximum entities

m_zero_type_at_the_end: .db #0x00
m_next_free_entity: .ds 2 ;;Reserved memory for the pointer of the next free entity
m_num_entities: .db 0;;Current number of entities

m_function_given_forall: .dw #0x0000 ;;Memory direction of the function that we want to execute

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
;;Changes de, bc, hl, a
man_entity_create::
    ;;Saving the next free memory direction of m_entities into de
    ld de, (m_next_free_entity)

    ld bc, #0x0005
    ld hl, (m_next_free_entity)

    ;;++m_num_entities
    ld a, (m_num_entities)
    inc a
    ld (m_num_entities), a

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

    ld de, (#max_entities) ;;OJO --> TODO: Cambiar por m_num_entities
    ld d, #0x00
        repeat_man_entity_forall:
        ;;Compare against type to know if we should continue looping -->TODO: creo que si quito este bucle igual deberia funcionar igual
        ld a, (hl)
        add a, #0x00 
        jr z, entity_no_valid

        ;;Call the funcion given registered in m_function_given_forall
		ld ix, #position_after_function_given
		push ix

		ld ix, (#m_function_given_forall)
		jp (ix)
		position_after_function_given:
        ;;Add 5 to hl to move to the reach the next entity available
        ld a, #0x05
            repeat_inc_hl_forall:
            inc hl
            dec a
        jr nz, repeat_inc_hl_forall

        ;;Decrement a to loop among the entities
        dec e
    jr nz, repeat_man_entity_forall
    entity_no_valid:
ret

;;Prerequirements
;;  -
;;Updates entity manager by destroying all marked entities as dead
man_entity_update::
    ld hl, #m_entities

    ;;Looping through all the actives entities
    ld de, (#m_num_entities)
    ld d, #0x00
    repeat_man_entity_update:
        ;;Check if the entity is marked as dead
        ld a, (hl)
        ld b, #0x80
        and b
        jr nz, destroy_dead_entity

        ld a, #0x05
            repeat_inc_hl_update:
            inc hl
            dec a
        jr nz, repeat_inc_hl_update
        
        jr continue

        destroy_dead_entity:
            call man_entity_destroy

        continue:

        dec e
    jr nz, repeat_man_entity_update

ret

;;Prerequirements
;;      -HL should have the memory direction for the entity 
;;Changes hl
man_entity_set4destruction::
    ld a, (hl)
    ld b, #0x80

    or b

    ;;TOOD: ojo!! checkear aqui si hay que pasar a o b
    ld (hl), a
ret

;;Prerequirements
;;      -HL should have the memory direction for the entity to be destroyed
;;Changes hl
man_entity_destroy:
    ld bc, #m_next_free_entity
    ld a, #0x05
        repeat_dec:
        dec bc
        dec a
    jr nz, repeat_dec

    ;;Hl contais the direction of the to be destroyed entity
    ;;Bc contains the last available position -1 (-5 bytes)

    ;;Compare if bc and hl are the same
    ld a, c

    ;;If this is !=0, the pointers are not pointing to the same direction
    sub l
    jr nz, copy_memory

    
    copy_memory:
        ;;Saving hl in the stack
        push hl

        ld d, h
        ld e, l
        ld h, b
        ld l, c
        ld bc, #0x05

        call cpct_memcpy_asm

        pop hl

    
ret


;;Prerequirements
;;  -
;;Returns the number of free entities while available in the c register
;;Changes bc, a
man_entity_free_space::
    ld a, (#m_num_entities)
    ld bc, (#max_entities)
    ld b, #0x00

    sub c
ret




