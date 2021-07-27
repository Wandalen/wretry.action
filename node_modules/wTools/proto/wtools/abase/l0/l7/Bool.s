( function _l7_Bool_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.bool = _.bool || Object.create( null );

// --
// bool
// --

/**
 * @summary Converts argument( src ) to boolean.
 * @function boolFrom
 * @param {*} src - entity to convert
 * @namespace Tools
 * @throws Exception if cannot convert.
 */

function from( src )
{
  let result = _.bool.fromMaybe( src );
  _.assert( _.boolIs( result ), `Cant convert ${_.entity.strType( src )} to boolean` );
  return result;
}

//

/**
 * @summary Converts argument( src ) to boolean or return src.
 * @function boolFrom
 * @param {*} src - entity to convert
 * @namespace Tools
 */

function fromMaybe( src )
{
  if( _.bool.is( src ) )
  {
    return src;
  }
  else if( _.number.is( src ) )
  {
    return !!src;
  }
  else if( _.strIs( src ) )
  {
    src = src.toLowerCase();
    if( src === '0' )
    return false;
    if( src === 'false' )
    return false;
    if( src === '1' )
    return true;
    if( src === 'true' )
    return true;
    return src;
  }
  else
  {
    return src;
  }
}

//

/**
 * @summary Converts argument( src ) to boolean.
 * @function boolFrom
 * @param {*} src - entity to convert
 * @namespace Tools
 */

function coerceFrom( src )
{
  if( _.strIs( src ) )
  {
    src = src.toLowerCase();
    if( src === '0' )
    return false;
    if( src === 'false' )
    return false;
    if( src === 'null' )
    return false;
    if( src === 'undefined' )
    return false;
    if( src === '' )
    return false;
    return true;
  }
  return Boolean( src );
}

// --
// implementation
// --

let ToolsExtension =
{

  boolFrom : from,
  boolFromMaybe : fromMaybe,
  boolCoerceFrom : coerceFrom,

}

Object.assign( _, ToolsExtension );

//

let BoolExtension =
{

  from,
  fromMaybe,
  coerceFrom,

}

Object.assign( _.bool, BoolExtension );

})();
