function main() {
    const input = ['1', 4, 3]
    const displayValue = input[0];
    const characterLength = input[1];
    const loopLength = input[2];
    let output = ''
    for (let loop = 0; loop < loopLength; loop++) {
        for (let char = 0; char < characterLength; char++) {
            for (let i = 0; i < char; i++) {
                output += displayValue;
            }
            output += '\n'
        }
        for (let char = characterLength; char >= 1; char--) {
            for (let i = 0; i < char; i++) {
                output += displayValue;
            }
            output += '\n'
        }
        output = output.trim()
    }
    console.log(output)

}
main()