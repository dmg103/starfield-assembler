ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .globl man_entity_forall
                              2 .globl man_entity_destroy
                              3 .globl man_entity_set4destruction
                              4 
                              5 ;;Prerequirements:
                              6 ;;  Hl should have a pointer to the memory direction of the entity
                              7 ;;Changes a, bc 
   403B                       8 sys_physics_update_one_entity::
                              9 
                             10     ;;B is the current entity pos_x
   403B 23            [ 6]   11     inc hl
   403C 46            [ 7]   12     ld b, (hl)
                             13     ;;C is the current entity vel_x
   403D 23            [ 6]   14     inc hl
   403E 23            [ 6]   15     inc hl
   403F 4E            [ 7]   16     ld c, (hl)
                             17 
                             18     ;;Pos_x + Vel_x to know the new position of the entity
   4040 3E 00         [ 7]   19     ld a, #0x00
   4042 80            [ 4]   20     add a, b
   4043 81            [ 4]   21     add a, c
                             22     ;;If the sumn causes zero in a, the entity should be destroyed
   4044 28 06         [12]   23     jr z, destroy_entity ;;OJO, funciona? TODO
                             24 
                             25     ;;Coming back to the pos_x memory direction fo the entity to modify it
   4046 2B            [ 6]   26     dec hl
   4047 2B            [ 6]   27     dec hl
                             28 
   4048 77            [ 7]   29     ld (hl), a 
                             30 
   4049 2B            [ 6]   31     dec hl
                             32 
   404A 18 06         [12]   33     jr no_zero
                             34     
   404C                      35     destroy_entity:
   404C 2B            [ 6]   36         dec hl
   404D 2B            [ 6]   37         dec hl
   404E 2B            [ 6]   38         dec hl
   404F CD 21 41      [17]   39         call man_entity_destroy
   4052                      40     no_zero:
                             41 
   4052 C9            [10]   42 ret
                             43 
   4053                      44 sys_physics_update::
   4053 11 3B 40      [10]   45     ld de, #sys_physics_update_one_entity
   4056 CD D5 40      [17]   46     call man_entity_forall
                             47 
   4059 C9            [10]   48 ret
