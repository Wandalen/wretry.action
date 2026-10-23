// Node 24 changed the fs.Stats prototype chain, which breaks wFilesBasic fileStatIs; restore it.
const fs = require( 'fs' );
const StatsBase = Object.getPrototypeOf( Object.getPrototypeOf( fs.statSync( '.', { bigint : true } ) ) ).constructor;
Object.setPrototypeOf( fs.Stats, StatsBase );
