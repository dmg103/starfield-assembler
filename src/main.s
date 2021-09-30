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
.globl sys_generator_update


_main::
	;;Initialize cpctelera render setting
	call    _cpct_disableFirmware

	call man_entity_init
	
	ld l, #0x00
   	call	_cpct_setVideoMode

	;;set border
	ld hl, #0x1410
	push    hl ;;ojo
	call	_cpct_setPALColour

	ld hl, #0x1400
	push    hl ;;ojo
	call	_cpct_setPALColour

	;;TODO -> sys_render_init

game_loop:
	call sys_physics_update
	call sys_generator_update
	call sys_render_update

	call man_entity_update
	call cpct_waitVSYNC_asm

jr game_loop


	