.include "cpctelera.h.s"

.area _DATA
.area _CODE

;;Manager
.globl man_entity_init
.globl man_entity_create

;;Cpctelera video functions
.globl _cpct_disableFirmware
.globl _cpct_setPALColour
.globl _cpct_setVideoMode
.globl _cpct_memcpy
.globl cpct_memcpy_asm

;;Systems
.globl sys_physics_update

init_e:
	.db #0x01	; 1 ;type
	.db #0x4f	; 79	'O' ;pos_x
	.db #0x01	; 1	;pos_y
	.db #0xff	; -1 ;vel_x
	.db #0xff	; 255 ;color

create_entity:

	call man_entity_create

	;;After call man_entity_create, de has the next free entity memory direction 

	ld hl, #init_e
	ld bc, #0x0005

	call cpct_memcpy_asm
ret

_main::
	;;Initialize cpctelera render setting
	call    _cpct_disableFirmware

	ld l, #0x00
   	call	_cpct_setVideoMode

	;;set border
	ld hl, #0x1410
	push    hl ;;ojo
	call	_cpct_setPALColour

	ld hl, #0x1400
	push    hl ;;ojo
	call	_cpct_setPALColour

	call man_entity_init

	;;Creates a register value entities
	ld a, #0x05
		repeat:
		call create_entity
		dec a
	jr nz, repeat

	call sys_physics_update

	jr .


	