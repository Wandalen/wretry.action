require( process.argv[ 2 ] )
process.on( 'exit', () => process.send( process.env ) );
