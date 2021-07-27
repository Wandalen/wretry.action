( function _Namespace_s_( )
{

'use strict';

const _ = _global_.wTools;
_.gdf = _.gdf || Object.create( null );

// --
// event
// --

function on( o )
{
  o = _.event.onHead( on, arguments );
  return _.event.on( this._edispatcher, o );
}

on.defaults =
{
  callbackMap : null,
};

//

function once( o )
{
  o = _.event.once.head( once, arguments );
  return _.event.once( this._edispatcher, o );
}

once.defaults =
{
  callbackMap : null,
};

//

function off( o )
{
  o = _.event.offHead( off, arguments );
  return _.event.off( this._edispatcher, o );
}

off.defaults =
{
  callbackMap : null,
};

//

function eventHasHandler( o )
{
  o = _.event.eventHasHandlerHead( eventHasHandler, arguments );
  return _.event.eventHasHandler( this._edispatcher, o );
}

eventHasHandler.defaults =
{
  eventName : null,
  eventHandler : null,
}

//

function eventGive()
{
  let o = _.event.eventGiveHead( this._edispatcher, eventGive, arguments );
  return _.event.eventGive( this._edispatcher, o );
  // return _.event.eventGive( this._edispatcher, ... arguments );
}

eventGive.defaults =
{
  ... _.event.eventGive.defaults,
  gdf : null,
}

// --
//
// --

/**
 * Searches for converters.
 * Finds converters that match the specified selector.
 * Converter is selected if all fields of selector are equal with appropriate properties of the converter.
 *
 * @param {Object} selector a map with one or several rules that should be met by the converter
 *
 * Possible selector properties are :
 * @param {String} [selector.inFormat] Input format of the converter
 * @param {String} [selector.outFormat] Output format of the converter
 * @param {String} [selector.ext] File extension of the converter
 * @param {Boolean|Number} [selector.default] Selects default converter for provided inFormat, outFormat and ext
 *
 * @example
 * //returns converters that accept string as input
 * let converters = _.gdf.select({ inFormat : 'string.utf8' });
 * console.log( converters )
 *
 * @example
 * //returns converters that accept string and return structure( object )
 * let converters = _.gdf.select({ inFormat : 'string.utf8', outFormat : 'structure' });
 * console.log( converters )
 *
 * * @example
 * //returns default json converter that encodes structure to string
 * let converters = _.gdf.select({ inFormat : 'structure', outFormat : 'string.utf8', ext : 'json', default : 1 });
 * console.log( converters[ 0 ] )
 *
 * @returns {Array} Returns array with selected converters or empty array if nothing found.
 * @throws {Error} If more than one argument is provided
 * @throws {Error} If selector is not an Object
 * @throws {Error} If selector has unknown field
 * @method select
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 * @static
 */

function select( o )
{
  let names = [ 'inFormat', 'outFormat', 'ext' ];
  let result;

  o = _.routine.options_( select, o );
  _.assert( arguments.length === 1 );

  if( o.inFormat === null && o.outFormat === null && o.ext === null )
  {
    if( o.filePath )
    o.ext = _.path.ext( o.filePath );
  }

  if( o.inFormat || o.outFormat || o.ext )
  {
    let name, val;
    if( o.inFormat )
    {
      _.assert( _.strDefined( o.inFormat ) );
      if( _.gdf.inMap[ o.inFormat ] )
      result = _.gdf.inMap[ o.inFormat ].slice();
      else
      result = [];
    }
    else if( o.outFormat )
    {
      _.assert( _.strDefined( o.outFormat ) );
      if( _.gdf.outMap[ o.outFormat ] )
      result = _.gdf.outMap[ o.outFormat ].slice();
      else
      result = [];
    }
    else if( o.ext )
    {
      _.assert( _.strDefined( o.ext ) );
      if( _.gdf.extMap[ o.ext ] )
      result = _.gdf.extMap[ o.ext ].slice();
      else
      result = [];
    }
  }
  else
  {
    result = _.gdf.encodersArray.slice();
  }

  result = result.filter( ( encoder ) =>
  {
    let o2 = _.props.extend( null, o );
    delete o2.single;
    return encoder.supports( o2 );
  });

  if( result.length > 1 )
  if( o.single )
  {
    result = result.filter( ( e ) => e.feature ? e.feature.default : false );
  }

  return result;
}

select.defaults =
{
  data : null,
  inFormat : null,
  outFormat : null,
  filePath : null,
  ext : null,
  single : 1,
  feature : null,
}

//

function selectContext( o )
{
  let result = this.select( o );
  result = result.map( ( e ) => _.props.extend( null, o, { encoder : e } ) );
  result = _.gdf.Context( result );
  return result;
}

selectContext.defaults =
{
  ... select.defaults,
}

//

function selectSingleContext( o )
{
  let result = this.selectContext( o );
  _.assert( result.length <= 1, () => `Found several ( ${result.length} ) encoders` );
  _.assert( result.length > 0, () => `Found no encoder` );
  return result[ 0 ];
}

selectSingleContext.defaults =
{
  ... select.defaults,
}

//

function formatNameSplit( name )
{
  return name.split( '.' );
}

// --
// declare
// --

/**
 * @summary Contains descriptors of registered converters.
 * @property {Object} encodersArray
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by inptut format.
 * @property {Object} inMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by out format.
 * @property {Object} outMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by extension.
 * @property {Object} extMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by in/out format.
 * @property {Object} inOutMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

let encodersArray = [];
let inMap = Object.create( null );
let outMap = Object.create( null );
let extMap = Object.create( null );
let inOutMap = Object.create( null );

let events =
{
  'gdf.form' : [],
  'gdf.unform' : [],
}

let _edispatcher =
{
  events,
}

let Extension =
{

  // event

  on,
  once,
  off,
  eventHasHandler,
  eventGive,

  // routine

  select,
  selectContext,
  selectSingleContext,
  formatNameSplit,

  // field

  _edispatcher,
  encodersArray,
  inMap,
  outMap,
  extMap,
  inOutMap,

}

/* _.props.extend */Object.assign( _.gdf, Extension );

} )();
