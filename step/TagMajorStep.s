
function majorTagSet( frame )
{
  const run = frame.run;
  const module = run.module;

  const splits = module.about.version.split( '.' );
  const version = splits[ 0 ];

  return module.gitTag
  ({
    tag : `v${ version }`,
    description : '',
    dry : 0,
    light : 1,
  });
}

module.exports = majorTagSet;
