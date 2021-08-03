const _ = require( 'wTools' );
_.include( 'wGitTools' );

//

function remotePathFromActionName( name )
{
  return _.git.path.parse( `https://github.com/${ _.strReplace( name, '@', '!' ) }` );
}

//

function actionClone( localPath, remotePath )
{
  _.git.repositoryClone
  ({
    remotePath,
    localPath,
    sync : 1,
    attemptDelayMultiplier : 4,
  });

  _.git.tagLocalChange
  ({
    localPath,
    tag : remotePath.tag,
  });
}

//

function actionConfigRead( actionDir )
{
  return _.fileProvider.fileRead
  ({
    filePath : _.path.join( actionDir, 'action.yml' ),
    encoding : 'yaml',
  });
}

//

function actionOptionsParse( src )
{
  const result = Object.create( null );
  for( let i = 0 ; i < src.length ; i++ )
  {
    const splits = src[ i ].split( ':' );
    result[ splits[ 0 ].trim() ] = splits[ 1 ].trim();
  }
  return result;
}

//

function envOptionsFrom( options )
{
  const result = Object.create( null );
  for( let key in options )
  result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = options[ key ];
  return result;
}

//

function envOptionsSetup( options )
{
  for( let key in options )
  {
    core.exportVariable( key, options[ key ] );
    process.env[ key ] = options[ key ];
  }
}

// --
// export
// --

const Self =
{
  remotePathFromActionName,
  actionClone,
  actionConfigRead,
  actionOptionsParse,
  envOptionsFrom,
  envOptionsSetup,
};

module.exports = Self;

