( function _l5_Stringer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.seeker.Seeker;

// --
// implementation
// --

/* xxx : add to the list of types */

function head( o, o2 )
{

  if( o === null )
  o = Object.create( null );

  if( o2 )
  _.props.supplement( o, o2 );

  if( _.prototype.has( o, _.stringer.Stringer ) )
  return o;

  if( !o.Seeker )
  o.Seeker = Stringer;

  let it = o.Seeker.optionsToIteration( null, o );

  _.assert( _.number.is( it.verbosity ) );
  _.assert( _.routine.is( it.tabLevelDown ) );

  return it;
}

//

function iteratorInitBegin( iterator )
{
  Parent.iteratorInitBegin.call( this, iterator );

  iterator.dstNode = [];

  return iterator;
}

//

function resultExportString()
{
  let it = this;
  return it.iterator.result;
}

//

function verbosityUp()
{
  let it = this;
  let it2 = it.iterationMake();
  it2.tabLevelUp();
  it2.verbosity -= 1;
  return it2;
}

//

function verbosityDown()
{
  let it = this;
  return it;
}

//

function tabLevelUp()
{
  let it = this;
  it.tab += it.dtab;
  it.tabLevel += 1;
  it.dstNode = [];
  it.iterator.dstNode.push( it.dstNode );
  return it;
}

//

function tabLevelDown()
{
  let it = this;
  it.tab = it.tab.slice( 0, it.tab.length - it.dtab.length );
  it.tabLevel -= 1;
  return it;
}

//

function levelUp()
{
  let it = this;
  it.level += 1;
  return it;
}

//

function levelDown()
{
  let it = this;
  it.level -= 1;
  return it;
}

//

function lineWrite( src )
{
  let it = this;
  _.assert( arguments.length === 1 );
  if( it.iterator.result.length )
  it.iterator.result += `${it.eol}${it.tab}${src}`;
  else
  it.iterator.result += `${it.tab}${src}`;
  it.dstNode.push( `${it.tab}${src}` );
  return it;
}

//

function titleWrite( src )
{
  let it = this;
  _.assert( arguments.length === 1 );

  let it2 = it.verbosityUp();
  it2.lineWrite( src );
  return it2;
}

//

function elementsWrite( src )
{
  let it = this;
  _.assert( arguments.length === 1 );

  let it2 = it.verbosityUp();
  for( let e of src )
  {
    it2.lineWrite( e );
  }
  return it2;
}

//

function write( src )
{
  let it = this;
  _.assert( arguments.length === 1 );
  _.assert( _.str.is( src ) );
  it.iterator.result += src;
  if( it.dstNode.length )
  it.dstNode[ it.iterator.dstNode.length-1 ] += src;
  else
  it.dstNode.push( src );
  return it;
}

//

function eolWrite()
{
  let it = this;
  _.assert( arguments.length === 0 );
  it.write( it.eol );
  return it;
}

//

function tabWrite()
{
  let it = this;
  _.assert( arguments.length === 0 );
  it.write( it.tab );
  return it;
}

//

function nodesExportString( src, o )
{
  let result = '';

  o = _.routine.options( nodesExportString, o );

  act( src, o.tab );

  return result;

  function act( src, tab )
  {

    if( _.str.is( src ) )
    {
      if( result.length )
      result += '\n';
      result += tab + src;
      return;
    }

    if( _.array.is( src ) )
    {
      src.forEach( ( e ) => act( e, tab + o.dtab ) );
      return;
    }

    _.assert( 0 );
  }

}

nodesExportString.defaults =
{
  tab : '',
  dtab : '  ',
}

// --
//
// --

const StringerClassExtension = Object.create( null );
StringerClassExtension.constructor = function Stringer(){};
StringerClassExtension.head = head;
StringerClassExtension.iteratorInitBegin = iteratorInitBegin;
StringerClassExtension.resultExportString = resultExportString;
StringerClassExtension.verbosityUp = verbosityUp;
StringerClassExtension.verbosityDown = verbosityDown;
StringerClassExtension.tabLevelUp = tabLevelUp;
StringerClassExtension.tabLevelDown = tabLevelDown;
StringerClassExtension.levelUp = levelUp;
StringerClassExtension.levelDown = levelDown;
StringerClassExtension.write = write;
StringerClassExtension.eolWrite = eolWrite;
StringerClassExtension.tabWrite = tabWrite;
StringerClassExtension.lineWrite = lineWrite;
StringerClassExtension.titleWrite = titleWrite;
StringerClassExtension.elementsWrite = elementsWrite;

const Iterator = StringerClassExtension.Iterator = Object.create( null );
Iterator.result = '';
Iterator.dstNode = null;
Iterator.dtab = '  ';
Iterator.eol = _.str.lines.Eol.default;
Iterator.recursive = Infinity;
_.assert( !!Iterator.eol );

const Iteration = StringerClassExtension.Iteration = Object.create( null );

const IterationPreserve = StringerClassExtension.IterationPreserve = Object.create( null );
IterationPreserve.tab = '';
IterationPreserve.verbosity = 2;
IterationPreserve.tabLevel = 0;
IterationPreserve.level = 0;
IterationPreserve.dstNode = null;

const Prime = {};
const Stringer = _.seeker.classDefine
({
  name : 'Stringer',
  parent : Parent,
  prime : Prime,
  seeker : StringerClassExtension,
  iterator : Iterator,
  iteration : Iteration,
  iterationPreserve : IterationPreserve,
});

_.assert( Stringer.constructor.name === 'Stringer' );
_.assert( Stringer.IterationPreserve.tab === '' );
_.assert( Stringer.Iteration.tab === '' );
_.assert( Stringer.Iterator.tab === undefined );
_.assert( Stringer.tab === undefined );

// --
// stringer extension
// --

let StringerExtension =
{

  Stringer,
  it : head,
  nodesExportString,

}

Object.assign( _.stringer, StringerExtension );

// --
// tools extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

})();
