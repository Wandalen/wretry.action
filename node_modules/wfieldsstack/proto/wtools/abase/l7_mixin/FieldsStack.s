( function _FieldsStack_s_( )
{

'use strict';

/**
 * Mixin adds fields rotation mechanism to your class. It's widespread problem to change the value of a field and then after some steps revert old value, no matter what it was. FieldsStack does it for you behind the scene. FieldsStack mixins methods fieldPush, fieldPop which allocate a map of stacks of fields and manage it to avoid any corruption. Use the module to keep it simple and don't repeat yourself.
  @module Tools/base/FieldsStack
*/

/**
 *  */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );

}

const _ObjectHasOwnProperty = Object.hasOwnProperty;
const _global = _global_;
const _ = _global_.wTools;

//

/**
 * @classdesc Mixin adds fields rotation mechanism to your class.
 * @class wFieldsStack
 * @namespace Tools
 * @module Tools/base/FieldsStack
 */

const Parent = null;
const Self = wFieldsStack;
function wFieldsStack( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FieldsStack';

//

/**
 * @summary Changes value of field `name` saving previous value
 * @param { String } property - name of property
 * @param {*} value - value of property
 * @method fieldPush
 * @module Tools/base/FieldsStack
 * @namespace Tools
 * @class wFieldsStack
 */

function fieldPush( fields )
{
  let self = this;

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( arguments[ 0 ] ) );
    _.assert( arguments[ 1 ] !== undefined );
    fields = { [ arguments[ 0 ] ] : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.mapIs( fields ) )

  for( let s in fields )
  {
    if( !self._fields[ s ] )
    self._fields[ s ] = [];
    self._fields[ s ].push( self[ s ] );
    // logger.log( 'fieldPush ' + s + ' ' + _.entity.exportStringDiagnosticShallow( self[ s ] ) + ' -> ' + _.entity.exportStringDiagnosticShallow( fields[ s ] ) );
    self[ s ] = fields[ s ];
    // logger.log( 'fieldPush new value of ' + s + ' ' + self[ s ] );
  }

  return self;
}

//

/**
 * @summary Restores previous value of field `name`
 * @param { String } property - name of property
 * @param {*} value - current value of property
 * @method fieldPop
 * @module Tools/base/FieldsStack
 * @namespace Tools
 * @class wFieldsStack
 */

function fieldPop( fields )
{
  let self = this;
  let result = Object.create( null );

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( arguments[ 0 ] ) );
    _.assert( arguments[ 1 ] !== undefined );
    fields = { [ arguments[ 0 ] ] : arguments[ 1 ] }
  }
  else if( arguments.length === 1 && _.strIs( arguments[ 0 ] ) )
  {
    fields = { [ arguments[ 0 ] ] : _.nothing }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.mapIs( fields ) );

  for( let s in fields )
  {
    let wasVal = fields[ s ];
    let selfVal = self[ s ];
    let _field = self._fields[ s ];

    // logger.log( 'fieldPop ' + s + ' ' + _.entity.exportStringDiagnosticShallow( selfVal ) + ' ~ ' + _.entity.exportStringDiagnosticShallow( wasVal ) );

    _.assert( _.arrayIs( _field ) );
    _.assert( selfVal === wasVal || wasVal === _.nothing, () => 'Decoupled fieldPop ' + _.entity.exportStringDiagnosticShallow( selfVal ) + ' != ' + _.entity.exportStringDiagnosticShallow( wasVal ) );
    self[ s ] = _field.pop();
    if( !self._fields[ s ].length )
    delete self._fields[ s ];
    result[ s ] = self[ s ];
  }

  // if( !Object.keys( result ).length === 1 )
  // debugger;

  if( Object.keys( result ).length === 1 )
  result = result[ Object.keys( result )[ 0 ] ];

  return result;
}

// --
// relations
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  _fields : _.define.own( {} ),
}

let Statics =
{
}

// --
// declare
// --

let Supplement =
{

  fieldPush,
  fieldPop,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
