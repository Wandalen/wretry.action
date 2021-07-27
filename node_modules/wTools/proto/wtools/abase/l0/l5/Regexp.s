( function _l5_Regexp_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
// const Self = _global_.wTools;
_.regexp = _.regexp || Object.create( null );
_.regexp.s = _.regexp.s || Object.create( null );

// --
// regexp
// --

function regexpsEquivalent( src1, src2 )
{

  _.assert( _.strIs( src1 ) || _.regexpIs( src1 ) || _.longIs( src1 ), 'Expects string/regexp or array of strings/regexps {-src1-}' );
  _.assert( _.strIs( src2 ) || _.regexpIs( src2 ) || _.longIs( src2 ), 'Expects string/regexp or array of strings/regexps {-src2-}' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let isLong1 = _.longIs( src1 );
  let isLong2 = _.longIs( src2 );

  if( isLong1 && isLong2 )
  {
    let result = [];
    _.assert( src1.length === src2.length );
    for( let i = 0, len = src1.length ; i < len; i++ )
    {
      result[ i ] = _.regexp.equivalent( src1[ i ], src2[ i ] );
    }
    return result;
  }
  else if( !isLong1 && isLong2 )
  {
    let result = [];
    for( let i = 0, len = src2.length ; i < len; i++ )
    {
      result[ i ] = _.regexp.equivalent( src1, src2[ i ] );
    }
    return result;
  }
  else if( isLong1 && !isLong2 )
  {
    let result = [];
    for( let i = 0, len = src1.length ; i < len; i++ )
    {
      result[ i ] = _.regexp.equivalent( src1[ i ], src2 );
    }
    return result;
  }
  else
  {
    return _.regexp.equivalent( src1, src2 );
  }

}

//

function _test( regexp, str )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );
  _.assert( _.strIs( str ) );

  if( _.strIs( regexp ) )
  return regexp === str;
  else
  return regexp.test( str );

}

//

function test( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return _.regexp._test( regexp, strs );
  else if( _.argumentsArray.like( strs ) )
  return strs.map( ( str ) => _.regexp._test( regexp, str ) )
  else _.assert( 0 );

}

//

function testAll( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return _.regexp._test( regexp, strs );
  else if( _.argumentsArray.like( strs ) )
  return strs.every( ( str ) => _.regexp._test( regexp, str ) )
  else _.assert( 0 );

}

//

function testAny( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return _.regexp._test( regexp, strs );
  else if( _.argumentsArray.like( strs ) )
  return strs.some( ( str ) => _.regexp._test( regexp, str ) )
  else _.assert( 0 );

}

//

function testNone( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return !_.regexp._test( regexp, strs );
  else if( _.argumentsArray.like( strs ) )
  return !strs.some( ( str ) => _.regexp._test( regexp, str ) )
  else _.assert( 0 );

}

//

function regexpsTestAll( regexps, strs )
{
  _.assert( arguments.length === 2 );

  if( !_.arrayIs( regexps ) )
  return _.regexpTestAll( regexps, strs );

  _.assert( _.regexpsLikeAll( regexps ) );

  return regexps.every( ( regexp ) => _.regexpTestAll( regexp, strs ) );
}

//

function regexpsTestAny( regexps, strs )
{
  _.assert( arguments.length === 2 );

  if( !_.arrayIs( regexps ) )
  return _.regexpTestAny( regexps, strs );

  _.assert( _.regexpsLikeAll( regexps ) );

  return regexps.some( ( regexp ) => _.regexpTestAny( regexp, strs ) );
}

//

function regexpsTestNone( regexps, strs )
{
  _.assert( arguments.length === 2 );

  if( !_.arrayIs( regexps ) )
  return _.regexpTestNone( regexps, strs );

  _.assert( _.regexpsLikeAll( regexps ) );

  return regexps.every( ( regexp ) => _.regexpTestNone( regexp, strs ) );
}

// --
// extension
// --

let ToolsExtension =
{

  regexpsEquivalent : regexpsEquivalent,
  regexpsEquivalentAll : _.vectorizeAll( _.regexp.equivalentShallow.bind( _.regexp ), 2 ),
  regexpsEquivalentAny : _.vectorizeAny( _.regexp.equivalentShallow.bind( _.regexp ), 2 ),
  regexpsEquivalentNone : _.vectorizeNone( _.regexp.equivalentShallow.bind( _.regexp ), 2 ),

  regexpsEscape : _.vectorize( _.regexpEscape ),

  _regexpTest : _test,
  regexpTest : test,

  regexpTestAll : testAll,
  regexpTestAny : testAny,
  regexpTestNone : testNone,

  regexpsTestAll,
  regexpsTestAny,
  regexpsTestNone,


}

_.props.supplement( _, ToolsExtension ); /* qqq for junior : create namespace _.regexp. stand-alone PR | aaa : Done. */

//

let RegexpExtension =
{

  // regexp

  _test,
  test,

  testAll,
  testAny,
  testNone,

}

_.props.supplement( _.regexp, RegexpExtension );

//

let RegexpsExtension =
{

  // regexps

  regexpsEquivalent,

  escape : _.vectorize( _.regexpEscape ),

  testAll : regexpsTestAll,
  testAny : regexpsTestAny,
  testNone : regexpsTestNone,

}

//

_.props.supplement( _.regexp.s, RegexpsExtension );

})();
