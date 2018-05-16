registers = {
    "z":   "000000",
    "v0":  "000001",
    "v1":  "000010",
    "v2":  "000011",
    "v3":  "000100",
    "v4":  "000101",
    "v5":  "000110",
    "v6":  "000111",
    "v7":  "001000",
    "v8":  "001001",
    "v9":  "001010",
    "v10": "001011",
    "v11": "001110",
    "v12": "001111",
    "v13": "010000",
    "v14": "010001",
    "v15": "010010",
    "v16": "010011",
    "v17": "010100",
    "v18": "010101",
    "v19": "010110",
    "cr":  "010111",
    "b0":  "011000",
    "b1":  "011001",
    "b2":  "011010",
    "b3":  "011011",
    "b4":  "011100",
    "b5":  "011101",
    "b6":  "011110",
    "b7":  "011111",
    "b8":  "100000",
    "b9":  "100001"
}

choice = "2"


def print_binary_and_hex(binary_out, hex_out):
    if choice == "0":
        print(binary_out)
    elif choice == "1":
        print(hex_out)
    else:
        print(binary_out + " " + hex_out)


def strip_commas(arguments):
    output = []
    for arg in arguments:
        output.append(arg.replace(',', '').lower())
    return output


def binToHex(binary, width=8):
    return '{:0{width}x}'.format(int(binary, 2), width=width)


def reg_enable_to_binary(reg_enable):
    if reg_enable.startswith("0x"):  # Hex location
        return '{:0{width}b}'.format(int(reg_enable[2:], 16), width=4)
    elif reg_enable.startswith("0b"):  # Binary location
        return '{:0{width}b}'.format(int(reg_enable[2:], 2), width=4)
    else:  # Integer location
        return '{:0{width}b}'.format(int(reg_enable), width=4)


# Binary op_code, string register, integer immediate
def from_immediate_and_reg_enable(op_code, destination, immediate, reg_enable):
    destinationBinary = registers[destination]
    if immediate.startswith("0x"):  # Hex location
        immediateBinary = '{:0{width}b}'.format(int(immediate[2:], 16), width=16)
    elif immediate.startswith("0b"):  # Binary location
        immediateBinary = '{:0{width}b}'.format(int(immediate[2:], 2), width=16)
    else:  # Integer location
        immediateBinary = '{:0{width}b}'.format(int(immediate), width=16)
    outputBinary_ = reg_enable_to_binary(reg_enable) + op_code + destinationBinary + immediateBinary
    outputHex_ = binToHex(outputBinary_)
    return outputBinary_, outputHex_


# Binary op_code, string register, string register, string register
def from_three_regs_and_reg_enable(op_code, destination, register1, register2, reg_enable):
    destinationBinary = registers[destination]
    register1Binary = registers[register1]
    register2Binary = registers[register2]
    outputBinary = reg_enable_to_binary(reg_enable) + op_code + destinationBinary + register1Binary + register2Binary + "0000"
    outputHex = binToHex(outputBinary)
    return outputBinary, outputHex


def run_assembler():
    while True:
        input_ = input()
        if input_.startswith("//") or input_ == "":
            continue
        args = strip_commas(input_.split())
        arg_count = len(args)
        if arg_count > 0:
            operation = args[0].lower()
            if operation == "vadd":
                op_code = "000000"
                vals = from_three_regs_and_reg_enable(op_code, args[1], args[2], args[3], args[4])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "vsub":
                op_code = "000001"
                vals = from_three_regs_and_reg_enable(op_code, args[1], args[2], args[3], args[4])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "vmult":
                op_code = "000010"
                vals = from_three_regs_and_reg_enable(op_code, args[1], args[2], args[3], args[4])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "vdiv":
                op_code = "000011"
                vals = from_three_regs_and_reg_enable(op_code, args[1], args[2], args[3], args[4])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "vmod":
                op_code = "000100"
                vals = from_three_regs_and_reg_enable(op_code, args[1], args[2], args[3], args[4])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "blt":
                op_code = "000101"
                reg_enable = args[4]
                br_reg = registers[args[1]]
                reg1 = registers[args[2]]
                reg2 = registers[args[3]]
                outputBinary = reg_enable_to_binary(reg_enable) + op_code + br_reg + reg1 + reg2 + "0000"
                outputHex = binToHex(outputBinary)
                print_binary_and_hex(outputBinary, outputHex)

            elif operation == "rot":
                op_code = "000110"
                reg_enable = args[4]
                reg1 = registers[args[1]]
                reg2 = registers[args[2]]
                rot = '{:0{width}b}'.format(int(args[3]), width=2)
                outputBinary = reg_enable_to_binary(reg_enable) + op_code + reg1 + reg2 + rot + "00000000"
                outputHex = binToHex(outputBinary)
                print_binary_and_hex(outputBinary, outputHex)

            elif operation == "j":
                op_code = "000111"
                immediate = args[1]
                if immediate.startswith("0x"):  # Hex location
                    destination = '{:0{width}b}'.format(int(immediate[2:], 16), width=16)
                elif immediate.startswith("0b"):  # Binary location
                    destination = '{:0{width}b}'.format(int(immediate[2:], 2), width=16)
                else:  # Integer location
                    destination = '{:0{width}b}'.format(int(immediate), width=16)
                outputBinary = "0000" + op_code + "000000" + destination
                outputHex = binToHex(outputBinary)
                print_binary_and_hex(outputBinary, outputHex)

            elif operation == "vaddi":
                op_code = "001000"
                vals = from_immediate_and_reg_enable(op_code, args[1], args[2], args[3])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "loadv":
                op_code = "001001"
                vals = from_immediate_and_reg_enable(op_code, args[1], args[2], args[3])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "savev":
                op_code = "001010"
                vals = from_immediate_and_reg_enable(op_code, args[1], args[2], args[3])
                print_binary_and_hex(vals[0], vals[1])

            elif operation == "setb":
                op_code = "001011"
                reg1 = registers[args[1]]

                immediate = args[2]
                if immediate.startswith("0x"):  # Hex location
                    branch = '{:0{width}b}'.format(int(immediate[2:], 16), width=16)
                elif immediate.startswith("0b"):  # Binary location
                    branch = '{:0{width}b}'.format(int(immediate[2:], 2), width=16)
                else:  # Integer location
                    branch = '{:0{width}b}'.format(int(immediate), width=16)

                outputBinary = "0000" + op_code + reg1 + branch
                outputHex = binToHex(outputBinary)
                print_binary_and_hex(outputBinary, outputHex)

            elif operation == "br":
                op_code = "001100"
                reg1 = registers[args[1]]
                outputBinary = "0000" + op_code + reg1 + "0000000000000000"
                outputHex = binToHex(outputBinary)
                print_binary_and_hex(outputBinary, outputHex)

            elif operation == "nop":
                print_binary_and_hex("00000000000000000000000000000000", "00000000")

            else:
                print("Bad instruction - Unknown instruction: " + input_)

        else:
            print("Bad instruction - no args with instruction: " + input_)

print("What should be output?")
print("0 - Only binary instructions")
print("1 - Only hex instructions")
print("2 - Both binary and hex instructions")
input_choice = input()

if input_choice == "0":
    choice = "0"
elif input_choice == "1":
    choice = "1"
print()
run_assembler()
