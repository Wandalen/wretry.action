
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
}

module.exports = actionWrite;
