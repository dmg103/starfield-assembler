.include "cpctelera.h.s"

.area _DATA
.area _CODE

;;Manager
.globl man_entity_init
.globl man_entity_create
.globl man_entity_update

;;Cpctelera video functions
.globl _cpct_disableFirmware
.globl _cpct_setPALColour
.globl _cpct_setVideoMode
.globl _cpct_memcpy
.globl cpct_memcpy_asm
.globl cpct_waitVSYNC_asm

;;Systems
.globl sys_physics_update
.globl sys_render_update
;.globl sys_generator_update

init_e:
	.db #0x01	; 1 ;type
	.db #0x4f	; 79	'O' ;pos_x
	.db #0x01	; 1	;pos_y
	.db #0xff	; -1 ;vel_x
	.db #0xff	; 255 ;color
	.dw #0x0000	;previous ptr

create_entity:

	call man_entity_create

	;;After call man_entity_create, de has the next free entity memory direction 
	ld hl, #init_e
	ld bc, #0x0007

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
	;;OJO! esta funcion esta cambiando a por eso el buclee parece qu peta
	ld a, #0x01
		repeat:
		call create_entity
		dec a
	jr nz, repeat

game_loop:
	call sys_physics_update
	;call sys_generator_update
	call sys_render_update

	call man_entity_update
	call cpct_waitVSYNC_asm

jr game_loop


	