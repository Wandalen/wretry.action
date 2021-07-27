( function _l7_Ct_s_()
{

'use strict';

/* = Glossary::

CT -- colorful text.

*/

//

const _global = _global_;
const _ = _global_.wTools;
const Self = _.ct = _.ct || Object.create( null );

// --
// implementation
// --

function _formatAffixesBackground( color )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( color ) );

  result.head = `❮background : ${color}❯`;
  result.post = `❮background : default❯`;

  return result;
}

//

function formatBackground( srcStr, color )
{

  if( _.number.is( color ) )
  color = _.color.colorNameNearest( color );

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( srcStr ), 'Expects string {-srcStr-}' );
  _.assert( _.strIs( color ), 'Expects string {-color-}' );

  return `❮background : ${color}❯${srcStr}❮background : default❯`;
}

//

function _formatAffixesForeground( color )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( color ) );

  result.head = `❮foreground : ${color}❯`;
  result.post = `❮foreground : default❯`;

  return result;
}

//

function formatForeground( srcStr, color )
{

  if( _.number.is( color ) )
  color = _.color.colorNameNearest( color );

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( srcStr ), 'Expects string {-srcStr-}' );
  _.assert( _.strIs( color ), 'Expects string {-color-}' );

  return `❮foreground : ${color}❯${srcStr}❮foreground : default❯`;
}

//

function _strEscape( srcStr )
{
  let result = srcStr;
  if( _.number.is( result ) )
  result = result + '';
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( result ), 'Expects string got', _.entity.strType( result ) );
  return '❮inputRaw:1❯' + srcStr + '❮inputRaw:0❯'
}

let escape = _.routineVectorize_functor( _strEscape );

//

function _strUnescape( srcStr )
{
  let result = srcStr;
  if( _.number.is( result ) )
  result = result + '';
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( result ), 'Expects string got', _.entity.strType( result ) );
  return '❮inputRaw:0❯' + srcStr + '❮inputRaw:1❯'
}

let unescape = _.routineVectorize_functor( _strUnescape );

//

function styleObjectFor( style )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( style ), 'Expects string got', _.entity.strType( style ) );

  let result = _.ct.Style[ style ];

  _.assert( _.mapIs( result ), `No such style : ${style}` );

  return result;
}

//

function _affixesJoin()
{

  _.assert( _.mapIs( arguments[ 0 ] ) );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    arguments[ 0 ].head = arguments[ a ].head + arguments[ 0 ].head;
    arguments[ 0 ].post = arguments[ 0 ].post + arguments[ a ].post;
  }

  return arguments[ 0 ];
}

//

function _formatAffixesForStyleObject( styleObject )
{
  let result = Object.create( null );
  result.head = '';
  result.post = '';

  _.map.assertHasOnly( styleObject, _formatAffixesForStyleObject.defaults );

  if( styleObject.fg )
  _.ct._affixesJoin( result, _.ct._formatAffixesForeground( styleObject.fg ) );

  if( styleObject.bg )
  _.ct._affixesJoin( result, _.ct._formatAffixesBackground( styleObject.bg ) );

  return result;
}

_formatAffixesForStyleObject.defaults =
{
  fg : null,
  bg : null,
}

//

function _formatAffixes( styles )
{
  let result = Object.create( null );
  result.head = '';
  result.post = '';

  styles = _.array.as( styles );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( styles ), 'Expects string or array of strings {- styles -}' );

  for( let s = 0 ; s < styles.length ; s++ )
  {
    let style = styles[ s ];

    if( _.object.isBasic( style ) )
    {
      let affixes = _.ct._formatAffixesForStyleObject( style );
      _.ct._affixesJoin( result, affixes );
      continue;
    }

    _.assert( _.strIs( style ), 'Expects string or array of strings { style }' );

    let styleObject = _.ct.styleObjectFor( style );
    _.assert( !!styleObject, 'Unknown style', _.strQuote( style ) );

    let affixes = _.ct._formatAffixesForStyleObject( styleObject );
    _.ct._affixesJoin( result, affixes );

  }

  return result;
}

//

function _format( srcStr, style )
{
  let result = srcStr;

  if( _.number.is( result ) )
  result = result + '';
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( result ), 'Expects string got', _.entity.strType( result ) );

  let r = _.ct._formatAffixes( style );

  result = r.head + result + r.post;

  return result;
}

let format = _.routineVectorize_functor( _format );

//

function _strip( srcStr )
{

  _.assert( _.strIs( srcStr ) );

  let splitted = _.strSplitInlinedStereo_
  ({
    src : srcStr,
    preservingEmpty : 0,
    stripping : 0,
    preservingInlined : 0,
    inliningDelimeters : 1,
  });

  return splitted.join( '' );
}

let strip = _.vectorize( _strip );

//

function parse( o )
{
  if( _.strIs( arguments[ 0 ] ) )
  o = { src : arguments[ 0 ] };
  _.routine.options_( parse, o );
  o.inliningDelimeters = 1;
  o.preservingOrdinary = 1;
  o.preservingInlined = 1;
  return _.strSplitInlinedStereo_( o );
}

parse.defaults =
{
  src : null,
  prefix : '❮',
  postfix : '❯',
  onInlined : ( e ) => [ e ],
  onOrdinary : null,
  stripping : 0,
  quoting : 0,
  preservingDelimeters : 0,
  preservingEmpty : 0,
}

//

let StripAnsi;
function _stripAnsi( src )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) );

  if( StripAnsi === undefined )
  StripAnsi = require( 'strip-ansi' );
  /* xxx : move to module::wCt, routine _.ct.stripAnsi() with lazy including of strip-ansi */
  /* qqq : implement without dependency */
  /* qqq : implement routine _.ct.fromAnsi() */

  return StripAnsi( src );
}

let stripAnsi = _.vectorize( _stripAnsi );

// --
// relation
// --

let Style =
{

  'positive' : { fg : 'green' },
  'negative' : { fg : 'red' },

  'path' : { fg : 'dark cyan' },
  'code' : { fg : 'dark green' },
  'entity' : { fg : 'bright blue' },

  'topic.up' : { fg : 'white', bg : 'dark blue' },
  'topic.down' : { fg : 'dark black', bg : 'dark blue' },

  'head' : { fg : 'dark black', bg : 'white' },
  'tail' : { fg : 'white', bg : 'dark black' },

  'highlighted' : { fg : 'white', bg : 'dark black' },
  'selected' : { fg : 'dark yellow', bg : 'dark blue' },
  'neutral' : { fg : 'smoke', bg : 'dim' },
  'secondary' : { fg : 'silver' },
  'tertiary' : { fg : 'gray' },

  'pipe.neutral' : { fg : 'dark magenta' },
  'pipe.negative' : { fg : 'dark red' },

  'exclusiveOutput.neutral' : { fg : 'dark black', bg : 'dark yellow' },
  'exclusiveOutput.negative' : { fg : 'dark red', bg : 'dark yellow' },

  'info.neutral' : { fg : 'white', bg : 'magenta' },
  'info.negative' : { fg : 'dark red', bg : 'magenta' },

}

// --
// declare
// --

let Extension =
{

  // implementation

  _formatAffixesBackground,
  formatBackground,
  bg : formatBackground,

  _formatAffixesForeground,
  formatForeground,
  fg : formatForeground,

  escape,
  unescape,

  styleObjectFor,
  _affixesJoin,
  _formatAffixesForStyleObject,
  _formatAffixes,
  _format,
  format,
  formatFinal : format,

  strip,
  parse, /* qqq : for junior : test? */

  _stripAnsi,
  stripAnsi, /* xxx : qqq : move out to module::wCtBasic */

  // fields

  Style,

}

Object.assign( Self, Extension );

})();
