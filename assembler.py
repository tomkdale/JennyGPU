registers = {
    "zi": "000000",
    "i0": "000001",
    "i1": "000010",
    "i2": "000011",
    "i3": "000100",
    "i4": "000101",
    "i5": "000110",
    "i6": "000111",
    "i7": "001000",
    "i8": "001001",
    "i9": "001010",
    "br": "001011",
    "pc": "001100",
    "zs": "001101",
    "s0": "001110",
    "s1": "001111",
    "s2": "010000",
    "s3": "010001",
    "s4": "010010",
    "s5": "010011",
    "s6": "010100",
    "s7": "010101",
    "s8": "010110",
    "s9": "010111",
    "zv": "011000",
    "v0": "011001",
    "v1": "011010",
    "v2": "011011",
    "v3": "011100",
    "v4": "011101",
    "v5": "011110",
    "v6": "011111",
    "v7": "100000",
    "v8": "100001",
    "v9": "100010"
}


def strip_commas(arguments):
    output = []
    for arg in arguments:
        output.append(arg.replace(',', '').lower())
    return output


def binToHex(binary, width=6):
    return '{:0{width}x}'.format(int(binary, 2), width=width)


# Binary op_code, string register, integer immediate
def from_immediate(op_code, destination, immediate):
    destinationBinary = registers[destination]
    immediateBinary = ""
    if immediate.startswith("0x"):  # Hex location
        immediateBinary = '{:0{width}b}'.format(int(immediate[2:], 16), width=12)
    elif immediate.startswith("0b"):  # Binary location
        immediateBinary = '{:0{width}b}'.format(int(immediate[2:], 2), width=12)
    else:  # Integer location
        immediateBinary = '{:0{width}b}'.format(int(immediate), width=12)
    outputBinary_ = op_code + destinationBinary + immediateBinary
    outputHex_ = binToHex(outputBinary_)
    return outputBinary_, outputHex_


# Binary op_code, string register, string register, string register
def from_three_regs(op_code, destination, register1, register2):
    destinationBinary = registers[destination]
    register1Binary = registers[register1]
    register2Binary = registers[register2]
    outputBinary_ = op_code + destinationBinary + register1Binary + register2Binary
    outputHex_ = binToHex(outputBinary_)
    return outputBinary_, outputHex_

while True:
    input_ = input()
    if input_.startswith("//") or input_ == "":
        continue
    args = strip_commas(input_.split())
    arg_count = len(args)
    if arg_count > 0:
        operation = args[0].lower()
        if operation == "vadd":
            opCode = "000000"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])

        elif operation == "vsub":
            opCode = "000001"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])

        elif operation == "vaddi":
            opCode = "000010"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "vsubi":
            opCode = "000011"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "tran":
            opCode = "000100"
            destination = registers[args[1]]
            reg1 = registers[args[2]]
            outputBinary = opCode + "000000" + destination + reg1
            outputHex = binToHex(outputBinary)
            print(outputBinary + " " + outputHex)

        elif operation == "sadd":
            opCode = "000101"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])

        elif operation == "ssub":
            opCode = "000110"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])

        elif operation == "saddi":
            opCode = "000111"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "ssubi":
            opCode = "001000"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "and":
            opCode = "001001"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])
        elif operation == "or":
            opCode = "001010"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])
        elif operation == "not":
            opCode = "001011"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])
        elif operation == "vtos":
            opCode = "001100"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])

        elif operation == "stov":
            opCode = "001101"
            vals = from_three_regs(opCode, args[1], args[2], args[3])
            print(vals[0] + " " + vals[1])

        elif operation == "smov":
            opCode = "001110"
            destination = registers[args[1]]
            reg1 = registers[args[2]]
            outputBinary = opCode + "000000" + destination + reg1
            outputHex = binToHex(outputBinary)
            print(outputBinary + " " + outputHex)

        elif operation == "vmov":
            opCode = "001111"
            destination = registers[args[1]]
            reg1 = registers[args[2]]
            outputBinary = opCode + "000000" + destination + reg1
            outputHex = binToHex(outputBinary)
            print(outputBinary + " " + outputHex)

        elif operation == "loadi":
            opCode = "010000"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "loads":
            opCode = "010001"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])
        elif operation == "loadv":
            opCode = "010010"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])
        elif operation == "savei":
            opCode = "010011"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])
        elif operation == "saves":
            opCode = "010100"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])
        elif operation == "savev":
            opCode = "010101"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])
        elif operation == "branch":
            opCode = "010110"
            memoryLocation = args[1]
            memoryBinary = ""
            if memoryLocation.startswith("0x"):    # Hex location
                memoryBinary = '{:0{width}b}'.format(int(memoryLocation[2:], 16), width=18)
            elif memoryLocation.startswith("0b"):  # Binary location
                memoryBinary = '{:0{width}b}'.format(int(memoryLocation[2:], 2), width=18)
            else:                                  # Integer location
                memoryBinary = '{:0{width}b}'.format(int(memoryLocation), width=18)

            outputBinary = opCode + memoryBinary
            outputHex = binToHex(outputBinary)
            print(outputBinary + " " + outputHex)
        elif operation == "iaddi":
            opCode = "010111"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "iset":
            opCode = "011000"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "sset":
            opCode = "011001"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "vset":
            opCode = "011010"
            vals = from_immediate(opCode, args[1], args[2])
            print(vals[0] + " " + vals[1])

        elif operation == "vmake":
            opCode = "011011"
            destination = registers[args[1]]
            reg1 = registers[args[2]]
            outputBinary = opCode + "000000" + destination + reg1
            outputHex = binToHex(outputBinary)
            print(outputBinary + " " + outputHex)

        elif operation == "sum":
            opCode = "011100"
            destination = registers[args[1]]
            reg1 = registers[args[2]]
            outputBinary = opCode + "000000" + destination + reg1
            outputHex = binToHex(outputBinary)
            print(outputBinary + " " + outputHex)

        else:
            print("Bad instruction - Unknown instruction")

    else:
        print("Bad instruction - no args")