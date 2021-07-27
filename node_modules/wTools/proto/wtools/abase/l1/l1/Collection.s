( function _l1_Collection_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.collection = _.collection || Object.create( null );

// --
// implementation
// --

function _commandPreform( command, commandRoutine, commandPhrase )
{
  let aggregator = this;

  if( commandRoutine === null )
  commandRoutine = command.routine || command.e;
  if( command === null )
  command = commandRoutine.command || Object.create( null );

  if( command.phrase )
  command.phrase = aggregator.vocabulary.phraseNormalize( command.phrase );
  if( commandPhrase )
  commandPhrase = aggregator.vocabulary.phraseNormalize( commandPhrase );
  commandPhrase = commandPhrase || command.phrase || ( commandRoutine.command ? commandRoutine.command.phrase : null ) || null;

  if( commandRoutine && commandRoutine.command )
  if( command !== commandRoutine.command )
  {
    _.assert( _.aux.is( commandRoutine.command ) );
    if( commandRoutine.command.phrase )
    commandRoutine.command.phrase = aggregator.vocabulary.phraseNormalize( commandRoutine.command.phrase );
    for( let k in commandRoutine.command )
    {
      _.assert
      (
        !_.props.has( command, k ) || command[ k ] === commandRoutine.command[ k ]
        , () => `Inconsistent field "${k}" of command "${commandPhrase}"`
      );
      command[ k ] = commandRoutine.command[ k ];
    }
    delete commandRoutine.command;
  }

  /* qqq : fill in asserts explanations */
  _.assert
  (
    !command.aggregator,
    () => `Command "${command.phrase}" already associated with a command aggregator.`
    + ` Each Command should be used only once.`
  );
  _.assert( _.routine.is( commandRoutine ), `Command "${commandPhrase}" does not have defined routine.` );
  _.assert( _.aux.is( command ) );
  _.assert( !_.props.has( command, 'ro' ) || commandRoutine === command.ro ); /* xxx : rename e to ro? */
  _.assert( !_.props.has( command, 'routine' ) || commandRoutine === command.routine );
  _.assert
  (
    !_.props.has( command, 'phrase' ) || commandPhrase === command.phrase,
    () => `Command ${commandPhrase} has phrases mismatch ${commandPhrase} <> ${command.phrase}`
  );
  _.assert( !_.props.own( commandRoutine, 'command' ) || commandRoutine.command === command );
  _.map.assertHasOnly( command, aggregator.CommandAllFields );

  if( commandPhrase )
  command.phrase = commandPhrase;
  command.routine = commandRoutine;
  commandRoutine.command = command;
  aggregator._CommandShortFiledsToLongFields( command, command );

  return command;

  /* - */

  function _CommandShortFiledsToLongFields( dst, fields )
  {
    _.assert( arguments.length === 2 );
    let filter = Self.CommandShortToLongFields;
    for( let k in fields )
    {
      if( _.props.has( filter, k ) )
      {
        _.assert
        (
          !_.props.has( dst, filter[ k ] ) || dst[ filter[ k ] ] === fields[ k ]
          , () => `Inconsistent field "${k}" of command "${commandPhraseGet()}"`
        );
        _.assert( !_.props.has( dst, filter[ k ] ) || dst[ filter[ k ] ] === fields[ k ] );
        dst[ filter[ k ] ] = fields[ k ];
        delete fields[ k ];
      }
    }

    function commandPhraseGet()
    {
      return dst.phrase || ( dst.command ? dst.command.phrase : null ) || null;
    }
  }

}

//

function toMapOfHandles( commandMap )
{
  let aggregator = this;
  let result = Object.create( null );
  let visited = new Set();

  if( _.aux.is( commandMap ) )
  {
    for( let k in commandMap )
    {
      let command = commandMap[ k ];
      let commandRoutine = command;

      if( _.routine.is( commandRoutine ) )
      command = null;
      else
      commandRoutine = command.ro || command.routine;

      let commandPhrase = aggregator.vocabulary.phraseNormalize( k );
      command = aggregator._commandPreform( command, commandRoutine, commandPhrase );
      command.aggregator = aggregator;
      aggregator.commandValidate( command );

      _.assert
      (
        !visited.has( command.routine ),
        `Duplication of command "${command.phrase}"`
      );
      visited.add( command.routine );

      result[ command.phrase ] = command;
    }
  }
  else if( _.longIs( commandMap ) )
  {
    for( let k = 0 ; k < commandMap.length ; k++ )
    {
      let command = commandMap[ k ];
      let commandRoutine = command;
      if( _.routine.is( commandRoutine ) )
      command = null;
      else
      commandRoutine = command.ro || command.routine;

      command = aggregator._commandPreform( command, commandRoutine );
      command.aggregator = aggregator;
      aggregator.commandValidate( command );

      _.assert
      (
        !visited.has( command.routine ),
        `Duplication of command "${command.phrase}"`
      );
      visited.add( command.routine );

      result[ command.phrase ] = command;
    }
  }
  else _.assert( 0 );

  _.assert( _.aux.is( result ) );

  return result;

  /* - */

  function commandIs( src )
  {
    if( !_.aux.is( src ) )
    return false;
    if( src.handle === undefined )
    return false;
    return true;
  }

  /* - */

  function commandValidate( command )
  {
    let aggregator = this;
    _.assert( aggregator.commandIs( command ), 'Not a command' );
    _.assert( _.routineIs( command.routine ) );
    _.assert( command.routine.command === command );
    _.assert( _.strDefined( command.phrase ) );
    _.assert( command.aggregator === undefined || command.aggregator === aggregator );
    if( _.routineIs( command.routine ) )
    _.map.assertHasOnly( command.routine, aggregator.CommandRoutineFields, 'Command routine should not have redundant fields' );
    _.map.assertHasOnly( command, aggregator.CommandNormalFields, 'Command should not have' );
    return true;
  }

  /* - */

  function _commandMapValidate( commandMap )
  {
    let aggregator = this;
    _.assert( _.mapIs( commandMap ) );
    for( let k in commandMap )
    {
      let command = commandMap[ k ]
      aggregator.commandValidate( command );
    }
    return commandMap;
  }

  /* - */

}

// --
// extension
// --

let ToolsExtension =
{

}

//

let ExtensionMap =
{

  toMapOfHandles,

}

Object.assign( _, ToolsExtension );
Object.assign( _.collection, ExtensionMap );
_.assert( _.aux.is( _.collection ) );

})();
