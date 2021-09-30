.globl _cpct_setPALColour
.globl _cpct_setVideoMode
.globl man_entity_forall
.globl cpct_getScreenPtr_asm

;;States of an entity
.globl entity_type_dead

;;Maths utilities
.globl inc_hl_number
.globl dec_hl_number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pre requirements
;;  -
;; Objetive: Initialize cpctelera render and screen settings
;; Modifies: Probably all the registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_init::
	ld l, #0x00
   	call	_cpct_setVideoMode

	;;set border
	ld hl, #0x1410
	push    hl 
	call	_cpct_setPALColour

	ld hl, #0x1400
	push    hl 
	call	_cpct_setPALColour
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pre requirements
;;  -
;; Objetive: Update the render for all the entities
;; Modifies: de
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_update::
    ld de, #sys_render_one_entity
    call man_entity_forall
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pre requirements
;;  - HL: should contain the memory direction of the entity we want to update the render
;; Objetive: Update the render for one entity
;; Modifies: a, bc, de, (hl no se si lo modifica)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_one_entity:
    
    ld a, #0x06
    call inc_hl_number

    ;;Now hl, is pointing to the prevptr (last positioin) = 00 C8 <---------
    ld a, #0x00
    ld d, (hl)
    
    ;;Check if prevptr was 0, if it wasn't we should not delete it
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

        inc hl

    to_draw:

        ;;Positioning hl at the beginning of the entity
        ld a, #0x06
        call dec_hl_number

        ;;Now, we should check if the start is dead, hl is pointing to the beginning of the entity

        ;;Type of the star
        ld a, (hl)           
        ld b, #entity_type_dead 

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
    ld a, #0x05
    call inc_hl_number

    ld (hl), c
    
    inc hl
    
    ld (hl), b

    ld a, #0x06
    call dec_hl_number

    star_dead_no_render:
ret