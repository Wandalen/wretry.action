(function _Encoder_s_()
{

'use strict';

/**
 * @classdesc Class to operate the GDF encoder.
 * @class wGenericDataFormatEncoder
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wGenericDataFormatEncoder;
function wGenericDataFormatEncoder( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Gdf';

// --
// routine
// --

function finit()
{
  let encoder = this;
  encoder.unform();
  return _.Copyable.prototype.finit.apply( encoder, arguments );
}

//

function init( o )
{
  let encoder = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( encoder );
  Object.preventExtensions( encoder );

  if( o )
  encoder.copy( o );

  encoder.form();
  return encoder;
}

//

function unform()
{
  let encoder = this;

  _.gdf.eventGive({ event : 'gdf.unform', gdf : encoder });

  encoder.formed = 0;

  _.arrayRemoveOnceStrictly( _.gdf.encodersArray, encoder );

  encoder.inFormat.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.inMap[ e ], encoder );
    let splits = _.gdf.formatNameSplit( e );
    if( splits.length > 1 )
    splits.forEach( ( split ) => _.arrayRemoveOnce( _.gdf.inMap[ split ], encoder ) );
  });

  encoder.outFormat.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.outMap[ e ], encoder );
    let splits = _.gdf.formatNameSplit( e );
    if( splits.length > 1 )
    splits.forEach( ( split ) => _.arrayRemoveOnce( _.gdf.outMap[ split ], encoder ) );
  });

  encoder.ext.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.extMap[ e ], encoder );
  });

  encoder.inOut.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.inOutMap[ e ], encoder );
  });

  return encoder;
}

//

/**
 * @summary Registers current encoder.
 * @description
 * Checks descriptor of current encoder and it into maps: InMap, OutMap, ExtMap, InOutMap.
 * Generates name for encoder if its not specified explicitly.
 * @method form
 * @class wGenericDataFormatEncoder
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

function form()
{
  let encoder = this;

  _.assert( encoder.inOut === null );
  _.assert( _.mapIs( encoder.feature ), `Expects map {- feature -}` );
  _.assert( encoder.name === null );
  _.assert( encoder.formed === 0 );

  encoder.formed = 1;

  if( encoder.feature.config === undefined )
  encoder.feature.config = true;
  if( encoder.feature.default !== undefined )
  encoder.feature.default = !!encoder.feature.default;

  encoder.inFormat = _.array.as( encoder.inFormat );
  encoder.outFormat = _.array.as( encoder.outFormat );
  encoder.ext = _.array.as( encoder.ext );

  if( encoder.shortName === null && encoder.ext[ 0 ] )
  encoder.shortName = encoder.ext[ 0 ];
  if( encoder.name === null )
  encoder.name = encoder.shortName + ':' + encoder.inFormat[ 0 ] + '->' + encoder.outFormat[ 0 ];

  if( Config.debug )
  {
    encoder.inFormat.forEach( ( format ) =>
    {
      _.assert( _.strIs( format ), () => `Expects string as name of in-format` );
      _.assert( !_.strHas( format, '-' ), () => `Expects no "-" in name of in-format, but got ${format}` );
      _.assert( _.strHas( format, '.' ) || format === 'structure', () => `Expects "." in name of in-format, but got ${format}` );
    });
    encoder.outFormat.forEach( ( format ) =>
    {
      _.assert( _.strIs( format ), () => `Expects string as name of in-format` );
      _.assert( !_.strHas( format, '-' ), () => `Expects no "-" in name of in-format, but got ${format}` );
      _.assert( _.strHas( format, '.' ) || format === 'structure', () => `Expects "." in name of in-format, but got ${format}` );
    });
    _.assert( _.strsAreAll( encoder.inFormat ) );
    _.assert( _.strsAreAll( encoder.outFormat ) );
    _.assert( _.strsAreAll( encoder.ext ) );
    _.assert( _.strDefined( encoder.shortName ), () => 'Expects defined shortName' );
  }

  /* - */

  _.arrayAppendOnceStrictly( _.gdf.encodersArray, encoder );

  encoder.inFormat.forEach( ( e, k ) =>
  {
    _.gdf.inMap[ e ] = _.arrayAppendOnceStrictly( _.gdf.inMap[ e ] || null, encoder );
    let splits = _.gdf.formatNameSplit( e );
    if( splits.length > 1 )
    splits.forEach( ( split ) => _.gdf.inMap[ split ] = _.arrayAppendOnce( _.gdf.inMap[ split ] || null, encoder ) );
  });

  encoder.outFormat.forEach( ( e, k ) =>
  {
    _.gdf.outMap[ e ] = _.arrayAppendOnceStrictly( _.gdf.outMap[ e ] || null, encoder );
    let splits = _.gdf.formatNameSplit( e );
    if( splits.length > 1 )
    splits.forEach( ( split ) => _.gdf.outMap[ split ] = _.arrayAppendOnce( _.gdf.outMap[ split ] || null, encoder ) );
  });

  encoder.ext.forEach( ( e, k ) =>
  {
    _.gdf.extMap[ e ] = _.arrayAppendOnceStrictly( _.gdf.extMap[ e ] || null, encoder );
  });

  let inOut = _.permutation.eachSample([ encoder.inFormat, encoder.outFormat ]);
  encoder.inOut = [];
  inOut.forEach( ( inOut ) =>
  {
    let key = inOut.join( '->' );
    encoder.inOut.push( key );
    _.gdf.inOutMap[ key ] = _.arrayAppendOnceStrictly( _.gdf.inOutMap[ key ] || null, encoder );
  });

  /* - */

  _.assert( _.strIs( encoder.name ) );
  _.assert( _.strsAreAll( encoder.inFormat ) );
  _.assert( _.strsAreAll( encoder.outFormat ) );
  _.assert( _.strsAreAll( encoder.ext ) );
  _.assert( encoder.inFormat.length >= 1 );
  _.assert( encoder.outFormat.length >= 1 );
  _.assert( encoder.ext.length >= 0 );
  _.assert( _.routineIs( encoder.onEncode ) );

  // if( _.longHas( encoder.ext, 'yaml' ) )
  // debugger;
  _.gdf.eventGive({ event : 'gdf.form', gdf : encoder });

  return encoder;
}

//

/**
 * @summary Encodes source data from one specific format to another.
 * @description
 * Possible in/out formats are determined by encoder.
 * Use {@link module:Tools/mid/Gdf.gdf.select select} routine to find encoder for your needs.
 * @param {Object} o Options map
 *
 * @param {*} o.data Source data.
 * @param {String} o.format Format of source `o.data`.
 * @param {Object} o.params Map with enviroment variables that will be used by encoder.
 *
 * @example
 * //returns encoders that accept string as input
 * let encoders = _.gdf.selectContext({ inFormat : 'string.utf8', outFormat : 'structure', ext : 'cson' });
 * let src = 'val : 13';
 * let dst = encoders[ 0 ]._encode({ data : src, format : 'string.utf8' });
 * console.log( dst.data ); //{ val : 13 }
 *
 * @returns {Object} Returns map with properties: `data` - result of encoding and `format` : format of the result.
 * @method _encode
 * @class wGenericDataFormatEncoder
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

function encode_head( routine, args )
{
  let encoder = this;
  let o = args[ 0 ];

  _.assert( arguments.length === 2 );
  _.routine.options_( routine, o );

  return o;
}

//

function _encode( op )
{
  let encoder = this;

  _.assert( arguments.length === 1 );
  _.routine.assertOptions( _encode, arguments );

  return encoder.onEncode( op );
}

_encode.defaults =
{
  in : null,
  out : null,
  sync : null,
  params : null,
  err : null,
}

//

function encode_body( o )
{
  let encoder = this;
  let result;

  _.assert( arguments.length === 1 );
  _.routine.options_( encode_body, arguments );

  if( !o.filePath )
  if( o.params && _.strIs( o.params.filePath ) )
  o.filePath = o.params.filePath;

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase()

  /* */

  let op = Object.create( null );

  op.in = Object.create( null );
  op.in.data = o.data;
  op.in.filePath = o.filePath;
  op.in.ext = o.ext;
  op.in.format = o.format || encoder.inFormat;
  if( _.arrayIs( op.in.format ) )
  op.in.format = op.in.format.length === 1 ? op.in.format[ 0 ] : null;

  op.out = Object.create( null );
  op.out.data = undefined;
  op.out.format = null;

  op.params = o.params || Object.create( null );
  op.sync = o.sync;
  // if( o.params.sync !== undefined )
  // op.sync = o.params.sync;
  op.err = null;

  if( op.sync === null )
  op.sync = true;

  /* */

  try
  {

    _.assert( _.object.isBasic( op.params ) );
    _.assert( op.in.format === null || _.strIs( op.in.format ), 'Not clear which input format is' );
    _.assert( op.in.format === null || encoder.inFormatSupports( op.in.format ), () => `Unknown format ${op.in.format}` );

    // if( op.in.format === 'structure' )
    // debugger;

    result = encoder._encode( op );
    // logger.log( `${op.in.format} -> ${op.out.format} , filePath : ${op.in.filePath}` );

    // structure
    // string.utf8

    if( result === undefined )
    result = op;

    op.out.format = op.out.format || encoder.outFormat;
    if( _.arrayIs( op.out.format ) )
    op.out.format = op.out.format.length === 1 ? op.out.format[ 0 ] : undefined;

    _.assert( _.strIs( op.out.format ), 'Output should have format' );
    _.assert( _.longHas( encoder.outFormat, op.out.format ), () => 'Strange output format ' + o.out.format );
    _.routine.assertOptions( encoder._encode, op );
    _.assert( result === op || _.consequenceIs( result ) );
    // _.assert( op.params.sync === undefined );

  }
  catch( err )
  {
    let outFormat = op.out.format || encoder.outFormat;
    throw _.err
    (
      err
      , `\nFailed to convert from "${op.in.format}" to "${outFormat}" by encoder ${encoder.name}`
    );
  }

  /* */

  return result;
}

encode_body.defaults =
{
  data : null,
  format : null,
  filePath : null,
  ext : null,
  sync : null,
  params : null,
}

let encode = _.routine.uniteCloning_replaceByUnite( encode_head, encode_body );

//

function supports( o )
{
  let encoder = this;
  let counter = 0;

  o = _.routine.options_( supports, arguments );

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase();

  _.assert( o.ext === null || _.strIs( o.ext ) );

  if( o.inFormat )
  if( encoder.inFormatSupports( o.inFormat ) )
  o.counter += 1;
  else
  return false;

  if( o.outFormat )
  if( encoder.outFormatSupports( o.outFormat ) )
  o.counter += 1;
  else
  return false;

  if( o.ext )
  if( _.longHas( encoder.ext, o.ext ) )
  o.counter += 1;
  else
  return false;

  if( o.feature )
  {
    for( let f in o.feature )
    if( o.feature[ f ] === encoder.feature[ f ] )
    o.counter += 1;
    else
    return false;
  }

  return encoder._supports( o );
}

supports.defaults =
{
  counter : 0,
  inFormat : null,
  outFormat : null,
  ext : null,
  filePath : null,
  data : null,
  feature : null,
}

//

function _supports( o )
{
  let encoder = this;
  return true;
}

_supports.defaults =
{
  ... supports.defaults,
}

//

function inFormatSupports( inFormat )
{
  let encoder = this;
  _.assert( _.strDefined( inFormat ) );
  return !!_.any( encoder.inFormat, ( encoderInFormat ) =>
  {
    return _.longHasAll( _.gdf.formatNameSplit( encoderInFormat ), _.gdf.formatNameSplit( inFormat ) );
  });
}

//

function outFormatSupports( outFormat )
{
  let encoder = this;
  _.assert( _.strDefined( outFormat ) );
  return !!_.any( encoder.outFormat, ( encoderOutFormat ) =>
  {
    return _.longHasAll( _.gdf.formatNameSplit( encoderOutFormat ), _.gdf.formatNameSplit( outFormat ) );
  });
}

//

/**
 * @summary Fields of wGenericDataFormatEncoder class.
 * @typedef {Object} Composes
 * @property {String} name=null Name of the encoder
 * @property {String} shortName=null Short name of the encoder
 * @property {Array} ext=null Supported extensions
 * @property {Array} in=null Input format
 * @property {Array} out=null Output format
 * @property {Array} inOut=null All combinations of in-out formats
 * @property {Object} feature=null Map with feature types of data
 *
 * @class wGenericDataFormatEncoder
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

// --
// relations
// --

let Composes =
{

  name : null,
  shortName : null,

  ext : null,
  inFormat : null,
  outFormat : null,
  inOut : null,

  feature : null,
  onEncode : null,

}

let Aggregates =
{
}

let Restricts =
{
  formed : 0,
}

let Statics =
{
}

let Forbids =
{

  Select : 'Select',
  Elements : 'Elements',
  InMap : 'InMap',
  OutMap : 'OutMap',
  ExtMap : 'ExtMap',
  InOutMap : 'InOutMap',
  forConfig : 'forConfig',
  default : 'default',
  supporting : 'supporting',
  in : 'in',
  out : 'out',

}

// --
// declare
// --

let Proto =
{

  finit,
  init,
  unform,
  form,
  _encode,
  encode,

  supports,
  _supports,

  inFormatSupports,
  outFormatSupports,

  // relations

  Composes,
  Aggregates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

// --
// export
// --

_.Gdf = Self;
_.gdf.Encoder = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
