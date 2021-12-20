const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

//

function remotePathFromActionName( name )
{
  return _.git.path.parse( `https://github.com/${ _.strReplace( name, '@', '!' ) }` );
}

//

function actionClone( localPath, remotePath )
{
  const con = _.take( null );
  con.then( () =>
  {
    return _.git.repositoryClone
    ({
      remotePath,
      localPath,
      sync : 0,
      attemptLimit : 4,
      attemptDelay : 500,
      attemptDelayMultiplier : 4,
    });
  });
  con.then( () =>
  {
    return _.git.tagLocalChange
    ({
      localPath,
      tag : remotePath.tag,
      sync : 0
    });
  });
  return con;
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
    const splits = _.strStructureParse({ src : src[ i ], toNumberMaybe : 0 });
    _.map.extend( result, splits );
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

