ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 
                              2 .globl cpct_memset_asm
                              3 .globl cpct_memcpy_asm
                              4 
   40B2                       5 m_entities: .ds 70 ;;Reserved memory for the entity array
   40F8 0A                    6 max_entities: .db 10 ;;Num of maximum entities
                              7 
   40F9 00                    8 m_zero_type_at_the_end: .db #0x00 ;;OJO!!
   40FA                       9 m_next_free_entity: .ds 2 ;;Reserved memory for the pointer of the next free entity
   40FC 00                   10 m_num_entities: .db 0;;Current number of entities
                             11 
   40FD 00 00                12 m_function_given_forall: .dw #0x0000 ;;Memory direction of the function that we want to execute
                             13 
                             14 ;;Creates an entitiy coping zeros in their values
                             15 ;;Intialize the pointer of the next free entity.
                             16 ;;Changes de, a, bc, hl
   40FF                      17 man_entity_init::
                             18 
                             19     ;;Filling up with zeros
   40FF 11 B2 40      [10]   20     ld de, #m_entities
   4102 3E 00         [ 7]   21     ld a, #0x00
   4104 01 46 00      [10]   22     ld bc, #70
                             23 
   4107 CD D4 41      [17]   24     call cpct_memset_asm
                             25     
                             26     ;;Next free entity should point towards m_entities
   410A 21 B2 40      [10]   27     ld hl, #m_entities
   410D 22 FA 40      [16]   28     ld (m_next_free_entity), hl
   4110 C9            [10]   29 ret
                             30     
                             31 ;;Charges into de the next free entity memory direction
                             32 ;;Changes de, bc, hl, a
   4111                      33 man_entity_create::
                             34     ;;Saving the next free memory direction of m_entities into de
   4111 ED 5B FA 40   [20]   35     ld de, (m_next_free_entity)
                             36 
   4115 01 07 00      [10]   37     ld bc, #0x0007
   4118 2A FA 40      [16]   38     ld hl, (m_next_free_entity)
                             39 
   411B F5            [11]   40     push af
                             41     ;;++m_num_entities
   411C 3A FC 40      [13]   42     ld a, (m_num_entities)
   411F 3C            [ 4]   43     inc a
   4120 32 FC 40      [13]   44     ld (m_num_entities), a
                             45 
   4123 F1            [10]   46     pop af
                             47 
   4124 09            [11]   48     add hl, bc
   4125 22 FA 40      [16]   49     ld (m_next_free_entity), hl
                             50 
   4128 C9            [10]   51 ret
                             52 
                             53 ;;Prerequirements
                             54 ;;      -DE should have the memory direction for the function given
                             55 ;;Changes a, hl, de
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   4129                      56 man_entity_forall::
   4129 21 B2 40      [10]   57     ld hl, #m_entities
                             58     ;;Keeping the function adress in a variable to use it.
   412C ED 53 FD 40   [20]   59     ld (m_function_given_forall), de
                             60 
   4130 ED 5B F8 40   [20]   61     ld de, (#max_entities) ;;OJO --> TODO: Cambiar por m_num_entities
   4134 16 00         [ 7]   62     ld d, #0x00
   4136                      63         repeat_man_entity_forall:
                             64         ;;Compare against type to know if we should continue looping -->TODO: creo que si quito este bucle igual deberia funcionar igual
   4136 7E            [ 7]   65         ld a, (hl)
   4137 C6 00         [ 7]   66         add a, #0x00 
   4139 28 15         [12]   67         jr z, entity_no_valid
                             68 
                             69         ;;Call the funcion given registered in m_function_given_forall
                             70 
   413B DD 21 47 41   [14]   71 		ld ix, #position_after_function_given
   413F DD E5         [15]   72 		push ix
                             73 
   4141 DD 2A FD 40   [20]   74 		ld ix, (#m_function_given_forall)
   4145 DD E9         [ 8]   75 		jp (ix)
                             76         
   4147                      77 		position_after_function_given:
                             78         ;;Add 5 to hl to move to the reach the next entity available
   4147 3E 07         [ 7]   79         ld a, #0x07
   4149                      80             repeat_inc_hl_forall:
   4149 23            [ 6]   81             inc hl
   414A 3D            [ 4]   82             dec a
   414B 20 FC         [12]   83         jr nz, repeat_inc_hl_forall
                             84 
                             85         ;;Decrement a to loop among the entities
   414D 1D            [ 4]   86         dec e
   414E 20 E6         [12]   87     jr nz, repeat_man_entity_forall
   4150                      88     entity_no_valid:
   4150 C9            [10]   89 ret
                             90 
                             91 ;;Prerequirements
                             92 ;;  -
                             93 ;;Updates entity manager by destroying all marked entities as dead
   4151                      94 man_entity_update::
   4151 21 B2 40      [10]   95     ld hl, #m_entities
                             96 
                             97     ;;Looping through all the actives entities
   4154 ED 5B FC 40   [20]   98     ld de, (#m_num_entities)
   4158 16 00         [ 7]   99     ld d, #0x00
   415A                     100     repeat_man_entity_update:
                            101         ;;Check if the entity is marked as dead
   415A 7E            [ 7]  102         ld a, (hl)
   415B 06 80         [ 7]  103         ld b, #0x80
   415D A0            [ 4]  104         and b
   415E 20 08         [12]  105         jr nz, destroy_dead_entity
                            106 
   4160 3E 07         [ 7]  107         ld a, #0x07
   4162                     108             repeat_inc_hl_update:
   4162 23            [ 6]  109             inc hl
   4163 3D            [ 4]  110             dec a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   4164 20 FC         [12]  111         jr nz, repeat_inc_hl_update
                            112         
   4166 18 03         [12]  113         jr continue
                            114 
   4168                     115         destroy_dead_entity:
   4168 CD 75 41      [17]  116             call man_entity_destroy
                            117 
   416B                     118         continue:
                            119 
   416B 1D            [ 4]  120         dec e
   416C 20 EC         [12]  121     jr nz, repeat_man_entity_update
                            122 
   416E C9            [10]  123 ret
                            124 
                            125 ;;Prerequirements
                            126 ;;      -HL should have the memory direction for the entity 
                            127 ;;Changes hl
   416F                     128 man_entity_set4destruction::
   416F 7E            [ 7]  129     ld a, (hl)
   4170 06 80         [ 7]  130     ld b, #0x80
                            131 
   4172 B0            [ 4]  132     or b
                            133 
                            134     ;;TOOD: ojo!! checkear aqui si hay que pasar a o b
   4173 77            [ 7]  135     ld (hl), a
   4174 C9            [10]  136 ret
                            137 
                            138 ;;Prerequirements
                            139 ;;      -HL should have the memory direction for the entity to be destroyed
                            140 ;;Changes hl
   4175                     141 man_entity_destroy:
   4175 01 FA 40      [10]  142     ld bc, #m_next_free_entity
   4178 3E 07         [ 7]  143     ld a, #0x07
   417A                     144         repeat_dec:
   417A 0B            [ 6]  145         dec bc
   417B 3D            [ 4]  146         dec a
   417C 20 FC         [12]  147     jr nz, repeat_dec
                            148 
                            149     ;;Hl contais the direction of the to be destroyed entity
                            150     ;;Bc contains the last available position -1 (-5 bytes)
                            151 
                            152     ;;Compare if bc and hl are the same
   417E 79            [ 4]  153     ld a, c
                            154 
                            155     ;;If this is = 0, the pointers are pointing to the same direction
   417F 95            [ 4]  156     sub l
   4180 28 0E         [12]  157     jr z, no_copy_memory
                            158 
                            159     ;;Coping memory in the free entity array space cause we destroy one entity
                            160     ;;Saving hl in the stack
   4182 E5            [11]  161     push hl
                            162 
   4183 54            [ 4]  163     ld d, h
   4184 5D            [ 4]  164     ld e, l
   4185 60            [ 4]  165     ld h, b
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



   4186 69            [ 4]  166     ld l, c
                            167 
                            168     ;;Saving bc in the stack
   4187 C5            [11]  169     push bc
   4188 01 07 00      [10]  170     ld bc, #0x07
                            171 
   418B CD DC 41      [17]  172     call cpct_memcpy_asm
                            173 
   418E E1            [10]  174     pop hl
   418F C1            [10]  175     pop bc
                            176 
   4190                     177     no_copy_memory:
   4190 3E 00         [ 7]  178         ld a, #0x00
   4192 02            [ 7]  179         ld (bc), a
                            180 
                            181         ;;m_next_free_entity should point one position back so
                            182         ;;ld de, #m_next_free_entity
   4193 ED 43 FA 40   [20]  183         ld (m_next_free_entity), bc
                            184 
                            185         ;;--m_num_entities
   4197 3A FC 40      [13]  186         ld a, (m_num_entities)
   419A 3D            [ 4]  187         dec a
   419B 32 FC 40      [13]  188         ld (m_num_entities), a
                            189     
   419E C9            [10]  190 ret
                            191 
                            192 
                            193 ;;Prerequirements
                            194 ;;  -
                            195 ;;Returns the number of free entities while available in the c register
                            196 ;;Changes bc, a
   419F                     197 man_entity_free_space::
   419F 3A FC 40      [13]  198     ld a, (#m_num_entities)
   41A2 ED 4B F8 40   [20]  199     ld bc, (#max_entities)
   41A6 06 00         [ 7]  200     ld b, #0x00
                            201 
   41A8 91            [ 4]  202     sub c
   41A9 C9            [10]  203 ret
                            204 
                            205 
                            206 
                            207 
