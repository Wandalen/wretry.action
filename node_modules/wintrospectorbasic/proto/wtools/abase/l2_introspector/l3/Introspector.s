( function _Introspector_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to generate functions.
  @namespace Tools.instrospector
  @extends Tools
  @module Tools/base/IntrospectorBasic
*/

const _global = _global_;
const _ = _global_.wTools;

// --
// introspector
// --

function _visitedPush( o, element )
{
  if( o.visited === null )
  o.visited = new Set;
  _.assert( !o.visited.has( element ) );
  o.visited.add( element );
}

//

function _visitedPop( o, element )
{
  o.visited.delete( element );
}

//

function _exportNodeHead( routine, args )
{
  let o = args[ 0 ];

  _.routine.options( routine, o );

  if( o.locality === null )
  o.locality = o.namespacePath === null ? 'local' : 'global';

  if( o.dstNode )
  {
    _.assert( o.locals === null || o.locals === o.dstNode.locals );
  }
  else
  {
    o.dstNode = _.introspector.node.namespace();
    if( o.locals )
    o.dstNode.locals = o.locals;
  }
  _.assert( o.dstNode.type === 'namespace' );

  return o;
}

//

function elementsExportNode_head( routine, args )
{
  let o = args[ 0 ];
  if( !_.aux.is( o ) || args.length > 1 )
  o = { srcContainer : args[ 0 ], namespacePath : args[ 1 ] === undefined ? null : args[ 1 ] }
  return _.introspector._exportNodeHead( routine, [ o ] );
}

//

function elementsExportNode_body( o )
{

  _.map.assertHasAll( o, elementsExportNode.defaults );
  _.introspector._visitedPush( o, o.srcContainer );

  _.each( o.srcContainer, ( e, k ) =>
  {
    _.introspector.elementExportNode
    ({
      ... o,
      name : k,
      element : e,
    })
  });

  _.introspector._visitedPop( o, o.srcContainer );

  return o;
}

elementsExportNode_body.defaults =
{
  srcContainer : null,
  namespacePath : null,
  dstNode : null,
  visited : null,
  locality : null,
  locals : null,
}

const elementsExportNode = _.routine.unite( elementsExportNode_head, elementsExportNode_body );

//

function elementExportNode_head( routine, args )
{
  let o = args[ 0 ];
  if( !_.aux.is( o ) || args.length > 1 )
  o =
  {
    srcContainer : args[ 0 ],
    namespacePath : args[ 1 ] === undefined ? null : args[ 1 ],
    name : args[ 2 ] === undefined ? null : args[ 2 ],
  }

  return _.introspector._exportNodeHead( routine, [ o ] );
}

//

function elementExportNode_body( o )
{
  let wrote = 0;

  verify();

  _.introspector._visitedPush( o, o.element );

  /* */

  if( _.routineIs( o.element ) )
  {

    if( o.element.meta )
    {
      if( o.element.meta.locals )
      localsExport( o.element.meta.locals );
    }

    if( o.element.vectorized )
    assign( [ o.name ], vectorizedExport( o.element ) );
    else if( o.element.head || o.element.body || o.element.tail )
    assign( [ o.name ], routineUnitedExport( o.element ) );
    else if( o.element.functor )
    assign( [ o.name ], routineFunctorExport( o.element ) );
    else if( o.element.composed )
    assign( [ o.name ], routineComposedExport( o.element ) );
    else
    assign( [ o.name ], routineExport( o.element ) );

    if( o.element.defaults )
    {
      write( '\n' );
      assign( [ o.name, 'defaults' ], routineDefaultsExport( o.element ) );
    }

    if( o.element.meta )
    {
      if( o.element.meta.globals )
      _.assert( 0, 'not implemented' );
    }

  }
  else
  {
    assign( [ o.name ], _.entity.exportJs( o.element ) );
    write( ';' );
  }

  if( wrote > 0 )
  write( '\n\n//\n\n' );

  /* */

  _.introspector._visitedPop( o, o.element );

  return o;

  /* */

  function verify()
  {
    if( !Config.debug )
    return;

    _.map.assertHasAll( o, elementExportNode.defaults );

    _.assert( o.dstNode.type === 'namespace' );
    _.assert( o.locality !== 'local' || o.namespacePath === null );
    _.assert
    (
      _.strDefined( o.name ),
      () => `Cant export, expects defined {-o.name-}, but got ${_.entity.strType( o.name )}`
    );
    _.assert
    (
      _.routine.is( o.element ) || _.primitive.is( o.element ) || _.regexp.is( o.element )
      || _.set.is( o.element ) || _.map.is( o.element ) || _.array.is( o.element ) || _.hashMap.is( o.element )
      , () => `Cant export ${o.name} is ${_.entity.strType( o.element )}`
    );

  }

  /* */

  function write( src )
  {
    _.assert( _.str.is( src ) );
    o.dstNode.elements.push( src );
    wrote += 1;
  }

  /* */

  function assign( path, right )
  {

    let left = assigningPathFor( ... path );
    if( o.locality === 'local' )
    {
      if( o.dstNode.locals[ left.path ] !== undefined )
      {
        if( _.introspector.node.exportString( o.dstNode.locals[ left.path ] ) === _.introspector.node.exportString( right ) )
        return;
        throw _.err( `Duplication of local variable "${left.path}"` );
      }
    }

    let node = Object.create( null );
    node.type = 'assign';
    node.locality = o.locality;
    node.left = left;
    node.right = right;
    node.exportString = _.introspector.node._assignExportString;
    wrote += 1;
    o.dstNode.elements.push( node );
    if( node.left.path.length === 1 )
    o.dstNode.locals[ node.left.path ] = right;
  }

  /* */

  function strLinesIndentation( src, indent )
  {
    if( indent === undefined )
    indent = '  ';
    if( !src )
    return src;
    return indent + _.strLinesIndentation( src, indent, false );
  }

  /* */

  function assigningPathFor()
  {
    let node = Object.create( null );

    node.type = 'assign.left';
    if( o.locality === 'local' )
    node.path = [ ... arguments ];
    else
    node.path = [ o.namespacePath, ... arguments ];

    node.prefix = '';
    if( o.locality === 'local' && node.path.length <= 1 )
    node.prefix = 'var ';
    // node.prefix = 'const '; /* xxx : uncomment after refactoring of starter */

    node.exportString = _.introspector.node._assignLeftExportString;

    return node;
  }

  /* */

  function routineDefaultsExport( routine )
  {
    let r = '\n';
    let defaults = _.props.of( routine.defaults, { onlyEnumerable : 1, onlyOwn : 0 } );
    r += _.entity.exportJs( defaults );
    return r;
  }

  /* */

  function routineProperties( namespacePath, routine )
  {
    let r = ''
    routine = routineOriginal( routine );
    let c = 0;
    for( const k in routine )
    {
      if( c > 0 )
      r += '\n';
      r += `${namespacePath}.${k} = ` + _.entity.exportJs( routine[ k ] );
      c += 1;
    }

    if( r )
    r = _.strLinesIndentation( r, '  ' ) + '\n';

    return r;
  }

  /* */

  function routineExport( routine )
  {
    if( routine.locals )
    localsExport( routine.locals );
    return routineOriginal( routine ).toString();
  }

  /* */

  function routineOriginal( routine )
  {
    _.assert( _.routineIs( routine ) );
    while( routine.original || routine.originalRoutine )
    routine = routine.original || routine.originalRoutine;
    return routine;
  }

  /* */

  function routineUnitedExport( element )
  {
    let result =
`( function() {
`

    if( element.head && element.head.composed )
    result +=
`
    ${_.strLinesIndentation( routineComposedExportBodies( element.head.composed.bodies, `_${element.name}_head` ), '  ' )}
`

    if( element.head && !element.head.composed )
    result +=
`
  const _${element.name}_head = ${_.strLinesIndentation( routineExport( element.head ), '  ' )}
${strLinesIndentation( routineProperties( `_${element.name}_head`, element.head ) )}`

    if( element.body )
    result +=
`
  const _${element.name}_body = ${_.strLinesIndentation( routineExport( element.body ), '  ' )}
${strLinesIndentation( routineProperties( `_${element.name}_body`, element.body ) )}`

    if( element.tail )
    result +=
`
  const _${element.name}_tail = ${_.strLinesIndentation( routineExport( element.tail ), '  ' )}
${strLinesIndentation( routineProperties( `_${element.name}_tail`, element.tail ) )}`

    if( !element.body || _.longHas( [ 'routine.unite', 'routine.uniteCloning_replaceByUnite' ], o.name ) )
    {

      result +=
`
  const _${element.name}_ = ${_.strLinesIndentation( routineExport( element ), '  ' )}
  ${_.strLinesIndentation( routineProperties( `_${element.name}_`, element ), '  ' )};`

      if( element.head )
      result += `\n_${element.name}_.head = ` + `_${element.name}_head;`;
      if( element.body )
      result += `\n_${element.name}_.body = ` + `_${element.name}_body;`;
      if( element.tail )
      result += `\n_${element.name}_.tail = ` + `_${element.name}_tail;`;
    }
    else
    {
      result +=
`\n  const _${element.name}_ = _.routine.unite
  ({
`
    if( element.head )
    result +=
`    head : _${element.name}_head,\n`
    if( element.body )
    result +=
`    body : _${element.name}_body,\n`
    if( element.tail )
    result +=
`    tail : _${element.name}_tail,\n`
    result +=
`  });\n`
    }

    result +=
`
  return _${element.name}_;
})();`;

    return result;
  }

  /* */

  function routineFunctorExport( element )
  {
    let result = '';

    if( element.functor.length === 0 )
    {
      if( element.functor.functor )
      result += routineFunctorExport( element.functor );
      else
      result += '( ' + routineExport( element.functor ) + ' )();';
    }
    else
    {
      result +=
`( function()
{
  const ${o.name} = ${routineExport( element )};
  ${o.name}.functor = ${element.functor.functor ? routineFunctorExport( element.functor ) : routineExport( element.functor )};
  return ${o.name};
})();`;
    }
    return result;
  }

  /* */

  function vectorizedExport( element )
  {
    let toVectorize = _.introspector.elementsExportNode
    ({
      srcContainer : element.vectorized,
      namespacePath : 'toVectorize',
    });
    let functor =
`
(function()
{
  let toVectorize = Object.create( null );
  ${toVectorize.dstNode.exportString()}
  return _.vectorize( toVectorize );
})();
`
    return functor;
  }

  /* */

  function routineComposedExportBodies( bodies, dstContainerName )
  {
    if( dstContainerName === undefined )
    dstContainerName = 'bodies';

    let result = `const ${dstContainerName} = [];`;

    bodies.forEach( ( body, i ) =>
    {
      let name = `_body_${i}`;
      let bodyExported = _.introspector.elementExportNode
      ({
        srcContainer : bodies,
        element : body,
        name,
        locality : 'local'
      })
      result += `\n  ${bodyExported.dstNode.exportString()}`;
      result += `\n ${dstContainerName}.push( ${name} );`;
    })

    return result;
  }

  /* */

  function routineComposedExport( routine )
  {
    let bodies = routine.composed.bodies;

    let result =
`( function() {
`
    result += `\n  ${routineComposedExportBodies( bodies )}`;

    let chainerExported = _.introspector.elementExportNode
    ({
      srcContainer : routine.composed,
      element : routine.composed.chainer,
      name : 'chainer',
      locality : 'local'
    })

    let tailExported = _.introspector.elementExportNode
    ({
      srcContainer : routine.composed,
      element : routine.composed.tail,
      name : 'tail',
      locality : 'local'
    })

    result += `\n  ${chainerExported.dstNode.exportString()}`;
    result += `\n  ${tailExported.dstNode.exportString()}`;

    result += `\n  const _${o.name}_ = _.routine.s.compose({ bodies, chainer, tail });`

    result +=
`
  return _${o.name}_;
})();
`
    return result;
  }

  /* */

  function localsExport( locals )
  {
    let o2 = _.mapOnly_( null, o, _.introspector.elementsExportNode.defaults );
    o2.srcContainer = locals;
    o2.namespacePath = null;
    o2.locality = 'local';
    _.introspector.elementsExportNode.body.call( _.introspector, o2 );
  }

  /* */

}

elementExportNode_body.defaults =
{
  ... elementsExportNode.defaults,
  name : null,
  element : _.nothing,
}

const elementExportNode = _.routine.unite( elementExportNode_head, elementExportNode_body );

//

function selectAndExportString( srcContainer, namespacePath, name )
{
  let element = _.select({ src : srcContainer, selector : name, upToken : '.' });
  return _.introspector.elementExportNode
  ({
    srcContainer,
    namespacePath,
    element,
    name,
  });
}

//

function field( namesapce, name )
{
  if( arguments.length === 2 )
  {
    return _.introspector.selectAndExportString( _[ namesapce ], `_.${namesapce}`, name ).dstNode.exportString();
  }
  else
  {
    name = arguments[ 0 ];
    return _.introspector.selectAndExportString( _, '_', name ).dstNode.exportString();
  }
}

//

function rou( namesapce, name )
{
  if( arguments.length === 2 )
  {
    return _.introspector.selectAndExportString( _[ namesapce ], `_.${namesapce}`, name ).dstNode.exportString();
  }
  else
  {
    name = arguments[ 0 ];
    return _.introspector.selectAndExportString( _, '_', name ).dstNode.exportString();
  }
}

//

function fields( namespace )
{
  let result = [];
  _.assert( _.object.isBasic( _[ namespace ] ) );
  for( let f in _[ namespace ] )
  {
    let e = _[ namespace ][ f ];
    if( _.strIs( e ) || _.regexpIs( e ) )
    result.push( rou( namespace, f ) );
  }
  return result.join( '  ' );
}

//

function cls( namesapce, name )
{
  let r;
  if( arguments.length === 2 )
  {
    r = _.introspector.selectAndExportString( _[ namesapce ], `_.${namesapce}`, name ).dstNode.exportString();
  }
  else
  {
    name = arguments[ 0 ];
    r = _.introspector.selectAndExportString( _, '_', name ).dstNode.exportString();
  }
  r =
`
(function()
{

const Self = ${r}

})();
`
  return r;
}

//

function clr( cls, method )
{
  let result = '';
  if( _[ cls ][ method ] )
  result = _.introspector.selectAndExportString( _[ cls ], `_.${cls}`, method ).dstNode.exportString();
  if( _[ cls ][ 'prototype' ][ method ] )
  result += '\n' + _.introspector.selectAndExportString( _[ cls ][ 'prototype' ], `_.${cls}.prototype`, method ).dstNode.exportString();
  return result;
}

// --
// introspector extension
// --

let IntrospectorExtension =
{

  _visitedPush,
  _visitedPop,
  _exportNodeHead,

  elementsExportNode,
  elementExportNode,
  selectAndExportString,

  field,
  rou,
  fields,
  cls,
  clr,

}

Object.assign( _.introspector, IntrospectorExtension );

})();
