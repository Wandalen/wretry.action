
function actionWrite( frame )
{
  const run = frame.run;
  const module = run.module;
  const will = module.will;
  const fileProvider = will.fileProvider;
  const logger = will.transaction.logger;
  const opener = module.toOpener();

  /* */

  logger.log( `Updating willfile. Setup version "${ module.about.version }".` );

  const commonPath = fileProvider.path.common( opener.openedModule.willfilesPath );
  will.willfilePropertySet
  ({
    commonPath,
    request: '',
    selectorsMap: { 'about/version' : module.about.version },
  });

  /* */

  const subdirectories = [ '', 'main', 'pre', 'post' ];
  for( let i = 0 ; i < subdirectories.length ; i++ )
  {
    const slash = subdirectories[ i ] === '' ? '' : '/';
    const actionRelativePath = `${ subdirectories[ i ] }${ slash }action.yml`;
    const actionPath = fileProvider.path.join( module.dirPath, actionRelativePath );
    const action = fileProvider.fileReadUnknown( actionPath );
    action.runs.steps[ 0 ].uses = `Youloveit-Org/wretry.action${ slash }${ subdirectories[ i ] }@v${ module.about.version }_js_action`;

    logger.log( `Updating action file "${ actionRelativePath }". Setup action version to "${ action.runs.steps[ 0 ].uses }".` );

    fileProvider.fileWrite({ filePath : actionPath, data : action, encoding : 'yaml' });
  }
}

module.exports = actionWrite;
