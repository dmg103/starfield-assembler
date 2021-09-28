ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .globl man_entity_forall
                              2 .globl cpct_getScreenPtr_asm
                              3 
                              4 ;;Prerequirements:
                              5 ;;  Hl should have a pointer to the memory direction of the entity
                              6 ;;Changes a, b, c 
   406A                       7 sys_render_one_entity:
   406A 3E 05         [ 7]    8     ld a, #0x05
   406C                       9         inc_hl:
   406C 23            [ 6]   10         inc hl
   406D 3D            [ 4]   11         dec a
   406E 20 FC         [12]   12     jr nz, inc_hl
                             13 
                             14     ;;After inc hl five times, we are in the prevptr memory position
   4070 4E            [ 7]   15     ld c, (hl)
   4071 3E 00         [ 7]   16     ld a, #0x00
   4073 91            [ 4]   17     sub c
   4074 28 09         [12]   18     jr z, preptr_0 
                             19 
   4076 7E            [ 7]   20     ld a, (hl)
   4077 4F            [ 4]   21     ld c, a
                             22     
   4078 23            [ 6]   23     inc hl 
                             24 
   4079 7E            [ 7]   25     ld a, (hl)
   407A 47            [ 4]   26     ld b, a
                             27 
   407B 3E 00         [ 7]   28     ld a, #0x00
   407D 02            [ 7]   29     ld (bc), a
                             30 
   407E 2B            [ 6]   31     dec hl
                             32 
   407F                      33     preptr_0:
                             34 
                             35     ;;Hl is now pointing to the prevptr of the entity
   407F 3E 05         [ 7]   36     ld a, #0x05
   4081                      37         dec_hl:
   4081 2B            [ 6]   38         dec hl
   4082 3D            [ 4]   39         dec a
   4083 20 FC         [12]   40     jr nz, dec_hl
                             41 
                             42     ;;Hl is now pointing towards the type of the entity
   4085 7E            [ 7]   43     ld a, (hl)
   4086 0E 80         [ 7]   44     ld c, #0x80
   4088 A1            [ 4]   45     and c
   4089 20 1F         [12]   46     jr nz, and_no_zero
                             47 
   408B E5            [11]   48     push hl
                             49 
   408C 11 00 C0      [10]   50     ld de, #0xC000
   408F 23            [ 6]   51     inc hl
   4090 4E            [ 7]   52     ld c, (hl)
   4091 23            [ 6]   53     inc hl
   4092 46            [ 7]   54     ld b, (hl)
                             55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   4093 CD F0 41      [17]   56     call cpct_getScreenPtr_asm
                             57 
   4096 36 88         [10]   58     ld (hl), #0x88
                             59 
                             60     ;;Bc contains now the pointer to x and y in the screen memory
   4098 44            [ 4]   61     ld b, h
   4099 4D            [ 4]   62     ld c, l
                             63 
   409A E1            [10]   64     pop hl
                             65 
                             66     ;;After the pop hl is still pointing towards the type of the entity
   409B 3E 05         [ 7]   67     ld a, #0x05
   409D                      68         final_inc_hl:
   409D 23            [ 6]   69         inc hl
   409E 3D            [ 4]   70         dec a
   409F 20 FC         [12]   71     jr nz, final_inc_hl
                             72 
   40A1 71            [ 7]   73     ld (hl), c
   40A2 23            [ 6]   74     inc hl
   40A3 70            [ 7]   75     ld (hl), b
                             76 
   40A4 3E 06         [ 7]   77     ld a, #0x06
   40A6                      78         final_dec_hl:
   40A6 2B            [ 6]   79         dec hl
   40A7 3D            [ 4]   80         dec a
   40A8 20 FC         [12]   81     jr nz, final_dec_hl
                             82     
                             83     ;;After this hl is still pointing to the entity
                             84 
   40AA                      85     and_no_zero:
   40AA C9            [10]   86 ret
                             87 
   40AB                      88 sys_render_update::
   40AB 11 6A 40      [10]   89     ld de, #sys_render_one_entity
   40AE CD 29 41      [17]   90     call man_entity_forall
   40B1 C9            [10]   91 ret
