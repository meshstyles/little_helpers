const { argv } = require('yargs')

if (argv.hex) {
    let hex = argv.hex;
    if (hex.charAt(0) === '#') {
        hex = hex.substr(1, 6);
    }

    let hexr = hex.substr(0, 2);
    let hexg = hex.substr(2, 2);
    let hexb = hex.substr(4, 5);
    console.log(`#${hex}`);

    let decr = parseInt(hexr, 16);
    let decg = parseInt(hexg, 16);
    let decb = parseInt(hexb, 16);
    console.log(`\(${decr}, ${decg}, ${decb}, 255\)`)

    let floatr = (decr / 255).toFixed(3).replace('.', ',');
    let floatg = (decg / 255).toFixed(3).replace('.', ',');
    let floatb = (decb / 255).toFixed(3).replace('.', ',');
    console.log(`\(${floatr}; ${floatg}; ${floatb}; 1,0\)`);
}

if (argv.floatr && argv.floatg && argv.floatb) {
    let decr = parseInt((argv.floatr * 255).toFixed(0));
    let decg = parseInt((argv.floatg * 255).toFixed(0));
    let decb = parseInt((argv.floatb * 255).toFixed(0));

    console.log(`#${decr.toString(16)}${decg.toString(16)}${decb.toString(16)}`);

    console.log(`\(${decr}, ${decg}, ${decb}, 255\)`)

    console.log(`\(${parseFloat(argv.floatr).toFixed(3).replace('.', ',')}; ${parseFloat(argv.floatg).toFixed(3).replace('.', ',')}; ${parseFloat(argv.floatb).toFixed(3).replace('.', ',')}; 1,0\)`);

}

if (argv.decr && argv.decg && argv.decb) {
    console.log(`#${argv.decr.toString(16)}${argv.decg.toString(16)}${argv.decb.toString(16)}`);

    console.log(`\(${argv.decr}, ${argv.decg}, ${argv.decb}, 255\)`);

    let floatr = (argv.decr / 255).toFixed(3).replace('.', ',');
    let floatg = (argv.decg / 255).toFixed(3).replace('.', ',');
    let floatb = (argv.decb / 255).toFixed(3).replace('.', ',');
    console.log(`\(${floatr}; ${floatg}; ${floatb}; 1,0\)`);
}
