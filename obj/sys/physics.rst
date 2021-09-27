ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .globl man_entity_forall
                              2 
                              3 ;;Prerequirements:
                              4 ;;  Hl should have a pointer to the memory direction of the entity
                              5 ;;Changes a, bc 
   4038                       6 sys_physics_update_one_entity::
                              7 
                              8     ;;B is the current entity pos_x
   4038 23            [ 6]    9     inc hl
   4039 46            [ 7]   10     ld b, (hl)
                             11     ;;C is the current entity vel_x
   403A 23            [ 6]   12     inc hl
   403B 23            [ 6]   13     inc hl
   403C 4E            [ 7]   14     ld c, (hl)
                             15 
                             16     ;;Pos_x + Vel_x to know the new position of the entity
   403D 3E 00         [ 7]   17     ld a, #0x00
   403F 80            [ 4]   18     add a, b
   4040 81            [ 4]   19     add a, c
                             20     ;;If the sumn causes zero in a, the entity should be destroyed
   4041 28 06         [12]   21     jr z, destroy_entity ;;OJO, funciona? TODO
                             22 
                             23     ;;Coming back to the pos_x memory direction fo the entity to modify it
   4043 2B            [ 6]   24     dec hl
   4044 2B            [ 6]   25     dec hl
                             26 
   4045 77            [ 7]   27     ld (hl), a 
                             28 
   4046 2B            [ 6]   29     dec hl
                             30 
   4047 18 00         [12]   31     jr no_zero
                             32     
   4049                      33     destroy_entity:
                             34         ;;TODO: destroy
   4049                      35     no_zero:
                             36 
                             37 
   4049 C9            [10]   38 ret
                             39 
   404A                      40 sys_physics_update::
   404A 11 38 40      [10]   41     ld de, #sys_physics_update_one_entity
   404D CD AB 40      [17]   42     call man_entity_forall
                             43 
   4050 C9            [10]   44 ret
