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
   4088 38 40                 9 m_test_delete: .dw #0x4038
                             10 
                             11 ;;Creates an entitiy coping zeros in their values
                             12 ;;Intialize the pointer of the next free entity.
                             13 ;;Changes de, a, bc, hl
   408A                      14 man_entity_init::
                             15 
                             16     ;;Filling up with zeros
   408A 11 51 40      [10]   17     ld de, #m_entities
   408D 3E 00         [ 7]   18     ld a, #0x00
   408F 01 32 00      [10]   19     ld bc, #50
                             20 
   4092 CD EC 40      [17]   21     call cpct_memset_asm
                             22     
                             23     ;;Next free entity should point towards m_entities
   4095 21 51 40      [10]   24     ld hl, #m_entities
   4098 22 83 40      [16]   25     ld (m_next_free_entity), hl
   409B C9            [10]   26 ret
                             27     
                             28 ;;Charges into de the next free entity memory direction
                             29 ;;Changes de, bc, hl
   409C                      30 man_entity_create::
                             31     ;;Saving the next free memory direction of m_entities into de
   409C ED 5B 83 40   [20]   32     ld de, (m_next_free_entity)
                             33 
   40A0 01 05 00      [10]   34     ld bc, #0x0005
   40A3 2A 83 40      [16]   35     ld hl, (m_next_free_entity)
                             36     
   40A6 09            [11]   37     add hl, bc
   40A7 22 83 40      [16]   38     ld (m_next_free_entity), hl
   40AA C9            [10]   39 ret
                             40 
                             41 ;;Prerequirements
                             42 ;;      -DE should have the memory direction for the function given
                             43 ;;Changes a, hl, de
   40AB                      44 man_entity_forall::
   40AB 21 51 40      [10]   45     ld hl, #m_entities
                             46     ;;Keeping the function adress in a variable to use it.
   40AE ED 53 86 40   [20]   47     ld (m_function_given_forall), de
                             48 
   40B2 ED 5B 85 40   [20]   49     ld de, (#max_entities)
   40B6 16 00         [ 7]   50     ld d, #0x00
   40B8                      51         repeat_man_entity_forall:
                             52         ;;Compare against type to know if we should continue looping
   40B8 7E            [ 7]   53         ld a, (hl)
   40B9 C6 00         [ 7]   54         add a, #0x00 
   40BB 28 0C         [12]   55         jr z, entity_no_valid
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 
                             57         ;;Call the funcion given registered in m_function_given_forall
   40BD CD 88 40      [17]   58         call (#m_test_delete)
                             59 
                             60         ;;Add 5 to hl to move to the next entitysys_physics_update_one_entity
   40C0 3E 05         [ 7]   61         ld a, #0x05
   40C2                      62             repeat_inc_hl:
   40C2 23            [ 6]   63             inc hl
   40C3 3D            [ 4]   64             dec a
   40C4 20 FC         [12]   65         jr nz, repeat_inc_hl
                             66 
                             67         ;;Decrement a to loop among the entities
   40C6 1D            [ 4]   68         dec e
   40C7 20 EF         [12]   69     jr nz, repeat_man_entity_forall
   40C9                      70     entity_no_valid:
   40C9 C9            [10]   71 ret
                             72 
