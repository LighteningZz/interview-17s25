const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})

const question = (questionText) => {
    return new Promise((resolve, reject) => {
        rl.question(`${questionText} : `, answer => {
            const value = Number(answer);
            if (isNaN(value)) {
                reject("value must be number.")
            }
            resolve(value);
            rl.pause()
        })
    })
}

async function main() {
    const displayValue = await question('display value');
    const characterLength = await question('character length');
    const loopLength = await question('loop length');
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
    rl.close();
    console.log(output)

}
main().catch(console.error);