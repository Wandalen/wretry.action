(function _LoggerBasic_s_()
{

'use strict';

/**
 * @classdesc Describes basic abilities of the printer: input transformation, verbosity level change.
 * @class wLoggerBasic
 * @namespace Tools
 * @module Tools/base/Logger
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wLoggerBasic;
function wLoggerBasic( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerBasic';

// --
// inter
// --

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );

  if( self[ chainerSymbol ] === undefined )
  self[ chainerSymbol ] = null;

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  return self;
}

// --
// transform
// --

function transform_head( routine, args )
{
  let self = this;
  let o = args[ 0 ];

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );
  _.map.assertHasAll( o, routine.defaults );

  o.output = null;
  o.discarding = false;

  if( o.originalInput === undefined || o.originalInput === null )
  o.originalInput = o.input;
  if( o.joinedInput === undefined || o.joinedInput === null )
  o.joinedInput = self._strConcat( o.input );

  return o;
}

function transform_body( o )
{
  let self = this;

  // _.map.assertHasAll( o, transform_body.defaults );

  let o2 = self._transformBegin( o );
  _.assert( o2 === o );

  if( o.discarding )
  return o;

  let o3 = self._transformAct( o );
  _.assert( o3 === o );

  if( o.discarding )
  return o;

  _.assert( _.mapIs( o ) );
  _.assert( _.longIs( o.input ) );

  let o4 = self._transformEnd( o );
  _.assert( o4 === o );

  return o;
}

transform_body.defaults =
{
  input : null,
}

let transform = _.routine.uniteCloning_replaceByUnite( transform_head, transform_body );

//

function _transformBegin( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.map.assertHasAll( o, self.transform.defaults );

  o.output = null;
  o.discarding = false;

  if( o.originalInput === undefined || o.originalInput === null )
  o.originalInput = o.input;
  if( o.joinedInput === undefined || o.joinedInput === null )
  o.joinedInput = self._strConcat( o.input );

  if( self.onTransformBegin )
  {
    let o2 = self.onTransformBegin( o );
    _.assert( o2 === o, 'Callback::onTransformBegin should return the argument' );
  }

  if( o.discarding )
  return o;

  return o;
}

//

function _transformAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.longIs( o.input ) );

  // o.outputSplitted;
  // o._outputForPrinter = [ o.joinedInput ];
  // o._outputForTerminal = [ o.joinedInput ];

  // /* !!! remove later */
  //
  // _.accessor.forbid
  // ({
  //   object : o,
  //   names :
  //   {
  //     output : 'output',
  //   }
  // });

  return o;
}

//

function _transformEnd( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( self.onTransformEnd )
  self.onTransformEnd( o );

  return o;
}

// --
// leveling
// --

/* qqq : poor description */

/**
 * Increases value of logger level property by( dLevel ).
 *
 * If argument( dLevel ) is not specified, increases by one.
 *
 * @example
 * let l = new _.Logger({ output : console });
 * l.up( 2 );
 * console.log( l.level )
 * //returns 2
 * @method up
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @class wLoggerBasic
 * @namespace Tools
 * @module Tools/base/Logger
 */

function up( dLevel )
{
  let self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level+dLevel );

}

//

/**
 * Decreases value of logger level property by( dLevel ).
 * If argument( dLevel ) is not specified, decreases by one.
 *
 * @example
 * let l = new _.Logger({ output : console });
 * l.up( 2 );
 * l.down( 2 );
 * console.log( l.level )
 * //returns 0
 * @method down
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @class wLoggerBasic
 * @namespace Tools
 * @module Tools/base/Logger
 */

/* qqq : poor description */

function down( dLevel )
{
  let self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level-dLevel );

}

//

function levelSet( level )
{
  let self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to', level );
  _.assert( isFinite( level ) );

  let dLevel = level - self[ levelSymbol ];

  self[ levelSymbol ] = level ;

}

// --
// etc
// --

function _writeAct( channelName, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.longHas( self.Channel, channelName ) );

  let transformation =
  {
    input : args,
    channelName,
  }

  self.transform.head.call( self, self.transform, [ transformation ] );

  if( self.onWriteBegin )
  self.onWriteBegin( transformation );

  if( transformation.discarding )
  return transformation;

  self.transform( transformation );

  if( self.onWriteEnd )
  self.onWriteEnd( transformation );

  _.assert( transformation.output !== undefined );

  return transformation;
}

//

function _strConcat( args )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.strConcat )
  return _.entity.exportStringDiagnosticShallow/*exportStringSimple*/.apply( _, args );

  let o2 =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
    onToStr,
  }

  let result = _.strConcat( args, o2 );

  return result;

  function onToStr( src, op )
  {
    if( _.errIs( src ) && _.color )
    {
      src = _.err( src );
      let result = src.stack;
      result = _.ct.format( result, 'negative' );
      return result;
    }
    return _.entity.exportString( src, op.optionsForToStr );
  }
}

//

function Init()
{
  let cls = this;

  _.assert( cls.Channel.length > 0 );

  for( let i = 0 ; i < cls.Channel.length ; i++ )
  channelDeclare( cls.Channel[ i ] );

  function channelDeclare( channel )
  {
    let r =
    {
      [ channel ] : function()
      {
        this._writeAct( channel, arguments );
      }
    }
    cls.prototype[ channel ] = r[ channel ];
  }

}

// --
// relations
// --

let levelSymbol = Symbol.for( 'level' );
let chainerSymbol = Symbol.for( 'chainer' );

let Channel =
[
  'log',
  'error',
  'info',
  'warn',
  'debug'
];

let Composes =
{

  name : '',
  level : 0,

  onWriteBegin : null,
  onWriteEnd : null,

  onTransformBegin : null,
  onTransformEnd : null,

}

let Aggregates =
{
}

let Associates =
{
}

let Accessors =
{
  level : 'level',
}

let Statics =
{
  MetaType : 'Printer',
  Channel,
  Init,
}

// --
// declare
// --

let Proto =
{

  // routine

  init,

  // transform

  transform,
  _transformBegin,
  _transformAct,
  _transformEnd,

  // leveling

  up,
  down,
  levelSet,

  // etc

  _writeAct,
  _strConcat,

  // relations

  Composes,
  Aggregates,
  Associates,
  Accessors,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
Self.Init();

// --
// export
// --

_[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
