
const _ = require( 'wTools' );
_.include( 'wFiles' );

function actionWrite( o )
{
  o = _.routine.optionsWithUndefined( actionWrite, o || Object.create( null ) );

  const appArgs = _.process.input();
  _.process.inputReadTo
  ({
    dst : o,
    propertiesMap : appArgs.map,
    namesMap : _.map.keys( actionWrite.defaults ),
  });

  /* */

  const willfilePath = _.path.join( __dirname, '../will.yml' );
  const willfile = _.fileProvider.fileReadUnknown( willfilePath );
  willfile.about.version = o.version;

  if( o.logger >= 3 )
  console.log( `Updating willfile. Setup version "${ o.version }".` );

  if( !o.dry )
  _.fileProvider.fileWrite({ filePath : willfilePath, data : willfile, encoding : 'yaml' });

  /* */

  const actionPath = _.path.join( __dirname, '../action.yml' );
  const action = _.fileProvider.fileReadUnknown( actionPath );
  action.runs.steps[ 0 ].uses = `Wandalen/wretry.action@v${ o.version }_js_action`;

  if( o.logger >= 3 )
  console.log( `Updating action. Setup used action version to "Wandalen/wretry.action@v${ o.version }_js_action".` );

  if( !o.dry )
  _.fileProvider.fileWrite({ filePath : actionPath, data : action, encoding : 'yaml' });
}

let defaults = actionWrite.defaults = Object.create( null );
defaults.version = null;
defaults.logger = 2;
defaults.dry = 0;

//

const step = actionWrite;
module.exports = step;
if( !module.parent )
step();
