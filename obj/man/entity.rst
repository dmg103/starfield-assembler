ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 
                              2 .globl cpct_memset_asm
                              3 .globl cpct_memcpy_asm
                              4 
   4074                       5 m_entities: .ds 50 ;;Reserved memory for the entity array
   40A6 0A                    6 max_entities: .db 10 ;;Num of maximum entities
                              7 
   40A7 00                    8 m_zero_type_at_the_end: .db #0x00
   40A8                       9 m_next_free_entity: .ds 2 ;;Reserved memory for the pointer of the next free entity
   40AA 00                   10 m_num_entities: .db 0;;Current number of entities
                             11 
   40AB 00 00                12 m_function_given_forall: .dw #0x0000 ;;Memory direction of the function that we want to execute
                             13 
                             14 ;;Creates an entitiy coping zeros in their values
                             15 ;;Intialize the pointer of the next free entity.
                             16 ;;Changes de, a, bc, hl
   40AD                      17 man_entity_init::
                             18 
                             19     ;;Filling up with zeros
   40AD 11 74 40      [10]   20     ld de, #m_entities
   40B0 3E 00         [ 7]   21     ld a, #0x00
   40B2 01 32 00      [10]   22     ld bc, #50
                             23 
   40B5 CD 68 41      [17]   24     call cpct_memset_asm
                             25     
                             26     ;;Next free entity should point towards m_entities
   40B8 21 74 40      [10]   27     ld hl, #m_entities
   40BB 22 A8 40      [16]   28     ld (m_next_free_entity), hl
   40BE C9            [10]   29 ret
                             30     
                             31 ;;Charges into de the next free entity memory direction
                             32 ;;Changes de, bc, hl, a
   40BF                      33 man_entity_create::
                             34     ;;Saving the next free memory direction of m_entities into de
   40BF ED 5B A8 40   [20]   35     ld de, (m_next_free_entity)
                             36 
   40C3 01 05 00      [10]   37     ld bc, #0x0005
   40C6 2A A8 40      [16]   38     ld hl, (m_next_free_entity)
                             39 
                             40     ;;++m_num_entities
   40C9 3A AA 40      [13]   41     ld a, (m_num_entities)
   40CC 3C            [ 4]   42     inc a
   40CD 32 AA 40      [13]   43     ld (m_num_entities), a
                             44 
   40D0 09            [11]   45     add hl, bc
   40D1 22 A8 40      [16]   46     ld (m_next_free_entity), hl
                             47 
   40D4 C9            [10]   48 ret
                             49 
                             50 ;;Prerequirements
                             51 ;;      -DE should have the memory direction for the function given
                             52 ;;Changes a, hl, de
   40D5                      53 man_entity_forall::
   40D5 21 74 40      [10]   54     ld hl, #m_entities
                             55     ;;Keeping the function adress in a variable to use it.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   40D8 ED 53 AB 40   [20]   56     ld (m_function_given_forall), de
                             57 
   40DC ED 5B A6 40   [20]   58     ld de, (#max_entities) ;;OJO --> TODO: Cambiar por m_num_entities
   40E0 16 00         [ 7]   59     ld d, #0x00
   40E2                      60         repeat_man_entity_forall:
                             61         ;;Compare against type to know if we should continue looping -->TODO: creo que si quito este bucle igual deberia funcionar igual
   40E2 7E            [ 7]   62         ld a, (hl)
   40E3 C6 00         [ 7]   63         add a, #0x00 
   40E5 28 15         [12]   64         jr z, entity_no_valid
                             65 
                             66         ;;Call the funcion given registered in m_function_given_forall
   40E7 DD 21 F3 40   [14]   67 		ld ix, #position_after_function_given
   40EB DD E5         [15]   68 		push ix
                             69 
   40ED DD 2A AB 40   [20]   70 		ld ix, (#m_function_given_forall)
   40F1 DD E9         [ 8]   71 		jp (ix)
   40F3                      72 		position_after_function_given:
                             73         ;;Add 5 to hl to move to the reach the next entity available
   40F3 3E 05         [ 7]   74         ld a, #0x05
   40F5                      75             repeat_inc_hl_forall:
   40F5 23            [ 6]   76             inc hl
   40F6 3D            [ 4]   77             dec a
   40F7 20 FC         [12]   78         jr nz, repeat_inc_hl_forall
                             79 
                             80         ;;Decrement a to loop among the entities
   40F9 1D            [ 4]   81         dec e
   40FA 20 E6         [12]   82     jr nz, repeat_man_entity_forall
   40FC                      83     entity_no_valid:
   40FC C9            [10]   84 ret
                             85 
                             86 ;;Prerequirements
                             87 ;;  -
                             88 ;;Updates entity manager by destroying all marked entities as dead
   40FD                      89 man_entity_update::
   40FD 21 74 40      [10]   90     ld hl, #m_entities
                             91 
                             92     ;;Looping through all the actives entities
   4100 ED 5B AA 40   [20]   93     ld de, (#m_num_entities)
   4104 16 00         [ 7]   94     ld d, #0x00
   4106                      95     repeat_man_entity_update:
                             96         ;;Check if the entity is marked as dead
   4106 7E            [ 7]   97         ld a, (hl)
   4107 06 80         [ 7]   98         ld b, #0x80
   4109 A0            [ 4]   99         and b
   410A 20 08         [12]  100         jr nz, destroy_dead_entity
                            101 
   410C 3E 05         [ 7]  102         ld a, #0x05
   410E                     103             repeat_inc_hl_update:
   410E 23            [ 6]  104             inc hl
   410F 3D            [ 4]  105             dec a
   4110 20 FC         [12]  106         jr nz, repeat_inc_hl_update
                            107         
   4112 18 03         [12]  108         jr continue
                            109 
   4114                     110         destroy_dead_entity:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   4114 CD 21 41      [17]  111             call man_entity_destroy
                            112 
   4117                     113         continue:
                            114 
   4117 1D            [ 4]  115         dec e
   4118 20 EC         [12]  116     jr nz, repeat_man_entity_update
                            117 
   411A C9            [10]  118 ret
                            119 
                            120 ;;Prerequirements
                            121 ;;      -HL should have the memory direction for the entity 
                            122 ;;Changes hl
   411B                     123 man_entity_set4destruction::
   411B 7E            [ 7]  124     ld a, (hl)
   411C 06 80         [ 7]  125     ld b, #0x80
                            126 
   411E B0            [ 4]  127     or b
                            128 
                            129     ;;TOOD: ojo!! checkear aqui si hay que pasar a o b
   411F 77            [ 7]  130     ld (hl), a
   4120 C9            [10]  131 ret
                            132 
                            133 ;;Prerequirements
                            134 ;;      -HL should have the memory direction for the entity to be destroyed
                            135 ;;Changes hl
   4121                     136 man_entity_destroy:
   4121 01 A8 40      [10]  137     ld bc, #m_next_free_entity
   4124 3E 05         [ 7]  138     ld a, #0x05
   4126                     139         repeat_dec:
   4126 0B            [ 6]  140         dec bc
   4127 3D            [ 4]  141         dec a
   4128 20 FC         [12]  142     jr nz, repeat_dec
                            143 
                            144     ;;Hl contais the direction of the to be destroyed entity
                            145     ;;Bc contains the last available position -1 (-5 bytes)
                            146 
                            147     ;;Compare if bc and hl are the same
   412A 79            [ 4]  148     ld a, c
                            149 
                            150     ;;If this is !=0, the pointers are not pointing to the same direction
   412B 95            [ 4]  151     sub l
   412C 20 00         [12]  152     jr nz, copy_memory
                            153 
                            154     
   412E                     155     copy_memory:
                            156         ;;Saving hl in the stack
   412E E5            [11]  157         push hl
                            158 
   412F 54            [ 4]  159         ld d, h
   4130 5D            [ 4]  160         ld e, l
   4131 60            [ 4]  161         ld h, b
   4132 69            [ 4]  162         ld l, c
   4133 01 05 00      [10]  163         ld bc, #0x05
                            164 
   4136 CD 70 41      [17]  165         call cpct_memcpy_asm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                            166 
   4139 E1            [10]  167         pop hl
                            168 
                            169     
   413A C9            [10]  170 ret
                            171 
                            172 
                            173 ;;Prerequirements
                            174 ;;  -
                            175 ;;Returns the number of free entities while available in the c register
                            176 ;;Changes bc, a
   413B                     177 man_entity_free_space::
   413B 3A AA 40      [13]  178     ld a, (#m_num_entities)
   413E ED 4B A6 40   [20]  179     ld bc, (#max_entities)
   4142 06 00         [ 7]  180     ld b, #0x00
                            181 
   4144 91            [ 4]  182     sub c
   4145 C9            [10]  183 ret
                            184 
                            185 
                            186 
                            187 
