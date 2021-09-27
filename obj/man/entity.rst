ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 
                              2 .globl cpct_memset_asm
   4051                       3 m_entities: .ds 50
   4083                       4 m_next_free_entity: .ds 2
                              5 
   4085 0A                    6 max_entities: .db 10
                              7 
   4086 00 00                 8 m_function_given_forall: .dw #0x0000
                              9 
                             10 ;;Creates an entitiy coping zeros in their values
                             11 ;;Intialize the pointer of the next free entity.
                             12 ;;Changes de, a, bc, hl
   4088                      13 man_entity_init::
                             14 
                             15     ;;Filling up with zeros
   4088 11 51 40      [10]   16     ld de, #m_entities
   408B 3E 00         [ 7]   17     ld a, #0x00
   408D 01 32 00      [10]   18     ld bc, #50
                             19 
   4090 CD F3 40      [17]   20     call cpct_memset_asm
                             21     
                             22     ;;Next free entity should point towards m_entities
   4093 21 51 40      [10]   23     ld hl, #m_entities
   4096 22 83 40      [16]   24     ld (m_next_free_entity), hl
   4099 C9            [10]   25 ret
                             26     
                             27 ;;Charges into de the next free entity memory direction
                             28 ;;Changes de, bc, hl
   409A                      29 man_entity_create::
                             30     ;;Saving the next free memory direction of m_entities into de
   409A ED 5B 83 40   [20]   31     ld de, (m_next_free_entity)
                             32 
   409E 01 05 00      [10]   33     ld bc, #0x0005
   40A1 2A 83 40      [16]   34     ld hl, (m_next_free_entity)
                             35     
   40A4 09            [11]   36     add hl, bc
   40A5 22 83 40      [16]   37     ld (m_next_free_entity), hl
   40A8 C9            [10]   38 ret
                             39 
                             40 ;;Prerequirements
                             41 ;;      -DE should have the memory direction for the function given
                             42 ;;Changes a, hl, de
   40A9                      43 man_entity_forall::
   40A9 21 51 40      [10]   44     ld hl, #m_entities
                             45     ;;Keeping the function adress in a variable to use it.
   40AC ED 53 86 40   [20]   46     ld (m_function_given_forall), de
                             47 
   40B0 ED 5B 85 40   [20]   48     ld de, (#max_entities)
   40B4 16 00         [ 7]   49     ld d, #0x00
   40B6                      50         repeat_man_entity_forall:
                             51         ;;Compare against type to know if we should continue looping
   40B6 7E            [ 7]   52         ld a, (hl)
   40B7 C6 00         [ 7]   53         add a, #0x00 
   40B9 28 15         [12]   54         jr z, entity_no_valid
                             55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56         ;;Call the funcion given registered in m_function_given_forall
   40BB DD 21 C7 40   [14]   57 		ld ix, #position_after_function_given
   40BF DD E5         [15]   58 		push ix
                             59 
   40C1 DD 2A 86 40   [20]   60 		ld ix, (#m_function_given_forall)
   40C5 DD E9         [ 8]   61 		jp (ix)
   40C7                      62 		position_after_function_given:
                             63         ;;Add 5 to hl to move to the next entitysys_physics_update_one_entity
   40C7 3E 05         [ 7]   64         ld a, #0x05
   40C9                      65             repeat_inc_hl:
   40C9 23            [ 6]   66             inc hl
   40CA 3D            [ 4]   67             dec a
   40CB 20 FC         [12]   68         jr nz, repeat_inc_hl
                             69 
                             70         ;;Decrement a to loop among the entities
   40CD 1D            [ 4]   71         dec e
   40CE 20 E6         [12]   72     jr nz, repeat_man_entity_forall
   40D0                      73     entity_no_valid:
   40D0 C9            [10]   74 ret
                             75 
