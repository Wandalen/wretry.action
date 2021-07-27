(function _Dissector_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wArraySorted' );
  _.include( 'wArraySparse' );
  _.include( 'wBlueprint' );
}

//

const _ = _global_.wTools;
const Self = _.dissector = _.dissector || Object.create( null );

// --
// dissector
// --

function dissectionIs( src )
{
  if( !_.object.isBasic( src ) )
  return false;
  if( !_.object.isBasic( src.dissector ) || !_.arrayIs( src.parcels ) )
  return false;
  return true;
}

//

function dissectorIs( src )
{
  if( !_.object.isBasic( src ) )
  return false;
  if( !_.strIs( src.code ) || !_.routineIs( src.parse ) )
  return false;
  return true;
}

//

function _codeLex_head( routine, args )
{

  let o = args[ 0 ]
  if( !_.mapIs( o ) )
  {
    o =
    {
      code : args[ 0 ],
    }
  }

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );
  _.routine.options_( routine, o );

  return o;
}

function _codeLex_body( o )
{

  let op = Object.create( null );
  let delimeter = [ '\\\\', '\\<', '\\>', '<', '>', ' ', '**', '*' ];

  op.splits = _.strSplit
  ({
    src : o.code,
    delimeter,
    stripping : 0,
    preservingDelimeters : 1,
    preservingEmpty : 0,
  });

  _.strSplitsQuotedRejoin.body
  ({
    splits : op.splits,
    delimeter,
    quoting : 1,
    quotingPrefixes : [ '<' ],
    quotingPostfixes : [ '>' ],
    preservingQuoting : 0,
    inliningQuoting : 0,
    onQuoting,
  });

  tstepsWrap();

  priorityRejoin();

  prioritize( op.splits );

  reprioritize( op.splits );

  return op.splits;

  /* - */

  function tstepsWrap()
  {
    let orphan;
    let left = 0;
    for( let i = 0 ; i < op.splits.length ; i++ )
    {
      let split = op.splits[ i ];
      if( !_.strIs( split ) )
      {
        let tstep = split;
        _.assert( tstep.charInterval === undefined );
        if( orphan !== undefined )
        {
          tstep.raw = orphan + tstep.raw;
          orphan = undefined;
        }
        tstep.charInterval = [ left, left + tstep.raw.length - 1 ];
        left += tstep.raw.length;
        continue;
      }
      let stripped = split.trim();
      if( stripped === '' )
      {
        op.splits.splice( i, 1 );
        i -= 1;
        if( i >= 0 )
        {
          let tstep = op.splits[ i ];
          tstep.raw = tstep.raw + stripped;
          tstep.charInterval[ 1 ] = tstep.charInterval[ 0 ] + tstep.raw.length;
        }
        else
        {
          orphan = split
        }
        continue;
      }
      let tstep = Object.create( null );
      tstep.type = 'etc';
      tstep.raw = split;
      if( orphan !== undefined )
      {
        tstep.raw = orphan + tstep.raw;
        orphan = undefined;
      }
      tstep.val = stripped;
      tstep.charInterval = [ left, left + tstep.raw.length - 1 ];
      left += tstep.raw.length;
      op.splits[ i ] = tstep;
    }
  }

  function priorityRejoin()
  {

    for( let i = 0 ; i < op.splits.length ; i++ )
    {
      let split = op.splits[ i ];
      _.assert( _.mapIs( split ) );
      if( !/^\s*\^+\s*$/.test( split.val ) )
      continue;
      let nsplit = op.splits[ i + 1 ];
      _.assert( !!nsplit && nsplit.val === '**', `Cant tokenize template. Priority ${split.val} should be followed by **` );
      nsplit.val = split.val + nsplit.val;
      nsplit.raw = split.raw + nsplit.raw;
      nsplit.charInterval[ 0 ] = split.charInterval[ 0 ];
      op.splits.splice( i, 1 );
    }

  }

  function prioritize( splits )
  {
    for( let s = 0 ; s < splits.length ; s++ )
    {
      let split = splits[ s ];
      _.assert( !_.strIs( split ) );
      if( split.type === 'text' )
      continue;
      _.assert( split.type === 'etc' );
      let parsed = /(\^*)\s*(\*\*)/.exec( split.val );
      if( !parsed )
      continue;
      let tstep = split;
      tstep.type = 'any';
      tstep.val = parsed[ 1 ] + parsed[ 2 ];
      tstep.map = Object.create( null );
      tstep.map.priority = parsed[ 1 ];
      tstep.map.any = parsed[ 2 ];
      tstep.priority = -parsed[ 1 ].length;
      splits[ s ] = tstep;
    }
  }

  function reprioritize( splits )
  {

    let min = +Infinity;
    let max = -Infinity;
    let indexToPriority = Object.create( null );
    let priorities = [];

    for( let s = 0 ; s < splits.length ; s++ )
    {
      let split = splits[ s ];
      if( _.strIs( split ) )
      continue;
      if( split.priority !== undefined )
      {
        if( min > split.priority )
        min = split.priority;
        if( max < split.priority )
        max = split.priority;
        indexToPriority[ s ] = split.priority;
        sortedAdd( priorities, { priority : split.priority, index : s } );
      }
    }

    let effectivePriority = 0;
    for( let p = priorities.length-1 ; p >= 0 ; p-- )
    {
      let current = priorities[ p ];
      splits[ current.index ].priority = effectivePriority;
      effectivePriority -= 1;
      _.assert( -_.dissector._maxPriority <= effectivePriority && effectivePriority <= _.dissector._maxPriority );
      if( Config.debug )
      {
        if( p < priorities.length-1 && priorities[ p+1 ].priority === priorities[ p ].priority )
        _.assert( priorities[ p+1 ].index < priorities[ p ].index );
      }
    }

  }

  function sortedAdd( array, ins )
  {
    return _.sorted.addLeft( array, ins, ( e ) => e.priority );
  }

  function onQuoting( e, op )
  {
    let tstep = Object.create( null );
    tstep.type = 'text';
    tstep.raw = e;
    tstep.val = _.dissector.unescape( e );
    return tstep;
  }
}

_codeLex_body.defaults =
{
  code : null
}

let _codeLex = _.routine.uniteCloning_replaceByUnite( _codeLex_head, _codeLex_body );

//

function unescape( src )
{
  let map =
  {
    '\\<' : '<',
    '\\>' : '>',
    '\\\\' : '\\',
  }
  return _.strReplaceAll( src, map );
}

//

function escape( src )
{
  let map =
  {
    '<' : '\\<',
    '>' : '\\>',
    '\\' : '\\\\',
  }
  return _.strReplaceAll( src, map );
}


//

function make_head( routine, args )
{

  let o = args[ 0 ]
  if( !_.mapIs( o ) )
  {
    o =
    {
      code : args[ 0 ],
    }
  }

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );
  _.routine.options_( routine, o );

  return o;
}

function make_body( o )
{

  let dissector = Object.create( null );
  dissector.code = o.code;
  dissector.tokenSteps = _.dissector._codeLex.body( o );
  dissector.eatMap = eatMapGenerate();
  dissector.parcelSteps = stepsGenerate();
  dissector.parse = parse;

  /* token steps interval */
  let tokenInterval = [ 0, dissector.tokenSteps.length - 1 ]

  /* input text interval */
  let textInterval = [];

  /* markers */
  let pmarker = 0;
  let tmarker = 0;

  /* etc */
  let pstep, direct, text;

  return dissector;

  /* - */

  function parse( _text )
  {
    let result = Object.create( null );
    result.dissector = dissector;
    result.parcels = [];
    result.tokens = [];
    result.map = Object.create( null );
    result.matched = null;

    text = _text;
    textInterval[ 0 ] = 0;
    textInterval[ 1 ] = text.length-1;

    _.assert( arguments.length === 1 );
    _.assert( _.strIs( _text ) );

    parseStatic( result );

    if( result.matched === null )
    {
      result.matched = tokenInterval[ 0 ] > tokenInterval[ 1 ];
      _.assert( !result.matched || textInterval[ 0 ] > textInterval[ 1 ] );
    }

    return result;
  }

  /* */

  function parseStatic( result )
  {

    for( let i = 0 ; i < dissector.parcelSteps.length ; i++ )
    {
      pstep = dissector.parcelSteps[ i ];
      direct = pstep.side === 'left';

      let parcel = pstep.eat();

      if( !parcel )
      {
        result.matched = false;
        return result;
      }

      parcelNormalize( parcel );
      move( result, parcel );
    }

  }

  /* */

  function move( result, parcel )
  {
    if( direct )
    {
      result.parcels.splice( pmarker, 0, parcel );
      pmarker += 1;
      result.tokens.splice( tmarker, 0, ... parcel.tokens );
      tmarker += parcel.tokens.length;
      tokenInterval[ 0 ] += pstep.tokenSteps.length;
      textInterval[ 0 ] = parcel.interval[ 1 ] + 1;
    }
    else
    {
      result.parcels.splice( pmarker, 0, parcel );
      result.tokens.splice( tmarker, 0, ... [ ... parcel.tokens ].reverse() );
      tokenInterval[ 1 ] -= pstep.tokenSteps.length;
      textInterval[ 1 ] = parcel.interval[ 0 ] - 1;
    }
  }

  /* */

  function parcelNormalize( parcel )
  {
    if( parcel.tokens === undefined )
    {
      parcel.tokens = [ parcel ];
    }
    if( parcel.pstep === undefined )
    parcel.pstep = pstep;
    if( parcel.tstep === undefined )
    {
      _.assert( !!pstep.tokenSteps );
      _.assert( pstep.tokenSteps.length === 1 );
      parcel.tstep = pstep.tokenSteps[ 0 ];
    }
    _.assert( _.cinterval.is( parcel.interval ) );
    _.assert( _.mapIs( parcel.map ) );
  }

  /* */

  function eatFirstLeft()
  {
    // let left = _.strLeft( text, pstep.map.first.val, [ textInterval[ 0 ], textInterval[ 1 ] + 1 ] );
    let left = _.strLeft_( text, pstep.map.first.val, textInterval.slice() ); /* xxx */
    if( left.entry === undefined )
    return;

    let any = Object.create( null );
    any.interval = [ textInterval[ 0 ], left.index-1 ];
    any.val = text.slice( textInterval[ 0 ], left.index );
    any.tstep = pstep.map.any;
    any.pstep = null;

    let first = Object.create( null );
    first.interval = [ left.index, left.index+pstep.map.first.val.length-1 ];
    first.val = pstep.map.first.val;
    first.tstep = pstep.map.first;
    first.pstep = null;

    let parcel = Object.create( null );
    parcel.interval ; [ textInterval[ 0 ], left.index+pstep.map.first.val.length-1 ];
    parcel.val = text.slice( textInterval[ 0 ], left.index+pstep.map.first.val.length );
    parcel.tokens = [ any, first ];
    parcel.interval = [ textInterval[ 0 ], left.index+pstep.map.first.val.length-1 ];
    parcel.tstep = null;
    parcel.pstep = pstep;
    parcel.map =
    {
      any,
      first,
    }

    return parcel;
  }

  /* */

  function eatFirstRight()
  {
    // let right = _.strRight( text, pstep.map.first.val, [ textInterval[ 0 ], textInterval[ 1 ] + 1 ] );
    let right = _.strRight_( text, pstep.map.first.val, textInterval.slice() ); /* xxx */
    if( right.entry === undefined )
    return;

    let any = Object.create( null );
    any.interval = [ right.index+pstep.map.first.val.length, textInterval[ 1 ] ];
    any.val = text.slice( right.index+pstep.map.first.val.length, textInterval[ 1 ] + 1 );
    any.tstep = pstep.map.any;
    any.pstep = null;

    let first = Object.create( null );
    first.interval = [ right.index, right.index+pstep.map.first.val.length-1 ];
    first.val = pstep.map.first.val;
    first.tstep = pstep.map.first;
    first.pstep = null;

    let parcel = Object.create( null );
    parcel.interval = [ right.index, textInterval[ 1 ] ];
    parcel.val = text.slice( right.index, textInterval[ 1 ] + 1 );
    parcel.tokens = [ any, first ];
    parcel.interval = [ right.index, textInterval[ 1 ] ];
    parcel.tstep = null;
    parcel.pstep = pstep;
    parcel.map =
    {
      any,
      first,
    }

    return parcel;
  }

  /* */

  function eatRestLeft()
  {
    let parcel =
    {
      interval : [ textInterval[ 0 ], textInterval[ 1 ] ],
      val : text.slice( textInterval[ 0 ], textInterval[ 1 ] + 1 ),
      map : Object.create( null ),
    };
    return parcel;
  }

  /* */

  function eatRestRight()
  {
    let parcel =
    {
      interval : [ textInterval[ 0 ], textInterval[ 1 ] ],
      val : text.slice( textInterval[ 0 ], textInterval[ 1 ] + 1 ),
      map : Object.create( null ),
    };
    return parcel;
  }

  /* */

  function eatLeastLeft()
  {
    let parcel =
    {
      interval : [ textInterval[ 0 ], textInterval[ 0 ]-1 ],
      val : '',
      map : Object.create( null ),
    };
    return parcel;
  }

  /* */

  function eatLeastRight()
  {
    let parcel =
    {
      interval : [ textInterval[ 1 ] + 1, textInterval[ 1 ] ],
      val : '',
      map : Object.create( null ),
    };
    return parcel;
  }

  /* */

  function eatTextLeft()
  {
    let match = pstep.val === text.slice( textInterval[ 0 ], textInterval[ 0 ] + pstep.val.length );
    if( !match )
    return;
    let parcel =
    {
      interval : [ textInterval[ 0 ], textInterval[ 0 ] + pstep.val.length - 1 ],
      val : pstep.val,
      map : Object.create( null ),
    };
    return parcel;
  }

  /* */

  function eatTextRight()
  {
    let match = pstep.val === text.slice( textInterval[ 1 ] - pstep.val.length + 1, textInterval[ 1 ] + 1 );
    if( !match )
    return;
    let parcel =
    {
      interval : [ textInterval[ 1 ] - pstep.val.length + 1, textInterval[ 1 ] ],
      val : pstep.val,
      map : Object.create( null ),
    };
    return parcel;
  }

  /* */

  function eatMapGenerate()
  {
    let eatMap = Object.create( null );
    eatMap.restLeft = eatRestLeft;
    eatMap.restRight = eatRestRight;
    eatMap.firstLeft = eatFirstLeft;
    eatMap.firstRight = eatFirstRight;
    eatMap.leastLeft = eatLeastLeft;
    eatMap.leastRight = eatLeastRight;
    eatMap.textLeft = eatTextLeft;
    eatMap.textRight = eatTextRight;
    return eatMap;
  }

  /* */

  function stepsGenerate()
  {
    let parcelSteps = [];

    let op = Object.create( null );
    op.dissector = dissector;
    op.tinterval = [ 0, dissector.tokenSteps.length-1 ];

    let leftPstep = null;
    let rightPstep = null;

    while( op.tinterval[ 0 ] <= op.tinterval[ 1 ] )
    {

      if( leftPstep === null )
      {
        op.tindex = op.tinterval[ 0 ];
        op.tindex2 = op.tindex + 1;
        op.direct = true;
        leftPstep = _.dissector._stepGenerate( op );
      }

      if( rightPstep === null )
      {
        op.tindex = op.tinterval[ 1 ];
        op.tindex2 = op.tindex - 1;
        op.direct = false;
        rightPstep = _.dissector._stepGenerate( op );
      }

      let direct = leftPstep.priority >= rightPstep.priority;
      let pstep = direct ? leftPstep : rightPstep;

      if( Config.debug )
      {
        _.assert
        (
          _.cinterval.has( op.tinterval, pstep.tinterval )
          , `Current pstep is ${_.dissector._stepExportToStringShort( pstep )}`
          , `\nPstep has token interval ${pstep.tinterval[ 0 ]} .. ${pstep.tinterval[ 1 ]}.`
          , `\nBut current token interval is ${op.tinterval[ 0 ]} .. ${op.tinterval[ 1 ]}`
        );
      }

      parcelSteps.push( pstep );
      pstep.index = parcelSteps.length;

      if( direct )
      {
        op.tinterval[ 0 ] += pstep.tokenSteps.length;
        leftPstep = null;
        if( !_.cinterval.has( op.tinterval, rightPstep.sensetiveInterval ) )
        rightPstep = null;
      }
      else
      {
        op.tinterval[ 1 ] -= pstep.tokenSteps.length;
        rightPstep = null;
        if( !_.cinterval.has( op.tinterval, leftPstep.sensetiveInterval ) )
        leftPstep = null;
      }

    }

    return parcelSteps;
  }

  /* */

}

make_body.defaults =
{
  code : null
}

let make = _.routine.uniteCloning_replaceByUnite( make_head, make_body );

//

function _stepGenerate( op )
{
  let pstep;

  op.tstep = op.dissector.tokenSteps[ op.tindex ];
  if( _.cinterval.has( op.tinterval, op.tindex2 ) )
  op.tstep2 = op.dissector.tokenSteps[ op.tindex2 ];
  else
  op.tstep2 = undefined;

  _.assert
  (
    _.object.isBasic( op.tstep ) && _.longHas( [ 'any', 'text' ], op.tstep.type ),
    `Unknown type of token of the shape ${op.dissector.code}`
  );

  if( op.tstep.type === 'any' )
  {
    pstep = Object.create( null );
    pstep.map = Object.create( null );
    pstep.map.any = op.tstep;
    pstep.priority = op.tstep.priority;
    if( op.tstep2 === undefined )
    {
      pstep.type = 'rest';
      pstep.priority = _.dissector._maxPriority + 10;
      pstep.tokenSteps = [ op.tstep ];
      pstep.sensetiveInterval = [ 0, 0 ];
    }
    else if( op.tstep2.type === 'text' )
    {
      pstep.type = 'first';
      pstep.map.first = op.tstep2;
      pstep.tokenSteps = [ op.tstep, op.tstep2 ];
      pstep.sensetiveInterval = [ 0, 1 ];
    }
    else if( op.tstep2.type === 'any' )
    {
      pstep.type = 'least';
      pstep.map.least = op.tstep2;
      pstep.tokenSteps = [ op.tstep ];
      pstep.sensetiveInterval = [ 0, 1 ];
    }
    else _.assert( 0, `Unknown type of token step : ${op.tstep2.type}` );
  }
  else if( op.tstep.type === 'text' )
  {
    pstep = Object.create( null );
    pstep.tokenSteps = [ op.tstep ];
    pstep.type = op.tstep.type;
    pstep.val = op.tstep.val;
    pstep.priority = _.dissector._maxPriority + 20;
    pstep.sensetiveInterval = [ 0, 0 ];
    _.assert( op.tstep.side === undefined );
    _.assert( op.tstep.priority === undefined );
  }
  else _.assert( 0 );

  if( pstep.side === undefined )
  pstep.side = ( op.direct ? 'left' : 'right' );
  _.assert( _.longHas( [ 'left', 'right' ], pstep.side ) );

  _.assert( pstep.eat === undefined );
  let rname = pstep.type + ( op.direct ? 'Left' : 'Right' );
  pstep.eat = op.dissector.eatMap[ rname ];
  _.assert( _.routineIs( pstep.eat ), `No such eater ${rname}` );

  _.assert( pstep.tinterval === undefined );

  if( op.direct )
  {
    pstep.tinterval = [ op.tindex, op.tindex + pstep.tokenSteps.length - 1 ];
    pstep.sensetiveInterval[ 0 ] += op.tindex;
    pstep.sensetiveInterval[ 1 ] += op.tindex;
  }
  else
  {
    pstep.tinterval = [ op.tindex - pstep.tokenSteps.length + 1, op.tindex ];
    pstep.sensetiveInterval[ 0 ] = op.tindex - pstep.sensetiveInterval[ 1 ];
    pstep.sensetiveInterval[ 1 ] = op.tindex;
  }

  _.assert( _.numberIs( pstep.priority ) );
  _.assert( _.arrayIs( pstep.tokenSteps ) );

  return pstep;
}

_stepGenerate.defaults =
{
  dissector : null,
  direct : null,
  tindex2 : null,
  tindex : null,
}

//

function dissect_head( routine, args )
{

  let o = args[ 0 ]
  if( !_.mapIs( o ) )
  {
    o =
    {
      code : args[ 0 ],
      text : ( args.length > 1 ? args[ 1 ] : null ),
    }
  }

  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 2 );
  _.routine.options_( routine, o );

  return o;
}

function dissect_body( o )
{
  let dissector = _.dissector.make.body( o );
  return dissector.parse( o.text );
}

dissect_body.defaults =
{
  text : null,
  code : null,
}

let dissect = _.routine.uniteCloning_replaceByUnite( dissect_head, dissect_body );

//

function _tstepExportToString( tstep )
{

  if( tstep.type === 'any' )
  {
    _.assert( tstep.priority <= 0 );
    return _.strDup( '^', -tstep.priority ) + tstep.map.any;
  }
  else if( tstep.type === 'text' )
  {
    _.assert( tstep.priority === 0 || tstep.priority === undefined );
    return `<${tstep.val}>`;
  }
  else _.assert( 0 );

}

//

function dissectorExportToString( dissector )
{
  let result = '';

  _.assert( _.dissector.dissectorIs( dissector ) );

  dissector.tokenSteps.forEach( ( tstep ) =>
  {
    result += _.dissector._tstepExportToString( tstep );
  });

  return result;
}

//

function _stepExportToStringShort( step )
{
  return `${step.type}.${step.side}#${step.index}`;
}

//

function dissectionExportToString( o )
{
  let result = '';

  _.routine.options_( dissectionExportToString, arguments );
  _.assert( _.dissector.dissectionIs( o.src ) );
  _.assert( _.longHas( [ 'track' ], o.mode ) );

  if( o.mode === 'track' )
  {
    o.src.parcels.forEach( ( parcel ) =>
    {
      let s = _.dissector._stepExportToStringShort( parcel.pstep );
      if( result.length )
      result += ` ${s}`;
      else
      result += `${s}`;
    });
    return result;
  }
  else _.assert( 0 );

}

dissectionExportToString.defaults =
{
  src : null,
  mode : 'track',
}

//

/* zzz : imlement parsing with template routine _.dissector.dissect()

  b ^** ':' ** e
  b ^** ':' ^** ':' ** e
  b ^*+ s+ ^^*+ ':' *+ e
  b ( ^*+ )^ <&( s+ )&> ( ^^*+ ':' *+ )^ e

b subject:^** s+ map:** e
// 'c:/dir1 debug:0' -> subject : 'c:/dir1', debug:0

// test.identical( _.strCount( op.output, /program.end(.|\n|\r)*timeout1/mg ), 1 );
test.identical( _.strCount( op.output, `'program.end'**'timeout1'` ), 1 );

*/

// --
// declare
// --

let DissectorExtension =
{

  dissectionIs,
  dissectorIs,
  is : dissectorIs,

  _codeLex,
  unescape,
  escape,

  make,
  _stepGenerate,
  dissect,

  _tstepExportToString,
  dissectorExportToString,
  _stepExportToStringShort,
  dissectionExportToString,

  _maxPriority : 1 << 20,

}

/* _.props.extend */Object.assign( _.dissector, DissectorExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
