# Binary to Decimal Converter for RISC-V CPU
# Haley Lind & Michael Stewart
# CSCE611 Fall 2025

# Read input, should be resetable with key0
csrrw t0, 0xF02, zero       
andi t0, t0, 0xFF           # t0 = input value (0-255)

# Algorithm: Extract decimal digits by dividing by powers of 10
# For 3-digit decimal (0-255):
#   hundreds = value / 100
#   tens = (value % 100) / 10
#   ones = value % 10

# --- Get HUNDREDS digit ---
li t1, 100                  # t1 = 100
div t2, t0, t1              # t2 = t0 / 100 (hundreds digit)
mul t3, t2, t1             
sub t0, t0, t3  

li t1, 10
div t3, t0, t1       
mul t4, t3, t1              
sub t0, t0, t4 

# Now: t2 = hundreds, t3 = tens, t0 = ones

# --- Pack digits for HEX display ---
# We need to pack three 4-bit values into one 32-bit word
# Format: 0x00000HTO where H=hundreds, T=tens, O=ones
# Each digit occupies one nibble (4 bits)

slli t2, t2, 8              # hundreds << 8 (move to bits [11:8])
slli t3, t3, 4              # tens << 4 (move to bits [7:4])
# ones is already in bits [3:0]

or t4, t2, t3               # Combine hundreds and tens
or t4, t4, t0               # Add ones digit

# Result in t4: 0x00000HTO
csrrw zero, 0xF00, t4       # Write to GPIO output register 0xF00

# --- Loop forever (halt) ---
# Since we don't have branch/jump, just do some no-ops
addi zero, zero, 0
addi zero, zero, 0
addi zero, zero, 0
addi zero, zero, 0
