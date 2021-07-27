(function _Context_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wGenericDataFormatContext;
function wGenericDataFormatContext( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Context';

// --
// implementation
// --

function init( o )
{
  let context = this;
  _.assert( arguments.length <= 1 );
  _.props.extend( context, o )
  delete context.default;
  Object.preventExtensions( context );
  _.assert( context.encoder instanceof _.Gdf );
  let proxy = _.proxyMap( context, context.encoder );
  return proxy;
}

//

function encode_body( o )
{
  let context = this;

  _.routine.assertOptions( encode, arguments );

  if( o.format === null )
  o.format = context.inFormat;

  let result = context.encoder.encode.body.call( context.encoder, o );

  return result;
}

_.routineExtend( encode_body, _.Gdf.prototype.encode.body );
// _.routineExtend( encode_body, _.Gdf.prototype.encode );

let encode = _.routine.uniteCloning_replaceByUnite( _.Gdf.prototype.encode.head, encode_body );

// --
// declare
// --

let Proto =
{

  init,
  encode,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

// --
// export
// --

_.gdf[ Self.shortName ] = Self;
if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _;

})();
