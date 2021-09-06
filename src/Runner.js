
/* this branch exists because some MacOs NodeJs instances cannot send big messages */
if( process.platform === 'darwin' )
{
  let initEnvs = Object.assign( Object.create( null ), process.env );

  require( process.argv[ 2 ] )

  process.on( 'exit', () =>
  {
    let result = Object.create( null );
    for( let key in process.env )
    if( ( !key in initEnvs ) || initEnvs[ key ] !== process.env[ key ] )
    result[ key ] = process.env[ key ];

    process.send( result );
  });
}
else
{
  require( process.argv[ 2 ] )
  process.on( 'exit', () => process.send( process.env ) );
}

