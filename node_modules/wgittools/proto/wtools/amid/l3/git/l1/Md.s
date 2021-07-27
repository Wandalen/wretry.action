( function _Md_s_()
{

'use strict';

const _ = _global_.wTools;
_.md = _.md || Object.create( null );

/* xxx : move out */

// --
// implementation
// --

function parse_head( routine, args )
{
  let o = args[ 0 ];
  if( _.str.is( o ) )
  o = { src : args[ 0 ] }

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );

  o = _.routine.options( routine, o );

  return o;
}

//

function parse_body( o )
{
  o.sectionArray = o.sectionArray || [];
  o.sectionMap = o.sectionMap || Object.create( null );

  let section = sectionOpen({ lineIndex : 0, charInterval : [ 0, 0 ] });
  let first = _.str.lines.at( o.src, 0 );
  let fromIndex = 0;
  if( lineIsSectionHead( first.line ) )
  {
    sectionHead( section, first );
    fromIndex += 1;
  }

  let it = _.str.lines.each( o.src, [ fromIndex, Infinity ], ( it ) =>
  {
    lineAnalyze( it )
  });

  sectionClose( section, it );

  return o;

  /* */

  function lineAnalyze( it )
  {
    if( lineIsSectionHead( it.line ) )
    {
      sectionClose( section, it );
      section = sectionOpen( it );
      sectionHead( section, it );
    }
  }

  /* */

  function lineIsSectionHead( line )
  {
    if( _.strBegins( line.trimStart(), o.headToken ) )
    return true;
    return false;
  }

  /* */

  function sectionOpen( it )
  {
    let section = Object.create( null );
    o.sectionArray.push( section );
    section.head = Object.create( null );
    section.head.text = null;
    section.head.raw = null;
    section.body = Object.create( null );
    section.body.text = null;
    section.level = 0;
    section.lineInterval = [ it.lineIndex ];
    section.charInterval = [ it.charInterval[ 0 ] ];
    return section;
  }

  /* */

  function sectionClose( section, it )
  {
    section.lineInterval[ 1 ] = it.lineIndex - 1;
    section.charInterval[ 1 ] = it.charInterval[ 0 ] - 1;

    section.body.lineInterval = section.lineInterval.slice();
    section.body.charInterval = section.charInterval.slice();
    if( section.head.charInterval )
    {
      section.body.lineInterval[ 0 ] = section.head.lineIndex + 1;
      section.body.charInterval[ 0 ] = section.head.charInterval[ 1 ] + 1;
    }

    section.body.text = it.src.slice( section.body.charInterval[ 0 ], section.body.charInterval[ 1 ]+1 );
    section.text = it.src.slice( section.charInterval[ 0 ], section.charInterval[ 1 ]+1 );

  }

  /* */

  function sectionHead( section, it )
  {
    let line = it.line.trimStart();
    let level = 0;
    while( line[ 0 ] === o.headToken )
    {
      level += 1;
      line = line.slice( 1 );
    }
    section.level = level;
    section.head.raw = line;
    section.head.text = line.trim();
    section.head.charInterval = it.charInterval.slice();
    section.head.lineIndex = it.lineIndex;
    if( section.head.text !== null )
    {
      o.sectionMap[ section.head.text ] = o.sectionMap[ section.head.text ] || [];
      o.sectionMap[ section.head.text ].push( section );
    }
  }

  /* */

  function sectionAdopt( section, it )
  {
    section.text += line;
  }

  /* */

}

parse_body.defaults =
{
  headToken : '#',
  src : null,
  withText : true, /* qqq : implement and cover */
}

let parse = _.routine.unite( parse_head, parse_body );

//

function sectionArrayStr_body( o )
{

  o.sectionArray.forEach( ( section ) =>
  {
    o.result += section.text;
  });

  return o.result;
}

sectionArrayStr_body.defaults =
{
  headToken : '#',
  sectionArray : null,
  result : '',
}

let sectionArrayStr = _.routine.unite( null, sectionArrayStr_body );

//

function sectionStr_body( o )
{

}

sectionStr_body.defaults =
{
  headToken : '#',
  section : null,
}

let sectionStr = _.routine.unite( null, sectionStr_body );

//

function _sectionReplace_head( routine, args )
{
  let o = args[ 0 ];

  if( args.length === 3 )
  {
    o = { dst : args[ 0 ], name : args[ 1 ], section : args[ 2 ] }
  }

  _.assert( args.length === 1 || args.length === 3 );
  _.assert( arguments.length === 2 );

  o = _.routine.options( routine, o );

  return o;
}

//

function structureSectionReplace_body( o )
{

  _.assert( _.str.is( o.section ) );
  _.assert( _.str.is( o.name ) );

  if( !_.strEnds( o.section, [ '\n', '\n\r' ] ) )
  o.section = o.section + '\n';

  if( _.str.is( o.dst ) )
  o.dst = _.md.parse( o.dst );

  if( !o.dst.sectionMap[ o.name ] )
  {
    o.replaced = false;
    return o;
  }

  o.dst.sectionMap[ o.name ].forEach( ( section ) =>
  {
    section.text = o.section;
  });

  o.replaced = true;
  return o;
}

structureSectionReplace_body.defaults =
{
  dst : null,
  name : null,
  section : null,
}

let structureSectionReplace = _.routine.unite( _sectionReplace_head, structureSectionReplace_body );

//

function textSectionReplace_body( o )
{

  this.structureSectionReplace.body.call( this, o );

  o.dst = this.sectionArrayStr( _.mapOnly_( null, o.dst, this.sectionArrayStr.defaults ) );

  return o;
}

textSectionReplace_body.defaults =
{
  ... structureSectionReplace.defaults,
}

let textSectionReplace = _.routine.unite( _sectionReplace_head, textSectionReplace_body );

// --
// declaretion
// --

let Extension =
{

  parse,

  str : sectionArrayStr,
  sectionArrayStr,
  sectionStr,

  structureSectionReplace,
  textSectionReplace,

}

/* _.props.extend */Object.assign( _.md, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
