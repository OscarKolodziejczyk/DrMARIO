################# CSC258 Assembly Final Project ###################
# This file contains my implementation of Dr Mario.
#
# Student 1: Oscar Kolodziejczyk, 1009128132
#
# I assert that the code submitted here is entirely my own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       16
# - Unit height in pixels:      16
# - Display width in pixels:    512
# - Display height in pixels:   512
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
PURPLE_COLOR:
    .word 0x301934
RED_COLOR:
    .word 0xdb294e
BLUE_COLOR:
    .word 0x0050f1
GOLD_COLOR:
    .word 0xffd700
WHITE_COLOR:
  .word 0xffffff
DARK_RED_COLOR:
    .word 0x790909


##############################################################################
# Mutable Data
##############################################################################

virus_array:
    .word 0:7 # Stores 7 32-bit elements all with value 0 for 6 possible viruses, when we hit 0, we know we're at the end of the array
virus_count:
    .word 5   # Number of viruses that will spawn
              # Easy -> 4
              # Medium -> 5
              # Hard -> 6

pill_array:
  .word 1:100 # Stores the pills, so we can tell the other half of the pill to drop once it has been split (Set to have the value of 1 at the end of the array)
              # Stored in such a way: [0, pixel1, pixel2, 0, pill2_pxl1, pill2_pxl1, 0, 1]


temp_var_1: # Temporary variable to store register values when using functions
    .word 0

temp_var_2: # Temporary variable 2
    .word 0
temp_var_3: # Temporary variable 2
    .word 0
temp_var_4: # Temporary variable 2
    .word 0

    
temp_var_array: # Stores an array of temporary variables to maintain values while using functions.
    .word 0:100
temp_var_counter:
    .word 0


gravity_counter: # Stores the counter that increments every frame, that checks against 'gravity_speed' to see if we need to perform gravity
    .word 0
    
gravity_speed: # Stores the number which the gravity_counter needs to reach to perform gravity.
    .word 30   
               # Easy difficulty 45 (Starts at 1.5 seconds)
               # Normal difficulty 30 (Starts at aproximately 1 block down per second)
               # Hard difficulty 15 (Starts at 0.5 seconds)


gravity_speed_increase_counter:
      .word 0
gravity_speed_increase_checker:
      .word 150 # Determines how fast the gravity speed increases

               # Easy difficulty 210 (increases every 7 seconds)
               # Normal difficulty 150 (increases every 5 seconds)
               # Hard difficulty 90 (increases every 3 seconds)

difficulty:
      .word 1 # 0 -> Easy
              # 1 -> Medium
              # 2 -> Hard























##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.

start_screen:


  # Here we draw the starting screen:

    lw $t0, ADDR_DSPL # Sets display address to Register 0

    lw $s2, WHITE_COLOR
    lw $s3, GOLD_COLOR
    lw $s4, BLUE_COLOR
    lw $s5, RED_COLOR

    # Draw the background Pill:

    add $t1, $zero, $zero # $t1 will be used as a counter 
    addi $t2, $zero, 16 # Need to color 16 across each row
    add $t3, $zero, $zero # Outer loop counter
    addi $t4, $zero, 7 # Neeed to colour 7 rows

    # Initialize starting coloring position:
      addi $t0, $t0, -64
    
    blue_loop_outer:
      beq $t3, $t4, blue_exit

      addi $t3, $t3, 1 # Increment counter
      addi $t0, $t0, 64 # Go to next row
      add $t1, $zero, $zero # reset inner loop counter 

      blue_loop_inner:
        
      beq $t1, $t2, blue_loop_outer

      sw $s4, 0($t0)
      addi $t0, $t0, 4 # Go to next pixel to the right

      addi $t1, $t1, 1 # Increment counter

      j blue_loop_inner


      blue_exit:

      # reset $t0:
      lw $t0, ADDR_DSPL

      # Prep for red coloring:

      add $t1, $zero, $zero # $t1 will be used as a counter 
      addi $t2, $zero, 16 # Need to color 16 across each row
      add $t3, $zero, $zero # Outer loop counter
      addi $t4, $zero, 7 # Neeed to colour 7 rows

      red_loop_outer:
      beq $t3, $t4, red_exit

      addi $t3, $t3, 1 # Increment counter
      addi $t0, $t0, 64 # Go to next row
      add $t1, $zero, $zero # reset inner loop counter 

      red_loop_inner:
        
      beq $t1, $t2, red_loop_outer

      sw $s5, 0($t0)
      addi $t0, $t0, 4 # Go to next pixel to the right

      addi $t1, $t1, 1 # Increment counter

      j red_loop_inner


      red_exit:


      # reset $t0:
      lw $t0, ADDR_DSPL

      # Draw corners of pill:

      sw $0, 0($t0)
      sw $0, 124($t0)
      sw $0, 768($t0)
      sw $0, 892($t0)
      
      # Now draw text manually:

      # Dr. MARIO:

      #D
      sw $s3, 132($t0)
      sw $s3, 136($t0)
      sw $s3, 140($t0)
      sw $s3, 260($t0)
      sw $s3, 388($t0)
      sw $s3, 516($t0)
      sw $s3, 644($t0)
      sw $s3, 648($t0)
      sw $s3, 652($t0)
      sw $s3, 272($t0)
      sw $s3, 400($t0)
      sw $s3, 528($t0)

      #r.
      sw $s3, 408($t0)
      sw $s3, 412($t0)
      sw $s3, 536($t0)
      sw $s3, 664($t0)
      sw $s3, 672($t0)

      #M 
      sw $s3, 168($t0)
      sw $s3, 296($t0)
      sw $s3, 424($t0)
      sw $s3, 552($t0)
      sw $s3, 680($t0)
      sw $s3, 300($t0)
      sw $s3, 432($t0)
      sw $s3, 308($t0)
      sw $s3, 184($t0)
      sw $s3, 312($t0)
      sw $s3, 440($t0)
      sw $s3, 568($t0)
      sw $s3, 696($t0)

      #A
      sw $s3, 192($t0)
      sw $s3, 196($t0)
      sw $s3, 200($t0)
      sw $s3, 320($t0)
      sw $s3, 448($t0)
      sw $s3, 452($t0)
      sw $s3, 576($t0)
      sw $s3, 704($t0)
      sw $s3, 328($t0)
      sw $s3, 456($t0)
      sw $s3, 584($t0)
      sw $s3, 712($t0)

      #R 
      sw $s3, 208($t0)
      sw $s3, 212($t0)
      sw $s3, 216($t0)
      sw $s3, 720($t0)
      sw $s3, 336($t0)
      sw $s3, 344($t0)
      sw $s3, 464($t0)
      sw $s3, 468($t0)
      sw $s3, 592($t0)
      sw $s3, 600($t0)
      sw $s3, 720($t0)
      sw $s3, 728($t0)

      #I 
      sw $s3, 224($t0)
      sw $s3, 228($t0)
      sw $s3, 232($t0)
      sw $s3, 356($t0)
      sw $s3, 484($t0)
      sw $s3, 612($t0)
      sw $s3, 736($t0)
      sw $s3, 740($t0)
      sw $s3, 744($t0)
      

      #O 
      sw $s3, 244($t0)
      sw $s3, 368($t0)
      sw $s3, 376($t0)
      sw $s3, 496($t0)
      sw $s3, 504($t0)
      sw $s3, 624($t0)
      sw $s3, 632($t0)
      sw $s3, 756($t0)

      # EASY:

        sw $s2, 1184($t0)
        sw $s2, 1188($t0)
        sw $s2, 1192($t0)
        sw $s2, 1204($t0)
        sw $s2, 1208($t0)
        sw $s2, 1220($t0)
        sw $s2, 1224($t0)
        sw $s2, 1228($t0)
        sw $s2, 1232($t0)
        sw $s2, 1240($t0)
        sw $s2, 1248($t0)

        sw $s2, 1312($t0)
        sw $s2, 1328($t0)
        sw $s2, 1340($t0)
        sw $s2, 1348($t0)
        sw $s2, 1368($t0)
        sw $s2, 1376($t0)

        sw $s2, 1440($t0)
        sw $s2, 1444($t0)
        sw $s2, 1448($t0)
        sw $s2, 1456($t0)
        sw $s2, 1460($t0)
        sw $s2, 1464($t0)
        sw $s2, 1468($t0)
        sw $s2, 1476($t0)
        sw $s2, 1480($t0)
        sw $s2, 1484($t0)
        sw $s2, 1488($t0)
        sw $s2, 1496($t0)
        sw $s2, 1504($t0)

        sw $s2, 1568($t0)
        sw $s2, 1584($t0)
        sw $s2, 1596($t0)
        sw $s2, 1616($t0)
        sw $s2, 1628($t0)

        sw $s2, 1696($t0)
        sw $s2, 1700($t0)
        sw $s2, 1704($t0)
        sw $s2, 1712($t0)
        sw $s2, 1724($t0)
        sw $s2, 1732($t0)
        sw $s2, 1736($t0)
        sw $s2, 1740($t0)
        sw $s2, 1744($t0)
        sw $s2, 1756($t0)

        # MEDIUM:
        
        sw $s2, 2184($t0)
        sw $s2, 2200($t0)
        sw $s2, 2208($t0)
        sw $s2, 2212($t0)
        sw $s2, 2216($t0)
        sw $s2, 2224($t0)
        sw $s2, 2228($t0)
        sw $s2, 2232($t0)
        sw $s2, 2244($t0)
        sw $s2, 2248($t0)
        sw $s2, 2252($t0)
        sw $s2, 2260($t0)
        sw $s2, 2268($t0)
        sw $s2, 2276($t0)
        sw $s2, 2292($t0)

        sw $s2, 2312($t0)
        sw $s2, 2316($t0)
        sw $s2, 2324($t0)
        sw $s2, 2328($t0)
        sw $s2, 2336($t0)
        sw $s2, 2352($t0)
        sw $s2, 2364($t0)
        sw $s2, 2376($t0)
        sw $s2, 2388($t0)
        sw $s2, 2396($t0)
        sw $s2, 2404($t0)
        sw $s2, 2408($t0)
        sw $s2, 2416($t0)
        sw $s2, 2420($t0)

        sw $s2, 2440($t0)
        sw $s2, 2448($t0)
        sw $s2, 2456($t0)
        sw $s2, 2464($t0)
        sw $s2, 2468($t0)
        sw $s2, 2472($t0)
        sw $s2, 2480($t0)
        sw $s2, 2492($t0)
        sw $s2, 2504($t0)
        sw $s2, 2516($t0)
        sw $s2, 2524($t0)
        sw $s2, 2532($t0)
        sw $s2, 2540($t0)
        sw $s2, 2548($t0)

        sw $s2, 2568($t0)
        sw $s2, 2584($t0)
        sw $s2, 2592($t0)
        sw $s2, 2608($t0)
        sw $s2, 2620($t0)
        sw $s2, 2632($t0)
        sw $s2, 2644($t0)
        sw $s2, 2652($t0)
        sw $s2, 2660($t0)
        sw $s2, 2676($t0)

        sw $s2, 2696($t0)
        sw $s2, 2712($t0)
        sw $s2, 2720($t0)
        sw $s2, 2724($t0)
        sw $s2, 2728($t0)
        sw $s2, 2736($t0)
        sw $s2, 2740($t0)
        sw $s2, 2744($t0)
        sw $s2, 2756($t0)
        sw $s2, 2760($t0)
        sw $s2, 2764($t0)
        sw $s2, 2772($t0)
        sw $s2, 2776($t0)
        sw $s2, 2780($t0)
        sw $s2, 2788($t0)
        sw $s2, 2804($t0)

        # HARD:

        sw $s2, 3232($t0)
        sw $s2, 3244($t0)
        sw $s2, 3256($t0)
        sw $s2, 3260($t0)
        sw $s2, 3272($t0)
        sw $s2, 3276($t0)
        sw $s2, 3280($t0)
        sw $s2, 3288($t0)
        sw $s2, 3292($t0)
        sw $s2, 3296($t0)

        sw $s2, 3360($t0)
        sw $s2, 3372($t0)
        sw $s2, 3380($t0)
        sw $s2, 3392($t0)
        sw $s2, 3400($t0)
        sw $s2, 3408($t0)
        sw $s2, 3416($t0)
        sw $s2, 3428($t0)

        sw $s2, 3488($t0)
        sw $s2, 3492($t0)
        sw $s2, 3496($t0)
        sw $s2, 3500($t0)
        sw $s2, 3508($t0)
        sw $s2, 3512($t0)
        sw $s2, 3516($t0)
        sw $s2, 3520($t0)
        sw $s2, 3528($t0)
        sw $s2, 3532($t0)
        sw $s2, 3544($t0)
        sw $s2, 3556($t0)

        sw $s2, 3616($t0)
        sw $s2, 3628($t0)
        sw $s2, 3636($t0)
        sw $s2, 3648($t0)
        sw $s2, 3656($t0)
        sw $s2, 3664($t0)
        sw $s2, 3672($t0)
        sw $s2, 3684($t0)

        sw $s2, 3744($t0)
        sw $s2, 3756($t0)
        sw $s2, 3764($t0)
        sw $s2, 3776($t0)
        sw $s2, 3784($t0)
        sw $s2, 3792($t0)
        sw $s2, 3800($t0)
        sw $s2, 3804($t0)
        sw $s2, 3808($t0)

        # Medium Select Overlay:
        
        sw $s3, 1924($t0)
        sw $s3, 1928($t0)
        sw $s3, 1932($t0)
        sw $s3, 1936($t0)
        sw $s3, 1940($t0)
        sw $s3, 1944($t0)
        sw $s3, 1948($t0)
        sw $s3, 1952($t0)
        sw $s3, 1956($t0)
        sw $s3, 1960($t0)
        sw $s3, 1964($t0)
        sw $s3, 1968($t0)
        sw $s3, 1972($t0)
        sw $s3, 1976($t0)
        sw $s3, 1980($t0)
        sw $s3, 1984($t0)
        sw $s3, 1988($t0)
        sw $s3, 1992($t0)
        sw $s3, 1996($t0)
        sw $s3, 2000($t0)
        sw $s3, 2004($t0)
        sw $s3, 2008($t0)
        sw $s3, 2012($t0)
        sw $s3, 2016($t0)
        sw $s3, 2020($t0)
        sw $s3, 2024($t0)
        sw $s3, 2028($t0)
        sw $s3, 2032($t0)
        sw $s3, 2036($t0)
        sw $s3, 2040($t0)


        sw $s3, 2048($t0)
        sw $s3, 2176($t0)
        sw $s3, 2304($t0)
        sw $s3, 2432($t0)
        sw $s3, 2560($t0)
        sw $s3, 2688($t0)
        sw $s3, 2816($t0)

        sw $s3, 2948($t0)
        sw $s3, 2952($t0)
        sw $s3, 2956($t0)
        sw $s3, 2960($t0)
        sw $s3, 2964($t0)
        sw $s3, 2968($t0)
        sw $s3, 2972($t0)
        sw $s3, 2976($t0)
        sw $s3, 2980($t0)
        sw $s3, 2984($t0)
        sw $s3, 2988($t0)
        sw $s3, 2992($t0)
        sw $s3, 2996($t0)
        sw $s3, 3000($t0)
        sw $s3, 3004($t0)
        sw $s3, 3008($t0)
        sw $s3, 3012($t0)
        sw $s3, 3016($t0)
        sw $s3, 3020($t0)
        sw $s3, 3024($t0)
        sw $s3, 3028($t0)
        sw $s3, 3032($t0)
        sw $s3, 3036($t0)
        sw $s3, 3040($t0)
        sw $s3, 3044($t0)
        sw $s3, 3048($t0)
        sw $s3, 3052($t0)
        sw $s3, 3056($t0)
        sw $s3, 3060($t0)
        sw $s3, 3064($t0)
          
        sw $s3, 2172($t0)
        sw $s3, 2300($t0)
        sw $s3, 2428($t0)
        sw $s3, 2556($t0)
        sw $s3, 2684($t0)
        sw $s3, 2812($t0)
        sw $s3, 2940($t0)

        lw $s1, ADDR_KBRD # $s1 holds the keyboard status

      start_screen_loop:


        # Check if key has been pressed
    
        lb $t2, 0($s1) # $t2 == 1 if key pressed, so:
        beq $t2, $zero, start_screen_loop # Skip key press code if no key was pressed

        # Else, Key *HAS* been pressed, so:

        # ASCII value of key into $t2
        lb $t2, 4($s1)

        beq $t2, 0x57, start_input_w
        beq $t2, 0x77, start_input_w
        beq $t2, 0x20, start_input_space
        beq $t2, 0x53, start_input_s
        beq $t2, 0x73, start_input_s

        # Else, key input invalid, restart loop:
        j start_screen_loop

        start_input_w:
          lw $t3, difficulty # $t3 = difficulty
          beq $t3, $zero start_screen_loop # Difficulty already least possible
          addi $t3, $t3, -1 # Lower difficulty by 1
          sw $t3, difficulty

          j selection_overlay_helper
          

        start_input_space:

          #TODO:

            # set grav speed & virus count based on difficulty branch out
            addi $t1, $zero, 1
            addi $t2, $zero, 2
            lw $t3, difficulty

            beq $t3, $zero, set_easy
            beq $t3, $t1, set_medium
            beq $t3, $t2, set_hard

            set_easy:

              addi $t4, $zero, 210
              sw $t4, gravity_speed_increase_checker

              addi $t4, $zero, 45
              sw $t4, gravity_speed

              addi $t4, $zero, 4
              sw $t4, virus_count

              j main

            set_medium:

              addi $t4, $zero, 150
              sw $t4, gravity_speed_increase_checker

              addi $t4, $zero, 30
              sw $t4, gravity_speed

              addi $t4, $zero, 5
              sw $t4, virus_count

              j main

            set_hard:

              addi $t4, $zero, 90
              sw $t4, gravity_speed_increase_checker

              addi $t4, $zero, 15
              sw $t4, gravity_speed

              addi $t4, $zero, 6
              sw $t4, virus_count

              j main

        start_input_s:
          lw $t3, difficulty # $t3 = difficulty
          addi $t4, $zero, 2 # $t4 = 2
          beq $t3, $t4 start_screen_loop # Difficulty already max possible
          addi $t3, $t3, 1 # Increase difficulty by 1
          sw $t3, difficulty

          j selection_overlay_helper
          

      selection_overlay_helper:

        # $t3 holds difficulty

        # First erase all other select overlays:

          addi $t4, $zero, 4 # $t4 = 4
          addi $t7, $zero, 32 # $t7 = 32 (Black out 32 pixels per row)
          add $t5, $zero, $zero # $t5 = 0, this is the outer loop counter

          # Get $t0 ready:
            addi $t0, $gp, 0

          black_horizontal_outer_loop:

            beq $t5, $t4, black_horizontal_exit # Branch out, all rows black again.

            add $t6, $zero, $zero # Inner loop counter
            addi $t5, $t5, 1 # Increment outer loop counter

            addi $t0, $t0, 896

            black_horizontal_inner_loop:

              beq $t6, $t7, black_horizontal_outer_loop 
              
              sw $zero, 0($t0) # Paint current pixel black

              addi $t0, $t0, 4 # Move to the next right pixel
              addi $t6, $t6, 1 # Increment inner loop counter

              j black_horizontal_inner_loop
              

          black_horizontal_exit:

            # Now black out the sides manually:

              add $t0, $gp, $zero # Reset $t0

              sw $0, 1048($t0)
              sw $0, 1176($t0)
              sw $0, 1304($t0)
              sw $0, 1432($t0)
              sw $0, 1560($t0)
              sw $0, 1688($t0)
              sw $0, 1816($t0)

              sw $0, 1128($t0)
              sw $0, 1256($t0)
              sw $0, 1384($t0)
              sw $0, 1512($t0)
              sw $0, 1640($t0)
              sw $0, 1768($t0)
              sw $0, 1896($t0)

              sw $0, 2048($t0)
              sw $0, 2176($t0)
              sw $0, 2304($t0)
              sw $0, 2432($t0)
              sw $0, 2560($t0)
              sw $0, 2688($t0)
              sw $0, 2816($t0)

              sw $0, 2172($t0)
              sw $0, 2300($t0)
              sw $0, 2428($t0)
              sw $0, 2556($t0)
              sw $0, 2684($t0)
              sw $0, 2812($t0)
              sw $0, 2940($t0)

              sw $0, 3096($t0)
              sw $0, 3224($t0)
              sw $0, 3352($t0)
              sw $0, 3480($t0)
              sw $0, 3608($t0)
              sw $0, 3736($t0)
              sw $0, 3864($t0)

              sw $0, 3180($t0)
              sw $0, 3308($t0)
              sw $0, 3436($t0)
              sw $0, 3564($t0)
              sw $0, 3692($t0)
              sw $0, 3820($t0)
              sw $0, 3948($t0)
              
    

            # Next, draw the correct overlay for the selected difficulty:

              addi $t1, $zero, 1
              addi $t2, $zero, 2

              beq $t3, $zero, easy_overlay
              beq $t3, $t1, medium_overlay
              beq $t3, $t2, hard_overlay

              easy_overlay:

                # Do sides manually:

                sw $s3, 1048($t0)
                sw $s3, 1176($t0)
                sw $s3, 1304($t0)
                sw $s3, 1432($t0)
                sw $s3, 1560($t0)
                sw $s3, 1688($t0)
                sw $s3, 1816($t0)
  
                sw $s3, 1128($t0)
                sw $s3, 1256($t0)
                sw $s3, 1384($t0)
                sw $s3, 1512($t0)
                sw $s3, 1640($t0)
                sw $s3, 1768($t0)
                sw $s3, 1896($t0)

              # Now do the rows:

                addi $t4, $zero, 2 # $t4 = 4
                addi $t7, $zero, 19 # $t7 = 19
                add $t5, $zero, $zero # $t5 = 0, this is the outer loop counter
      
                # Get $t0 ready:
                  addi $t0, $gp, -24
      
                easy_horizontal_outer_loop:

                  beq $t5, $t4, start_screen_loop # Branch out, all rows gold.
      
                  add $t6, $zero, $zero # Inner loop counter
                  addi $t5, $t5, 1 # Increment outer loop counter
      
                  addi $t0, $t0, 948
      
                  easy_horizontal_inner_loop:
      
                    beq $t6, $t7, easy_horizontal_outer_loop 
                    
                    sw $s3, 0($t0) # Paint current gold
      
                    addi $t0, $t0, 4 # Move to the next right pixel
                    addi $t6, $t6, 1 # Increment inner loop counter
      
                    j easy_horizontal_inner_loop

                

              medium_overlay:

                # Do sides manually:

                  sw $s3, 2048($t0)
                  sw $s3, 2176($t0)
                  sw $s3, 2304($t0)
                  sw $s3, 2432($t0)
                  sw $s3, 2560($t0)
                  sw $s3, 2688($t0)
                  sw $s3, 2816($t0)
    
                  sw $s3, 2172($t0)
                  sw $s3, 2300($t0)
                  sw $s3, 2428($t0)
                  sw $s3, 2556($t0)
                  sw $s3, 2684($t0)
                  sw $s3, 2812($t0)
                  sw $s3, 2940($t0)


                  addi $t4, $zero, 2 # $t4 = 4
                  addi $t7, $zero, 30 # $t7 = 30
                  add $t5, $zero, $zero # $t5 = 0, this is the outer loop counter
        
                  # Get $t0 ready:
                    addi $t0, $gp, 1020
        
                  medium_horizontal_outer_loop:
  
                    beq $t5, $t4, start_screen_loop # Branch out, all rows gold.
        
                    add $t6, $zero, $zero # Inner loop counter
                    addi $t5, $t5, 1 # Increment outer loop counter
        
                    addi $t0, $t0, 904
        
                    medium_horizontal_inner_loop:
        
                      beq $t6, $t7, medium_horizontal_outer_loop 
                      
                      sw $s3, 0($t0) # Paint current gold
        
                      addi $t0, $t0, 4 # Move to the next right pixel
                      addi $t6, $t6, 1 # Increment inner loop counter
        
                      j medium_horizontal_inner_loop

              hard_overlay:

                # Do sides manually:

                  sw $s3, 3096($t0)
                  sw $s3, 3224($t0)
                  sw $s3, 3352($t0)
                  sw $s3, 3480($t0)
                  sw $s3, 3608($t0)
                  sw $s3, 3736($t0)
                  sw $s3, 3864($t0)
    
                  sw $s3, 3180($t0)
                  sw $s3, 3308($t0)
                  sw $s3, 3436($t0)
                  sw $s3, 3564($t0)
                  sw $s3, 3692($t0)
                  sw $s3, 3820($t0)
                  sw $s3, 3948($t0)


                  addi $t4, $zero, 2 # $t4 = 4
                  addi $t7, $zero, 20 # $t7 = 20
                  add $t5, $zero, $zero # $t5 = 0, this is the outer loop counter
        
                  # Get $t0 ready:
                    addi $t0, $gp, 2028
        
                  hard_horizontal_outer_loop:
  
                    beq $t5, $t4, start_screen_loop # Branch out, all rows gold.
        
                    add $t6, $zero, $zero # Inner loop counter
                    addi $t5, $t5, 1 # Increment outer loop counter
        
                    addi $t0, $t0, 944
        
                    hard_horizontal_inner_loop:
        
                      beq $t6, $t7, hard_horizontal_outer_loop 
                      
                      sw $s3, 0($t0) # Paint current gold
        
                      addi $t0, $t0, 4 # Move to the next right pixel
                      addi $t6, $t6, 1 # Increment inner loop counter
        
                      j hard_horizontal_inner_loop


            j start_screen_loop
        


































      

    
main:

    # Paint the whole scene back to black 

          addi $t2, $zero, 1023
          add $t0, $gp, $zero # Set $t0 to top left pixel 

          reset_display_loop_main:

            beq $t2, $zero, initialize
            sw $zero, 0($t0) # Paints current pixel black
            addi $t0, $t0, 4 # Go to next pixel
            subi $t2, $t2, 1 # Decrement counter

            j reset_display_loop_main

  initialize:
  
    # Initialize the game

    # Draw the Initial screen:

    lw $t0, ADDR_DSPL # Sets display address to Register 0

    lw $t1, PURPLE_COLOR # Sets Register 1 to have color purple
    
    addi $t0, $gp, 784 # Set display at prefered pixel to start purple rectangle Top
    addi $t2, $zero, 17 # Counter for how many pixels we are sequentially coloring
    
    draw_1:
        # Draws the top row of pixels for the bottle
        
        beq $t2, $zero, exit_draw_1 
        sw $t1, 0($t0) # Paints current pixel
        addi $t0, $t0, 4 # Increments the pixel
        subi $t2, $t2, 1 # Decrements the counter
        j draw_1
    
    exit_draw_1:
        addi $t0, $gp, 908 # Set display at prefered pixel to start purple rectangle Walls
        addi $t2, $zero, 23 # Counter for how many pixels we are sequentially coloring
    
    draw_2:
        # Draws the wall pixels for the bottle
        
        beq $t2, $zero, exit_draw_2
        sw $t1, 0($t0) # Paints pixel
        addi $t0, $t0, 72 # Moves $t0 to other side of wall
        sw $t1, 0($t0) # Paints pixel
        addi $t0, $t0, 56 # Moves $t0 to next column in the wall of pixels
        subi $t2, $t2, 1 # Decrements counter
        j draw_2
    
    exit_draw_2:
      addi $t0, $gp, 3852 # Set display at prefered pixel to start purple rectangle Bottom
      addi $t2, $zero, 19 # Counter for how many pixels we are sequentially coloring
    
    draw_3:
        # Draws the bottom row of pixels for the bottle
        
        beq $t2, $zero, exit_draw_3 
        sw $t1, 0($t0) # Paints first pixel of display
        addi $t0, $t0, 4 # Increments the pixel
        subi $t2, $t2, 1 # Decrements the counter
        j draw_3
        
    exit_draw_3:
      
        # Now Draw the neck of the bottle

        # Left Neck
        addi $t0, $gp, 808 # Set display at prefered pixel to start purple rectangle Walls
        sw $t1, -128($t0)
        sw $t1, -260($t0)
        sw $t1, -388($t0)
        
        # Right Neck
        sw $t1, -112($t0)
        sw $t1, -236($t0)
        sw $t1, -364($t0)

        # Opening
         # li $t1, 0x0b0510 # Sets Register 1 to have darker purple color
         sw $zero, 4($t0)
         sw $zero, 8($t0)
         sw $zero, 12($t0)

        lw $s7, virus_count # Grab the number of viruses (based on difficulty) from memory

      # Store virus_array in $s6
        la $s6, virus_array
        
    draw_viruses:
        
      # Need to create $s7 # of viruses each with a random color in a random position within the bottle
        beq $s7, $zero, exit_virus_loop

      # Initialize code for the color loop:
        addi $s1, $zero, 1 # Store 1 in $s1
        addi $s2, $zero, 2 # Store 2 in $s2

        jal pick_random_color # Color stored in $t1

      # Now pick a random spot inside the bottle:

        addi $t0, $gp, 1304 # Sets the display at the top leftmost pixel of the virus spawning area

      # Row Setup
        li $v0, 42 # Random int code
        li $a0, 0 
        li $a1, 17 # Number between 0-16
        syscall

        jal find_row
      
      # Column Setup
        li $v0, 42 # Random int code
        li $a0, 0 
        li $a1, 13 # Number between 0-12
        syscall

        jal find_column

      # Now $t0 is at a random pixel in the spawn area, need to check if empty:

        lw $t2, 0($t0) # $t2 has current color - need to check if black or not

        bne $t2, $zero, dont_color
        sw $t1, 0($t0) # Color in the pixel with random color
        sw $t0, 0($s6) # Stores the pixel value of the virus
        addi $s6, $s6, 4 # move to the next element in the array
        addi $s7, $s7, -1 # Decrement Counter
        j draw_viruses


        dont_color: # Dont decrement counter b/c we need another random pixel chosen
          j draw_viruses

        

    exit_virus_loop:

        # Now we have to draw the Starting pills:

      # Reset Display's current pixel:
        add $t0, $gp, $zero

      # Initialize code for the color loop:
        addi $s1, $zero, 1 # Store 1 in $s1
        addi $s2, $zero, 2 # Store 2 in $s2
  

# Playable pill:
        # Top Pixel:
        jal pick_random_color # Color stored in $t1
        sw $t1, 560($t0) # Color in the pixel with color from $t2 

        # Bottom Pixel:
        jal pick_random_color # Color stored in $t1
        sw $t1, 688($t0)  

      # 1st next pill:
        jal pick_random_color # Color stored in $t1
        sw $t1, 616($t0) 

        jal pick_random_color # Color stored in $t1
        sw $t1, 744($t0)

      # 2nd next pill:
        jal pick_random_color # Color stored in $t1
        sw $t1, 1000($t0) 

        jal pick_random_color # Color stored in $t1
        sw $t1, 1128($t0)

      # 3rd next pill:
        jal pick_random_color # Color stored in $t1
        sw $t1, 1384($t0) 

        jal pick_random_color # Color stored in $t1
        sw $t1, 1512($t0)

      # 4th next pill:
        jal pick_random_color # Color stored in $t1
        sw $t1, 1768($t0) 

        jal pick_random_color # Color stored in $t1
        sw $t1, 1896($t0)

draw_saved_capsule_box:

  addi $t1, $zero, 0xc0c0c0

  sw $t1, 3172($gp)
  sw $t1, 3176($gp)
  sw $t1, 3180($gp)
  
  sw $t1, 3300($gp)
  sw $t1, 3308($gp)

  sw $t1, 3428($gp)
  sw $t1, 3436($gp)

  sw $t1, 3556($gp)
  sw $t1, 3560($gp)
  sw $t1, 3564($gp)
































prepare_game_loop:



        lw $s1, ADDR_KBRD # $s1 holds the keyboard status
        addi $t0, $gp, 688 # Set current pixel to the first playable pill
        add $s2, $zero, $zero # Set $s2 as 0, this will indicate vertical/horizontal - 0 for vertical.

        # FOR THE FOLLOWING GAME_LOOP CODE:
        #
        # $t0 -> STORES THE BOTTOM PIXEL OF THE CURRENT PLAYABLE PILL 
        # $s1 -> STORES THE KEYBOARD STATUS
        # $s2 -> HOLDS THE BOOLEAN FOR PILL VERTICAL/HORIZONTAL (0 FOR VERTICAL)
        # 


game_loop:
  
    # 1a. Check if key has been pressed
    
        lb $t2, 0($s1) # $t2 == 1 if key pressed, so:
        beq $t2, $zero, refresh_screen # Skip key press code if no key was pressed

        # Else, Key *HAS* been pressed, so:
          
    # 1b. Check which key has been pressed

      # ASCII value of key into $t2
        lb $t2, 4($s1)

        beq $t2, 0x57, input_w
        beq $t2, 0x77, input_w
        beq $t2, 0x41, input_a
        beq $t2, 0x61, input_a
        beq $t2, 0x53, input_s
        beq $t2, 0x73, input_s
        beq $t2, 0x44, input_d
        beq $t2, 0x64, input_d
        beq $t2, 0x51, input_q
        beq $t2, 0x71, input_q
        beq $t2, 0x52, input_r
        beq $t2, 0x72, input_r
        beq $t2, 0x50, input_p
        beq $t2, 0x70, input_p
        beq $t2, 0x20, input_spacebar

        j check_collision # Jump to check_collision if the key pressed is unassigned.

        input_w:

          # ROTATION
          
          bne $s2, $zero w_horizontal # $s2 is horizontal, so go to horizontal case
          # Else, we are vertical
          
          w_vertical:
            # Know we're vertical, so check right pixel free:
              lw $t3, 4($t0) # $t3 has color of right pixel
              add $a0, $zero, $t3 # $a0 = $t3
              li $a1, 0x0b0510 # $a1 = Dark Purple

              jal check_pixel_free # Sets $v0 = 1 if pixel free

              
              beq $v0, $zero check_collision # If $v0 == 0, then pixel NOT free, so skip input.
              
          w_vertical_2:
            # Else, right pixel free, so do the rotate:
              lw $t3, -128($t0) # $t3 has color of above pixel
              sw $zero, -128($t0) # Sets top pixel to black
              sw $t3, 4($t0) # Sets the top pixel's color to the right.

              addi $s2, $zero, 1 # Set $s2 to 1 b/c pill is now horizontal

              j check_collision 

          w_horizontal:
            # Know we're horizontal
            
              lw $t3, -128($t0) # $t3 has color of top pixel
              bne $t3, $zero refresh_screen # If not black, branch out & skip movement

            # Else, top pixel free, so do the rotate:
              lw $t3, 4($t0) # $t3 has color of right pixel
              sw $zero, 4($t0) # Sets right pixel to black
              sw $t3, -128($t0) # Sets the right pixel's color to the top.

              add $s2, $zero, $zero # Set $s2 to 0 b/c pill is now vertical

              j check_collision
            

        input_a:

          # MOVE LEFT

          bne $s2, $zero a_horizontal # $s2 is horizontal, so go to horizontal case

          a_vertical:

            # Check pixel free:
            lw $t3, -4($t0) # $t3 has color of left pixel

            add $a0, $zero, $t3 # $a0 = $t3

            jal check_pixel_free # Sets $v0 = 1 if pixel free


            # Ran into wall case:
            lw $t1, PURPLE_COLOR
            lw $t3, -4($t0) # left pixel of $t0
            bne $t3, $t1, wall_not_collided_a_vertical
            lw $t3, -132($t0) # top left pixel of $t0
            bne $t3, $t1, wall_not_collided_a_vertical

            # o.w. Wall has been collided:

              add $a3, $t0, $zero # $a3 = $t0 (for the helper)
              jal check_collision_helper
              j update_playable_pill

            

            wall_not_collided_a_vertical:
            beq $v0, $zero refresh_screen # If $v0 == 0, then pixel NOT free, so skip input.
            
            # Similarly Check top left pixel free:
            lw $t4, -132($t0) # $t4 has color of top pixel

            add $a0, $zero, $t4 # $a0 = $t4

            jal check_pixel_free # Sets $v0 = 1 if pixel free

            beq $v0, $zero refresh_screen # If $v0 == 0, then pixel NOT free, so skip input.

            # Both pixels free so perform the movement:

            lw $t3, 0($t0) # $t3 has color of bottom pixel
            lw $t4, -128($t0) # $t4 has color of top pixel
            # Make previous pixels black:
            sw $zero, 0($t0)
            sw $zero, -128($t0)
            # Make left pixels colored:
            sw $t3, -4($t0)
            sw $t4, -132($t0)

            addi $t0, $t0, -4 # Moves the current position of the bottom pixel
            
            j refresh_screen


            
          a_horizontal:

            # Check left pixel free:
            lw $t3, -4($t0) # $t3 has color of left pixel

            add $a0, $zero, $t3 # $a0 = $t3

            jal check_pixel_free # Sets $v0 = 1 if pixel free

            # Ran into wall case:
            lw $t1, PURPLE_COLOR
            lw $t3, -4($t0) # left pixel of $t0
            bne $t3, $t1, wall_not_collided_a_horizontal

            # o.w. Wall has been collided:

              add $a3, $t0, $zero # $a3 = $t0 (for the helper)
              jal check_collision_helper
              j update_playable_pill


            wall_not_collided_a_horizontal:
            beq $v0, $zero refresh_screen # If $v0 == 0, then pixel NOT free, so skip input.
            

            # pixel free so perform the movement:

            lw $t3, 0($t0) # $t3 has color of bottom pixel
            lw $t4, 4($t0) # $t4 has color of right pixel
            # Make previous pixels black:
            sw $zero, 0($t0)
            sw $zero, 4($t0)
            # Make left & middle pixels colored:
            sw $t3, -4($t0)
            sw $t4, 0($t0)

            addi $t0, $t0, -4 # Moves the current position of the bottom pixel

            j refresh_screen


        input_s:

          # MOVE DOWN

            bne $s2, $zero s_horizontal # $s2 is horizontal, so go to horizontal case

            s_vertical:

            # Check under pixel free:
              lw $t3, 128($t0) # $t3 has color of under pixel
  
              add $a0, $zero, $t3 # $a0 = $t3
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero check_collision # If $v0 == 0, then pixel NOT free, so skip input.
              
            # pixel free so perform the movement:

              lw $t3, 0($t0) # $t3 has color of bottom pixel
              lw $t4, -128($t0) # $t4 has color of top pixel
              # Make previous pixels black:
              sw $zero, 0($t0)
              sw $zero, -128($t0)
              # Make new pixels colored:
              sw $t3, 128($t0)
              sw $t4, 0($t0)
  
              addi $t0, $t0, 128 # Moves the current position of the bottom pixel
  
              j check_collision

            s_horizontal:

            # Check pixel free:
              lw $t3, 128($t0) # $t3 has color of under pixel
  
              add $a0, $zero, $t3 # $a0 = $t3
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero check_collision # If $v0 == 0, then pixel NOT free, so check collision instead.
              
              # Similarly Check bottom right pixel free:
              lw $t4, 132($t0) # $t4 has color of bottom right pixel
  
              add $a0, $zero, $t4 # $a0 = $t4
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero check_collision # If $v0 == 0, then pixel NOT free, so skip input.
  
            # Both pixels free so perform the movement:

              lw $t3, 0($t0) # $t3 has color of bottom pixel
              lw $t4, 4($t0) # $t4 has color of right pixel
              # Make previous pixels black:
              sw $zero, 0($t0)
              sw $zero, 4($t0)
              # Make under and bottom right pixels colored:
              sw $t3, 128($t0)
              sw $t4, 132($t0)
  
              addi $t0, $t0, 128 # Moves the current position of the bottom pixel
              
              j check_collision



        input_d:

          # MOVE RIGHT

            bne $s2, $zero d_horizontal # $s2 is horizontal, so go to horizontal case

            d_vertical:

            # Check pixel free:
              lw $t3, 4($t0) # $t3 has color of right pixel
  
              add $a0, $zero, $t3 # $a0 = $t3
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free


              # Ran into wall case:
              lw $t1, PURPLE_COLOR
              lw $t3, 4($t0) # left pixel of $t0
              bne $t3, $t1, wall_not_collided_d_vertical
              lw $t3, -124($t0) # top left pixel of $t0
              bne $t3, $t1, wall_not_collided_d_vertical
  
              # o.w. Wall has been collided:

              add $a3, $t0, $zero # $a3 = $t0 (for the helper)
              jal check_collision_helper
              j update_playable_pill

              wall_not_collided_d_vertical:
              beq $v0, $zero refresh_screen # If $v0 == 0, then pixel NOT free, so skip input.
              
              # Similarly Check top right pixel free:
              lw $t4, -124($t0) # $t4 has color of top right pixel
  
              add $a0, $zero, $t4 # $a0 = $t4
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero refresh_screen # If $v0 == 0, then pixel NOT free, so skip input.
  
              # Both pixels free so perform the movement:
  
              lw $t3, 0($t0) # $t3 has color of bottom pixel
              lw $t4, -128($t0) # $t4 has color of top pixel
              # Make previous pixels black:
              sw $zero, 0($t0)
              sw $zero, -128($t0)
              # Make right pixels colored:
              sw $t3, 4($t0)
              sw $t4, -124($t0)
  
              addi $t0, $t0, 4 # Moves the current position of the bottom pixel
              
              j refresh_screen
  
  
              
            d_horizontal:
  
              # Check right right pixel free:
              lw $t3, 8($t0) # $t3 has color of right right pixel
  
              add $a0, $zero, $t3 # $a0 = $t3
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free

              # Ran into wall case:
              lw $t1, PURPLE_COLOR
              lw $t3, 8($t0) # left pixel of $t0
              bne $t3, $t1, wall_not_collided_d_horizontal
  
              # o.w. Wall has been collided:

              add $a3, $t0, $zero # $a3 = $t0 (for the helper)
              jal check_collision_helper
              j update_playable_pill


            wall_not_collided_d_horizontal:
              beq $v0, $zero refresh_screen # If $v0 == 0, then pixel NOT free, so skip input.
              
  
              # pixel free so perform the movement:
  
              lw $t3, 0($t0) # $t3 has color of bottom pixel
              lw $t4, 4($t0) # $t4 has color of right pixel
              # Make previous pixels black:
              sw $zero, 0($t0)
              sw $zero, 4($t0)
              # Make right & right right pixels colored:
              sw $t3, 4($t0)
              sw $t4, 8($t0)
  
              addi $t0, $t0, 4 # Moves the current position of the bottom pixel
  
              j refresh_screen



        input_q:
          # QUIT GAME

          li $v0, 10 # Terminate Program
          syscall

        input_r:

          # Reset Game

          j main


        input_p:

          # PAUSE GAME

          draw_pause_symbol:

          addi $a0, $zero, 0xd3d3d4 # $a0 = color light gray.

          sw $a0 132($gp)
          sw $a0 260($gp)
          sw $a0 388($gp)
          
          sw $a0 140($gp)
          sw $a0 268($gp)
          sw $a0 396($gp)
            

          pause_loop:

            lb $t2, 0($s1) # $t2 == 1 if key pressed, so:
            beq $t2, $zero, pause_loop # Skip key press code if no key was pressed
    
            # Else, Key *HAS* been pressed, so:
              
            # 1b. Check which key has been pressed
    
            # ASCII value of key into $t2
            lb $t2, 4($s1)
    
            beq $t2, 0x50, unpause
            beq $t2, 0x70, unpause

          j pause_loop

          unpause:

            # Erase the pause symbol:

              sw $0 132($gp)
              sw $0 260($gp)
              sw $0 388($gp)
              
              sw $0 140($gp)
              sw $0 268($gp)
              sw $0 396($gp)

              j refresh_screen






    
        input_spacebar:
          
          lw $a0, 3432($gp)

          bne $a0, $zero, activate_saved_pill # If there is a pill in the saved pill box, then we retreive it.

          # Otherwise, no saved pill yet, save the current playable pill:

            lw $a0, 0($t0)
            sw $a0, 3432($gp)

            sw $zero, 0($t0)

            beq $s2, $zero save_vertical # If $s2 == 0 -> Pill is vertical, go to vertical case

            # Otherwise, we are in the horizontal case:

            lw $a0, 4($t0)
            sw $a0, 3304($gp)
            sw $zero, 4($t0) # Delete saved pixel
            j update_playable_pill

            save_vertical:
              lw $a0, -128($t0)
              sw $a0, 3304($gp)
              sw $zero, -128($t0) # Delete saved pixel
              j update_playable_pill


          activate_saved_pill:

            lw $a0, 3432($gp)
            sw $a0, 0($t0)

            lw $a0, 3304($gp)

            beq $s2, $zero activate_vertical

            # o.w. we are in the horizontal case:
              sw $a0, 4($t0)
              j exit_activate_saved_pill

            activate_vertical:
              sw $a0, -128($t0)

            exit_activate_saved_pill:
              sw $zero, 3432($gp)
              sw $zero, 3304($gp)

            j refresh_screen
























        
    
    # 2a. Check for collisions

        # Need to check if there is a non-black pixel underneath current position:

          check_collision: 


          add $a3, $t0, $zero # $a3 = $t0
          lw $t3, 128($a3) #Store color of underneath pixel in $a3
          bne $t3, $zero, collision_detected # Branch out if collision

          beq $s2, $zero refresh_screen # If $s2 != 0, then we skip horizontal collision test
          
          lw $t3, 132($a3) # Store color of bottom right pixel in $t3
          beq $t3, $zero, refresh_screen # Brance out if no collision 

          #o.w:

          bne $s2, $zero, horizontal_second_pixel_collision_check
          addi $a3, $a3, -128
          j second_pixel_check
          horizontal_second_pixel_collision_check:
          addi $a3, $a3, 4
          second_pixel_check:
          jal check_collision_helper

          bne $s2, $zero, horizontal_subtract
          addi $a3, $a3, 128
          j collision_detected
          horizontal_subtract:
          addi $a3, $a3, -4

          collision_detected:

            add $s3, $a3, $zero # Set $s3 to $a3, the current rightmost/bottom-most block of same color as $t0
            addi $s4, $a3, -4 # Set $s4 to pixel of block we are checking
            lw $t3, 0($a3) # $t2 = color new block
            lw $t4, -4($a3) # $t3 = Color of block we are checking

            addi $t9, $zero, 4 # $t9 = 4
            addi $t8, $zero, 1 # $t8 = 1 (This is the counter for how many colors we have in a row)

          # First check for horizontal:

            check_left_loop:

              beq $t9, $t8, delete_pixels_horizontal
              bne $t3, $t4, check_right
              

              # o.w. colors match:

              addi $t8, $t8, 1 # Add 1 to the counter
              addi $s4, $s4, -4 # Go one more pixel to the left 
              lw $t4, 0($s4) # Load color of block we are checking

              j check_left_loop


            check_right:

              # Reset $s4 & $t4

              addi $s4, $a3, 4 # Set $s2 to pixel of block we are checking
              lw $t4, 4($a3) # $t4 = Color of block we are checking

              check_right_loop:
                
                beq $t9, $t8, delete_pixels_horizontal
                bne $t3, $t4, check_down

  
                # o.w. colors match:
  
                addi $t8, $t8, 1 # Add 1 to the counter
                add $s3, $s4, $zero, # Save rightmost pixel as this new one ($s3 = $s4)
                addi $s4, $s4, 4 # Go one more pixel to the right 
                lw $t4, 0($s4) # Load color of block we are checking
  
                j check_right_loop


          # Check vertical:

            # $s3 now correspnds to the bottom most pixel with the same color

            check_down:

              # Reset $s3, $s4, $t4, & $t8

              add $s3, $a3, $zero
              addi $s4, $s3, 128 # $s4 block we are checking down first
              lw $t4, 0($s4) # $t4 = Color of block we are checking
              addi $t8, $zero, 1 # Reset counter back to 1 b/c we are now checking for vertical 4-in-a-rows

              check_down_loop:

                beq $t9, $t8, delete_pixels_vertical
                bne $t3, $t4, check_up

  
                # o.w. colors match:
  
                addi $t8, $t8, 1 # Add 1 to the counter
                add $s3, $s4, $zero, # Save bottom-most pixel as this new one ($s3 = $s4)
                addi $s4, $s4, 128 # Go one more pixel down 
                lw $t4, 0($s4) # Load color of block we are checking
  
                j check_down_loop

            check_up:

              lw $t4, -128($a3) # $t4 = Color of block we are checking
              addi $s4, $a3, -128 # Set $s4 to block above original

              check_up_loop:
                
                beq $t9, $t8, delete_pixels_vertical
                bne $t3, $t4, update_playable_pill
                
  
                # o.w. colors match:
  
                addi $t8, $t8, 1 # Add 1 to the counter
                addi $s4, $s4, -128 # Go one more pixel up 
                lw $t4, 0($s4) # Load color of block we are checking
  
                j check_up_loop
            

            delete_pixels_horizontal:

              # Have 4 in a row to the left of $s3

              sw $zero, 0($s3)
              sw $zero, -4($s3)
              sw $zero, -8($s3)
              sw $zero, -12($s3)

              # Ned to check adjacent pixels to see if they need to be dropped
              addi $a0, $s3, 4
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -16
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -124
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -128
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -132
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -136
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -140
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -144
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              


              add $a0, $zero, $zero

              j update_playable_pill

            delete_pixels_vertical:

              # Have 4 in a row up from $s3

              sw $zero, 0($s3)
              sw $zero, -128($s3)
              sw $zero, -256($s3)
              sw $zero, -384($s3)

              # Ned to check adjacent pixels to see if they need to be dropped
              addi $a0, $s3, -4
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, 4
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -132
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -124
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -260
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -252
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -388
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -380
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -512
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was) #
              addi $a0, $s3, -516
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)
              addi $a0, $s3, -508
              add $v1, $s3, $zero # $v1 = $s3 (to keep for after collision helper)
              jal pull_block_down
              add $s3, $v1, $zero # $s3 = $v1 (reset back to what it was)


              addi $a0, $zero, 1

j update_playable_pill # SKIPS OVER UPDATE LOCATIONS BC I THINK IT'S USELESS






















    
	# 2b. Update locations (capsules)

    update_locations:
      
      # $s3 holds the location of the pixel that corresponds to rightmost/bottom-most of color row.
      # $a0 =  0 if the row is horizontal, and $a0 = 1 if vertical.

      # This will be used for horizontal row case
      add $t3, $zero, $zero # Loop iteration tracker
      addi $t4, $zero, 4 # Loop repition counter

      addi $s5, $s3, -128 # $s5 = $s3 - 128 (pixel above $s3) 
      add $s6, $s3, -512 # Gets the block up 4 pixels from $s3 (for vertical case)
      lw $t1, PURPLE_COLOR # Sets Register 1 to have purple color

      bne $a0, $zero update_location_loop_vertical

      update_location_loop_horizontal:

        # New iteration, so we update the pixel we need to check:
          lw $s4, 0($s5) # Store color of this block

          beq $s4, $zero, next_iteration # If block is *not* black, we need to pull it down

        update_needed_horizontal:
  
          # In this case, we know above pixel, $s4, is colored & needs to be moved down:

            beq $s4, $t1 next_iteration  # If pixel is purp, move to next iteration
  
            # Store virus_array in $t9 And check if above pixel virus:
            lw $t9, virus_array 
            lw $t8, 0($t9) 
            beq $s5, $t8,  update_location_loop_horizontal # If above pixel is a virus, move next:
            lw $t8, 4($t9) 
            beq $s5, $t8, update_location_loop_horizontal
            lw $t8, 8($t9) 
            beq $s5, $t8, update_location_loop_horizontal
            lw $t8, 12($t9) 
            beq $s5, $t8, update_location_loop_horizontal
            lw $t8, 16($t9) 
            beq $s5, $t8, update_location_loop_horizontal
            lw $t8, 20($t9) 
            beq $s5, $t8, update_location_loop_horizontal
  
            # OTHERWISE - Pixel does indeed need to be moved down:


            add $a0, $s5, $zero # Set $a0 = $s6, block we are pulling down
            jal pull_block_down
            addi $a0, $zero, 0 # Reset $a0 = 0, since we are in horizontal case
  
            # sw $s4, 128($s5)  # Move Pixel color down
            # sw $zero 0($s5) # And set the above pixel to black


            next_iteration:

            # Move the block we need to check next to the left of what we just moved down:
            addi $t3, $t3, 1 # Need to go to next iteration.
            beq $t4, $t3 update_playable_pill # If we've reached 4 iterations, we're done
            addi $s5, $s5 -4 # Go left 1 more block
  
            j update_location_loop_horizontal
          


      update_location_loop_vertical:


        # New iteration, so we update the pixel we need to check:
          lw $s4, 0($s6) # Store color of this pixel

        beq $s4, $zero, update_playable_pill # If the pixel is black, dont need to update, so we exit

        update_needed_vertical:

          # In this case, we know above pixel, $s6, is colored ($s4) & needs to be moved down:
            
            beq $s4, $t1 update_playable_pill  # If above pixel is purp, exit
  
            # Store virus_array in $t9 And check if above pixel virus:
            lw $t9, virus_array 
            lw $t8, 0($t9) 
            beq $s6, $t8,  update_playable_pill # If above pixel is a virus, exit:
            lw $t8, 4($t9) 
            beq $s6, $t8, update_playable_pill
            lw $t8, 8($t9) 
            beq $s6, $t8, update_playable_pill
            lw $t8, 12($t9) 
            beq $s6, $t8, update_playable_pill
            lw $t8, 16($t9) 
            beq $s6, $t8, update_playable_pill
            lw $t8, 20($t9) 
            beq $s6, $t8, update_playable_pill
  
            # OTHERWISE - Pixel does indeed need to be moved down: 

            add $a0, $s6, $zero # Set $a0 = $s6, block we are pulling down
            jal pull_block_down
            addi $a0, $zero, 1 # Reset $a0 = 1, since we are in vertical case
  
            # sw $s4, 512($s6)  # Move Pixel color down
            # sw $zero 0($s6) # And set the above pixel to black

            # Check collision of moved down pixel occurs in the pull_down helper so we're good:

            # Increment pixel up 1:
            addi $s6, $s6, -128
  
            j update_location_loop_vertical
      













      update_playable_pill:

        # Reset $t0

        add $t0, $gp, $zero

        # Check if game over first:

          lw $t2, 812($t0)
          bne $t2, $zero, game_over
          lw $t2, 816($t0)
          bne $t2, $zero, game_over    
          lw $t2, 820($t0)
          bne $t2, $zero, game_over
          



          

        # First need to put the 'next pill' into the playable pill spawn area & Send the pulls forward by 1 spot:

      # Playable pill:
        # Top Pixel:
        lw $t2, 616($t0)
        sw $t2, 560($t0) # Color in the pixel with color from $t2 

        # Bottom Pixel:
        lw $t2, 744($t0)
        sw $t2, 688($t0)  

      # 1st next pill:
        lw $t2, 1000($t0)
        sw $t2, 616($t0) 

        lw $t2, 1128($t0)
        sw $t2, 744($t0)

      # 2nd next pill:
        lw $t2, 1384($t0)
        sw $t2, 1000($t0) 

        lw $t2, 1512($t0)
        sw $t2, 1128($t0)

      # 3rd next pill:
        lw $t2, 1768($t0)
        sw $t2, 1384($t0) 

        lw $t2, 1896($t0)
        sw $t2, 1512($t0)



      # 4th next pill needs to be generated:

      # Save $s1 temporarily in $s5:
        add $s5, $s1, $zero
      
      # Initialize code for the color loop:
        addi $s1, $zero, 1 # Store 1 in $s1
        addi $s2, $zero, 2 # Store 2 in $s2

      # Top pixel:
        jal pick_random_color # Color stored in $t1
        sw $t1, 1768($t0)  

      # Bottom pixel:
        jal pick_random_color # Color stored in $t1
        sw $t1, 1896($t0)  

      # now we set $t0 back to the pixel of the bottom playable pill & set $s1 back to the keyboard status & reset the vertical indicator, $s2

        addi $t0, $gp, 688
        add $s1, $s5, $zero
        add $s2, $zero, $zero # Set $s2 as 0


























    
	# 3. Draw the screen

    refresh_screen:


    
	# 4. Sleep
    
    li $v0 , 32 # Sets the system call to invoke the sleep operation (32)
    li $a0, 16 # Sleeps for 16 milisceonds (1 second)
    syscall

    # Increment gravity counter after each sleep call:
      lw $a0, gravity_counter
      addi $a0, $a0, 1
      sw $a0, gravity_counter

    gravity_check:
      lw $v0, gravity_speed

      # Check if the counter is less than the gravity_speed:

      slt $v1, $a0, $v0
      
      
      bne $v1, $zero, gravity_speed_check # If the counter less than the speed number, we don't pull the pill down 1 block.

      #o.w. we perform gravity:
      # Recall $t0 is bottom pixel of current playable pill AND $s2 == 0 if pill is vertical

      # Reset grav_counter to 0:
      sw $zero, gravity_counter

      # Otherwise call the gravity helper to pull the pill down 1 pixel:

      jal gravity_helper # Gravity helper performs pulling the pill down 1 pixel.

      # Now check if the pill under is non-black, if it is then we have to update the pill:
        lw $a0, 128($t0)
        bne $a0, $zero, update_playable_pill


    gravity_speed_check:

    lw $a0, gravity_speed_increase_counter
    lw $v0, gravity_speed_increase_checker

    # Increment the counter first:

    addi $a0, $a0, 1
    sw $a0, gravity_speed_increase_counter

    slt $v1, $a0, $v0 # Sets $v1 = 1 IF $a0 < $v0 (counter < checker)

    bne $v1, $zero, restart_loop # If the counter still less than checker, we skip increasing gravity speed

    # Otherwise, we are inreasing gravity speed:
    lw $a0, gravity_speed
    addi $v0, $zero, 5 # This is the fastest the game should ever go
    beq $a0, $v0, restart_loop # If at max speed, don't increase speed so skip the decrement
    
    subi $a0, $a0, 1
    sw $a0, gravity_speed

    # Reset the counter:

    sw $zero, gravity_speed_increase_counter


    # 5. Go back to Step 1
    restart_loop:
    
    j game_loop




























































































# HELPER FUNCTIONS FROM HERE ON:




pause_game:

  # Check if keypress, if yes, check if spacebar, if yes go back to gameloop, otherwise jump back to pause_game

pick_random_color:

      # Ensure we keep correct return address
      addi $sp, $sp, -4 # Move to free slot in $sp
      sw $ra, 0($sp) # Store $ra into top of stack

      # Picking random color:
        
      li $v0, 42 # Random int
      li $a0, 0 # 
      li $a1, 3 # number between 0-3
      syscall

      # Set random color to $t1
        
      pick_blue:
        bne $a0, $zero, pick_red
        li $t1, 0x125BD0 # $t1 = blue
        j store_color
      pick_red:
        bne $a0, $s1, pick_yellow
        li $t1, 0xC51515 # $t1 = red
        j store_color
      pick_yellow:
        li $t1, 0xEEDD00 # $t1 = yellow
        j store_color
        
    store_color:
      lw $ra, 0($sp) # Load correct return address into $ra
      addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future

      jr $ra















find_column:

    # Ensure we keep correct return address
      addi $sp, $sp, -4 # Move to free slot in $sp
      sw $ra, 0($sp) # Store $ra into top of stack #

  column_loop:
  
        beq $a0, $zero, exit_row_column 

        addi $t0, $t0, 4 # Increments the column pixel by 1
        subi $a0, $a0, 1 # Decrements the counter 

        j column_loop

    
find_row:

    # Ensure we keep correct return address
      addi $sp, $sp, -4 # Move to free slot in $sp
      sw $ra, 0($sp) # Store $ra into top of stack

  row_loop:
    # Row Number:


        beq $a0, $zero, exit_row_column 

        addi $t0, $t0, 128 # Increments the row pixel by 1
        subi $a0, $a0, 1 # Decrements the counter 

        j row_loop

exit_row_column:

        lw $ra, 0($sp) # Load correct return address into $ra
        addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future
  
        jr $ra



















check_pixel_free:

        addi $sp, $sp, -4 # Move to free slot in $sp
        sw $ra, 0($sp) # Store $ra into top of stack

        # Pixel to be checked is in $a0
        # Dark purple color code stored in $a1

        add $v0, $zero, $zero # Initially set the pixel as not free ($v0 = 0)

        #Check black:
        bne $a0, $zero, return # If NOT black, exit

          addi $v0, $zero, 1 # $v0 = 1 -> pixel is free :)
        
        return:
        lw $ra, 0($sp) # Load correct return address into $ra
        addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future
  
        jr $ra

























pull_block_down:

  addi $sp, $sp, -4 # Move to free slot in $sp
  sw $ra, 0($sp) # Store $ra into top of stack

  outer_pull_down_loop:

  # $a0 -> current pixel location of block we want to potentially pull all the way down

  # First check if the block is colored:

  lw $a1, 0($a0) # $a1 = color of block
  beq $a1, $zero, exit_2 # If block IS black, exit

  lw $t1, PURPLE_COLOR # $t1 = purple
  beq $a1, $t1, exit_2 # Exit if block is purple (we reached the top)
  
  lw $a2, 128($a0) # Loads color of the pixel under the one we are checking

  bne $a2, $zero, exit_2 # If Block under NOT black, then we don't pull it down, so exit

  # O.w. need to pull it down:

  add $a2, $zero, $a0 # $a2 = $a0
  add $a3, $zero, $a1 # $a3 = $a1

    inner_pull_down_loop:
      
      lw $a3, 0($a2) # Load the pixel color
      sw $a3, 128($a2) # Shifts color down one pixel
      sw $zero 0($a2) # Turns previous pixel black
      addi $a2, $a2, 128 # $ Shift $a2 down one pixel
      lw $a3, 128($a2) # Load color of pixel underneath

      bne $a3, $zero, pull_down_loop_exit # If next block under is NOT black, exit the pull down loop
  
      j inner_pull_down_loop

    pull_down_loop_exit:

      # The block above the one we just pulled all the way down, we need to check if THAT ONE needs to be pulled down:

      # First check collisions of this new block that has reached a bottom

      add $a3, $a2, $zero # $a3 = $a2 (for the helper)
      sw $s7, temp_var_1 # temp_var_1 = $s7 (to keep for after collision helper)
      sw $a0, temp_var_2 # $a0 = temp_var_2
      
      jal check_collision_helper

      lw $s7, temp_var_1 # $s7 = temp_var_1 (reset back to what it was)
      lw $a0, temp_var_2 # $a0 = temp_var_2

      addi $a0, $a0, -128 # Set the next pixel to check for pulldown, to the pixel ABOVE original pixel we just pulled down 

      j outer_pull_down_loop

      
  
  exit_2:
  lw $ra, 0($sp) # Load correct return address into $ra
  addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future

  jr $ra























  check_collision_helper:

          addi $sp, $sp, -4 # Move to free slot in $sp
          sw $ra, 0($sp) # Store $ra into top of stack

          ##############################################

          # $a3 stores the address of the pixel location we are checking for a collision
          

          lw $t2, 128($a3) # Store color of underneath pixel in $t2
          bne $t2, $zero, collision_detected_helper # Branch out if collision

          beq $s2, $zero exit_collision_helper # If $s2 != 0, then we skip horizontal collision test
          
          lw $t5, 132($a3) # Store color of bottom right pixel in $t5
          bne $t5, $zero, collision_detected_helper # Branch out if collision 

          #o.w. no collision, and we skip the collision code.

          j exit_collision_helper

          collision_detected_helper:

            add $s3, $a3, $zero # Set $s3 to $t0, the current rightmost/bottom-most block of same color as $t0
            addi $s4, $a3, -4 # Set $s2 to pixel of block we are checking
            lw $t5, 0($a3) # $t5 = color new block
            lw $t6, -4($a3) # $t6 = Color of block we are checking

            addi $t9, $zero, 4 # $t9 = 4
            addi $t8, $zero, 1 # $t8 = 1 (This is the counter for how many colors we have in a row)

          # First check for horizontal:

            check_left_loop_helper:

              beq $t9, $t8, delete_pixels_horizontal_helper
              bne $t5, $t6, check_right_helper
              

              # o.w. colors match:

              addi $t8, $t8, 1 # Add 1 to the counter
              addi $s4, $s4, -4 # Go one more pixel to the left 
              lw $t6, 0($s4) # Load color of block we are checking

              j check_left_loop_helper


            check_right_helper:

              # Reset $s4 & $t6

              addi $s4, $a3, 4 # Set $s2 to pixel of block we are checking
              lw $t6, 4($a3) # $t6 = Color of block we are checking

              check_right_loop_helper:
                
                beq $t9, $t8, delete_pixels_horizontal_helper
                bne $t5, $t6, check_up_helper

  
                # o.w. colors match:
  
                addi $t8, $t8, 1 # Add 1 to the counter
                add $s3, $s4, $zero, # Save rightmost pixel as this new one ($s3 = $s4)
                addi $s4, $s4, 4 # Go one more pixel to the right 
                lw $t6, 0($s4) # Load color of block we are checking
  
                j check_right_loop_helper


          # Check vertical:

            # $s3 now correspnds to the bottom most pixel with the same color

            check_up_helper:

              # Reset $s3, $s4, $t6, & $t8

              add $s3, $a3, $zero
              addi $s4, $a3, -128 # Set $s4 to pixel of block we are checking
              lw $t6, -128($a3) # $t6 = Color of block we are checking
              addi $t8, $zero, 1

              check_up_loop_helper:
                
                beq $t9, $t8, delete_pixels_vertical_helper
                bne $t5, $t6, check_down_helper
                
  
                # o.w. colors match:
  
                addi $t8, $t8, 1 # Add 1 to the counter
                addi $s4, $s4, -128 # Go one more pixel up 
                lw $t6, 0($s4) # Load color of block we are checking
  
                j check_up_loop_helper


            check_down_helper:

              addi $s4, $a3, 128 # Set $s4 to pixel of block we are checking
              lw $t6, 128($a3) # $t6 = Color of block we are checking

              check_down_loop_helper:

                beq $t9, $t8, delete_pixels_vertical_helper
                bne $t5, $t6, exit_collision_helper

  
                # o.w. colors match:
  
                addi $t8, $t8, 1 # Add 1 to the counter
                add $s3, $s4, $zero, # Save bottom-most pixel as this new one ($s3 = $s4)
                addi $s4, $s4, 128 # Go one more pixel down 
                lw $t6, 0($s4) # Load color of block we are checking
  
                j check_down_loop_helper
            

            delete_pixels_horizontal_helper:

              # Have 4 in a row to the left of $s3

              sw $zero, 0($s3)
              sw $zero, -4($s3)
              sw $zero, -8($s3)
              sw $zero, -12($s3)

              # Ned to check adjacent pixels to see if they need to be dropped
              addi $a0, $s3, 4
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -16
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -124
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -128
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -132
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -136
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -140
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3
              addi $a0, $s3, -144
              sw $a0, temp_var_3
              jal pull_block_down
              lw $a0, temp_var_3

              add $a0, $zero, $zero

              j exit_collision_helper

            delete_pixels_vertical_helper:

              # Have 4 in a row up from $s3

              sw $zero, 0($s3)
              sw $zero, -128($s3)
              sw $zero, -256($s3)
              sw $zero, -384($s3)

              # Ned to check adjacent pixels to see if they need to be dropped
              addi $a0, $s3, -4
              sw $a0, temp_var_4
              jal pull_block_down
              lw $a0, temp_var_4
              addi $a0, $s3, 4
              sw $a0, temp_var_4
              jal pull_block_down
              lw $a0, temp_var_4
              jal pull_block_down
              addi $a0, $s3, -132
              jal pull_block_down
              addi $a0, $s3, -124
              jal pull_block_down
              addi $a0, $s3, -260
              jal pull_block_down
              addi $a0, $s3, -252
              jal pull_block_down
              addi $a0, $s3, -388
              jal pull_block_down
              addi $a0, $s3, -380
              jal pull_block_down
              addi $a0, $s3, -516
              sw $a0, temp_var_4
              jal pull_block_down
              lw $a0, temp_var_4
              addi $a0, $s3, -512
              sw $a0, temp_var_4
              jal pull_block_down
              lw $a0, temp_var_4
              addi $a0, $s3, -508
              sw $a0, temp_var_4
              jal pull_block_down
              lw $a0, temp_var_4


              addi $a0, $zero, 1

          exit_collision_helper:

          

          lw $ra, 0($sp) # Load correct return address into $ra
          addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future

          jr $ra































update_locations_helper:

      addi $sp, $sp, -4 # Move to free slot in $sp
      sw $ra, 0($sp) # Store $ra into top of stack

      ##############################################

      # $s3 holds the location of the pixel that corresponds to rightmost/bottom-most of color row.
      # $a0 =  0 if the row is horizontal, and $a0 = 1 if vertical.

      # This will be used for horizontal row case
      add $t3, $zero, $zero # Loop iteration tracker
      addi $t4, $zero, 4 # Loop repition counter

      addi $s5, $s3, -128 # $s5 = $s3 - 128 (pixel above $s3) 
      add $s6, $s3, -512 # Gets the block up 4 pixels from $s3 (for vertical case)
      lw $t1, PURPLE_COLOR # Sets Register 1 to have purple color

      bne $a0, $zero update_location_loop_vertical_helper

      update_location_loop_horizontal_helper:

        # New iteration, so we update the pixel we need to check:
          lw $s4, 0($s5) # Store color of this block

          beq $s4, $zero, next_iteration_helper # If block is *not* black, we need to pull it down

        update_needed_horizontal_helper:
  
          # In this case, we know above pixel, $s4, is colored & needs to be moved down:

            beq $s4, $t1 next_iteration_helper  # If pixel is purp, move to next iteration
  
            # Store virus_array in $t9 And check if above pixel virus:
            lw $t9, virus_array 
            lw $t8, 0($t9) 
            beq $s5, $t8, update_location_loop_horizontal_helper # If above pixel is a virus, move next:
            lw $t8, 4($t9) 
            beq $s5, $t8, update_location_loop_horizontal_helper
            lw $t8, 8($t9) 
            beq $s5, $t8, update_location_loop_horizontal_helper
            lw $t8, 12($t9) 
            beq $s5, $t8, update_location_loop_horizontal_helper
            lw $t8, 16($t9) 
            beq $s5, $t8, update_location_loop_horizontal_helper
            lw $t8, 20($t9) 
            beq $s5, $t8, update_location_loop_horizontal_helper
  
            # OTHERWISE - Pixel does indeed need to be moved down:


            add $a0, $s5, $zero # Set $a0 = $s6, block we are pulling down
            jal pull_block_down
            addi $a0, $zero, 0 # Reset $a0 = 0, since we are in horizontal case
  
            # sw $s4, 128($s5)  # Move Pixel color down
            # sw $zero 0($s5) # And set the above pixel to black


            next_iteration_helper:

            # Move the block we need to check next to the left of what we just moved down:
            addi $t3, $t3, 1 # Need to go to next iteration.
            beq $t4, $t3 exit_update_helper # If we've reached 4 iterations, we're done
            addi $s5, $s5 -4 # Go left 1 more block
  
            j update_location_loop_horizontal_helper
          


      update_location_loop_vertical_helper:


        # New iteration, so we update the pixel we need to check:
          lw $s4, 0($s6) # Store color of this pixel

        beq $s4, $zero, exit_update_helper # If the pixel is black, dont need to update, so we exit

        update_needed_vertical_helper:

          # In this case, we know above pixel, $s6, is colored ($s4) & needs to be moved down:
            
            beq $s4, $t1 exit_update_helper  # If above pixel is purp, exit
  
            # Store virus_array in $t9 And check if above pixel virus:
            lw $t9, virus_array 
            lw $t8, 0($t9) 
            beq $s6, $t8,  exit_update_helper # If above pixel is a virus, exit:
            lw $t8, 4($t9) 
            beq $s6, $t8, exit_update_helper
            lw $t8, 8($t9) 
            beq $s6, $t8, exit_update_helper
            lw $t8, 12($t9) 
            beq $s6, $t8, exit_update_helper
            lw $t8, 16($t9) 
            beq $s6, $t8, exit_update_helper
            lw $t8, 20($t9) 
            beq $s6, $t8, exit_update_helper
  
            # OTHERWISE - Pixel does indeed need to be moved down: 

            add $a0, $s6, $zero # Set $a0 = $s6, block we are pulling down
            jal pull_block_down
            addi $a0, $zero, 1 # Reset $a0 = 1, since we are in vertical case
  
            # sw $s4, 512($s6)  # Move Pixel color down
            # sw $zero 0($s6) # And set the above pixel to black

            # Check collision of moved down pixel occurs in the pull_down helper so we're good:

            # Increment pixel up 1:
            addi $s6, $s6, -128
  
            j update_location_loop_vertical_helper


        exit_update_helper:

        lw $ra, 0($sp) # Load correct return address into $ra
        addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future

        jr $ra


gravity_helper:
  
        addi $sp, $sp, -4 # Move to free slot in $sp
        sw $ra, 0($sp) # Store $ra into top of stack
  
        ##############################################


          # MOVE DOWN

            bne $s2, $zero grav_horizontal # $s2 is horizontal, so go to horizontal case

            grav_vertical:

            # Check under pixel free:
              lw $t3, 128($t0) # $t3 has color of under pixel
  
              add $a0, $zero, $t3 # $a0 = $t3
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero exit_gravity_helper # If $v0 == 0, then pixel NOT free, so skip input.
              
            # pixel free so perform the movement:

              lw $t3, 0($t0) # $t3 has color of bottom pixel
              lw $t4, -128($t0) # $t4 has color of top pixel
              # Make previous pixels black:
              sw $zero, 0($t0)
              sw $zero, -128($t0)
              # Make new pixels colored:
              sw $t3, 128($t0)
              sw $t4, 0($t0)
  
              addi $t0, $t0, 128 # Moves the current position of the bottom pixel

              j exit_gravity_helper

            grav_horizontal:

            # Check pixel free:
              lw $t3, 128($t0) # $t3 has color of under pixel
  
              add $a0, $zero, $t3 # $a0 = $t3
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero exit_gravity_helper # If $v0 == 0, then pixel NOT free, so check collision instead.
              
              # Similarly Check bottom right pixel free:
              lw $t4, 132($t0) # $t4 has color of bottom right pixel
  
              add $a0, $zero, $t4 # $a0 = $t4
  
              jal check_pixel_free # Sets $v0 = 1 if pixel free
  
              beq $v0, $zero exit_gravity_helper # If $v0 == 0, then pixel NOT free, so skip input.
  
            # Both pixels free so perform the movement:

              lw $t3, 0($t0) # $t3 has color of bottom pixel
              lw $t4, 4($t0) # $t4 has color of right pixel
              # Make previous pixels black:
              sw $zero, 0($t0)
              sw $zero, 4($t0)
              # Make under and bottom right pixels colored:
              sw $t3, 128($t0)
              sw $t4, 132($t0)
  
              addi $t0, $t0, 128 # Moves the current position of the bottom pixel

              # Set $a3 = to pixel right of $t0 because we are in horizontal case & check for collision:
              addi $a3, $t0, 4 
              
              jal check_collision_helper
              
    

        exit_gravity_helper:

          # Set $a3 = to $t0, the pixel we want to check for a collision:
          add $a3, $t0, $zero 
          
          jal check_collision_helper

          lw $ra, 0($sp) # Load correct return address into $ra
          addi $sp, $sp, 4 # Move $sp to previous elmt in stack for future
  
          jr $ra




game_over:

    # Paint the whole scene back to black 

      addi $t2, $zero, 1023
      add $t0, $gp, $zero # Set $t0 to top left pixel 

      reset_display_loop_game_over:

        beq $t2, $zero, exit_reset_loop
        sw $zero, 0($t0) # Paints current pixel black
        addi $t0, $t0, 4 # Go to next pixel
        subi $t2, $t2, 1 # Decrement counter

        j reset_display_loop_game_over

      exit_reset_loop:

        # Now we paint GAME OVER & RESTART:

          add $t0, $gp, $zero # Reset $t0

          lw $t3, DARK_RED_COLOR
          
          sw $t3, 156($t0)
          sw $t3, 160($t0)
          sw $t3, 164($t0)
          sw $t3, 176($t0)
          sw $t3, 180($t0)
          sw $t3, 192($t0)
          sw $t3, 208($t0)
          sw $t3, 216($t0)
          sw $t3, 220($t0)
          sw $t3, 224($t0)

          sw $t3, 280($t0)
          sw $t3, 300($t0)
          sw $t3, 312($t0)
          sw $t3, 320($t0)
          sw $t3, 324($t0)
          sw $t3, 332($t0)
          sw $t3, 336($t0)
          sw $t3, 344($t0)

          sw $t3, 408($t0)
          sw $t3, 416($t0)
          sw $t3, 420($t0)
          sw $t3, 428($t0)
          sw $t3, 432($t0)
          sw $t3, 436($t0)
          sw $t3, 440($t0)
          sw $t3, 448($t0)
          sw $t3, 456($t0)
          sw $t3, 464($t0)
          sw $t3, 472($t0)
          sw $t3, 476($t0)
          sw $t3, 480($t0) 

          sw $t3, 536($t0)
          sw $t3, 548($t0)
          sw $t3, 556($t0)
          sw $t3, 568($t0)
          sw $t3, 576($t0)
          sw $t3, 592($t0)
          sw $t3, 600($t0)
          
          sw $t3, 668($t0)
          sw $t3, 672($t0)
          sw $t3, 676($t0)
          sw $t3, 684($t0)
          sw $t3, 696($t0)
          sw $t3, 704($t0)
          sw $t3, 720($t0)
          sw $t3, 728($t0)
          sw $t3, 732($t0)
          sw $t3, 736($t0)

          # OVER
          
          sw $t3, 1052($t0)
          sw $t3, 1056($t0)
          sw $t3, 1060($t0)
          sw $t3, 1072($t0)
          sw $t3, 1088($t0)
          sw $t3, 1096($t0)
          sw $t3, 1100($t0)
          sw $t3, 1104($t0)
          sw $t3, 1112($t0)
          sw $t3, 1116($t0)
          sw $t3, 1120($t0)

          sw $t3, 1176($t0)
          sw $t3, 1192($t0)
          sw $t3, 1200($t0)
          sw $t3, 1216($t0)
          sw $t3, 1224($t0)
          sw $t3, 1240($t0)
          sw $t3, 1248($t0)

          sw $t3, 1304($t0)
          sw $t3, 1320($t0)
          sw $t3, 1332($t0)
          sw $t3, 1340($t0)
          sw $t3, 1352($t0)
          sw $t3, 1356($t0)
          sw $t3, 1360($t0)
          sw $t3, 1368($t0)
          sw $t3, 1372($t0)

          sw $t3, 1432($t0)
          sw $t3, 1448($t0)
          sw $t3, 1460($t0)
          sw $t3, 1468($t0)
          sw $t3, 1480($t0)
          sw $t3, 1496($t0)
          sw $t3, 1504($t0)

          sw $t3, 1564($t0)
          sw $t3, 1568($t0)
          sw $t3, 1572($t0)
          sw $t3, 1592($t0)
          sw $t3, 1608($t0)
          sw $t3, 1612($t0)
          sw $t3, 1616($t0)
          sw $t3, 1624($t0)
          sw $t3, 1632($t0)

          # RESTART:
          lw $t3, WHITE_COLOR

          sw $t3, 2440($t0)
          sw $t3, 2444($t0)
          sw $t3, 2448($t0)
          sw $t3, 2456($t0)
          sw $t3, 2460($t0)
          sw $t3, 2464($t0)
          sw $t3, 2472($t0)
          sw $t3, 2476($t0)
          sw $t3, 2480($t0)
          sw $t3, 2488($t0)
          sw $t3, 2492($t0)
          sw $t3, 2496($t0)
          sw $t3, 2508($t0)
          sw $t3, 2512($t0)
          sw $t3, 2524($t0)
          sw $t3, 2528($t0)
          sw $t3, 2532($t0)
          sw $t3, 2540($t0)
          sw $t3, 2544($t0)
          sw $t3, 2548($t0)

          sw $t3, 2568($t0)
          sw $t3, 2576($t0)
          sw $t3, 2584($t0)
          sw $t3, 2600($t0)
          sw $t3, 2620($t0)
          sw $t3, 2632($t0)
          sw $t3, 2644($t0)
          sw $t3, 2652($t0)
          sw $t3, 2660($t0)
          sw $t3, 2672($t0)

          sw $t3, 2696($t0)
          sw $t3, 2700($t0)
          sw $t3, 2712($t0)
          sw $t3, 2716($t0)
          sw $t3, 2720($t0)
          sw $t3, 2728($t0)
          sw $t3, 2732($t0)
          sw $t3, 2736($t0)
          sw $t3, 2748($t0)
          sw $t3, 2760($t0)
          sw $t3, 2764($t0)
          sw $t3, 2768($t0)
          sw $t3, 2772($t0)
          sw $t3, 2780($t0)
          sw $t3, 2784($t0)
          sw $t3, 2800($t0)

          sw $t3, 2824($t0)
          sw $t3, 2832($t0)
          sw $t3, 2840($t0)
          sw $t3, 2864($t0)
          sw $t3, 2876($t0)
          sw $t3, 2888($t0)
          sw $t3, 2900($t0)
          sw $t3, 2908($t0)
          sw $t3, 2916($t0)
          sw $t3, 2928($t0)

          sw $t3, 2952($t0)
          sw $t3, 2960($t0)
          sw $t3, 2968($t0)
          sw $t3, 2972($t0)
          sw $t3, 2976($t0)
          sw $t3, 2984($t0)
          sw $t3, 2988($t0)
          sw $t3, 2992($t0)
          sw $t3, 3004($t0)
          sw $t3, 3016($t0)
          sw $t3, 3028($t0)
          sw $t3, 3036($t0)
          sw $t3, 3044($t0)
          sw $t3, 3056($t0)
          
          # GOLD BORDER:
          lw, $t3, GOLD_COLOR

          # Sides:
          
          sw $t3, 2304($t0)
          sw $t3, 2428($t0)
          sw $t3, 2432($t0)
          sw $t3, 2556($t0)
          sw $t3, 2560($t0)
          sw $t3, 2684($t0)
          sw $t3, 2688($t0)
          sw $t3, 2812($t0)
          sw $t3, 2816($t0)
          sw $t3, 2940($t0)
          sw $t3, 2944($t0)
          sw $t3, 3068($t0)
          sw $t3, 3072($t0)
          sw $t3, 3196($t0)

          # Top rows:

                  addi $t4, $zero, 2 # $t4 = 4
                  addi $t7, $zero, 30 # $t7 = 30
                  add $t5, $zero, $zero # $t5 = 0, this is the outer loop counter
        
                  # Get $t0 ready:
                    addi $t0, $gp, 1276
        
                  game_over_horizontal_outer_loop:
  
                    beq $t5, $t4, game_over_wait_loop # Branch out, all rows gold.
        
                    add $t6, $zero, $zero # Inner loop counter
                    addi $t5, $t5, 1 # Increment outer loop counter
        
                    addi $t0, $t0, 904
        
                    game_over_horizontal_inner_loop:
        
                      beq $t6, $t7, game_over_horizontal_outer_loop 
                      
                      sw $t3, 0($t0) # Paint current gold
        
                      addi $t0, $t0, 4 # Move to the next right pixel
                      addi $t6, $t6, 1 # Increment inner loop counter
        
                      j game_over_horizontal_inner_loop
          

            game_over_wait_loop:

              lw $s1, ADDR_KBRD # $s1 holds the keyboard status
              lb $t2, 0($s1) # $t2 == 1 if key pressed, so:
              beq $t2, $zero, game_over_wait_loop # Skip key press code if no key was pressed

              lb $t2, 4($s1)

              beq $t2, 0x20, main
              beq $t2, 0x52, main
              beq $t2, 0x72, main

              j game_over_wait_loop # Unmapped key, so go back to loop
          
  