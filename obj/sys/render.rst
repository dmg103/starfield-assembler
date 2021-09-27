ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .globl man_entity_forall
                              2 .globl cpct_getScreenPtr_asm
                              3 
                              4 ;;Prerequirements:
                              5 ;;  Hl should have a pointer to the memory direction of the entity
                              6 ;;Changes a, b, c 
   405A                       7 sys_render_one_entity:
                              8 
                              9     ;;Pointer to the start of the screen
   405A 11 00 C0      [10]   10     ld de, #0xC000
                             11 
                             12     ;;Pos_X
   405D 23            [ 6]   13     inc hl
   405E 7E            [ 7]   14     ld a, (hl) 
   405F 4F            [ 4]   15     ld c, a
                             16 
                             17     ;;Pos_Y
   4060 23            [ 6]   18     inc hl
   4061 7E            [ 7]   19     ld a, (hl) 
   4062 47            [ 4]   20     ld b, a
                             21 
                             22     ;;Coming back to the original entity direction
   4063 2B            [ 6]   23     dec hl
   4064 2B            [ 6]   24     dec hl
                             25 
   4065 E5            [11]   26     push hl
   4066 CD 84 41      [17]   27     call cpct_getScreenPtr_asm
                             28 
   4069 36 88         [10]   29     ld (hl), #0x88
                             30 
   406B E1            [10]   31     pop hl
   406C C9            [10]   32 ret
                             33 
   406D                      34 sys_render_update::
   406D 11 5A 40      [10]   35     ld de, #sys_render_one_entity
   4070 CD D5 40      [17]   36     call man_entity_forall
   4073 C9            [10]   37 ret
