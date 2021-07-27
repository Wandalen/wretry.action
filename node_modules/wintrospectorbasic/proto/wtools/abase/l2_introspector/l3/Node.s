( function _Node_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to generate functions.
  @namespace Tools.instrospector.node
  @extends Tools
  @module Tools/base/IntrospectorBasic
*/

const _global = _global_;
const _ = _global_.wTools;

_.introspector.node = _.introspector.node || Object.create( null );

// --
//
// --

function namespace()
{
  let node = Object.create( null );
  node.type = 'namespace';
  node.locals = Object.create( null );
  node.elements = [];
  node.exportString = _.introspector.node._namespaceExportString;
  return node
}

//

function exportString( src )
{
  let result = '';
  if( _.str.is( src ) )
  result += src;
  else
  {
    _.assert( _.routine.is( src.exportString ) );
    result += src.exportString();
  }
  return result;
}

//

function _namespaceExportString()
{
  let result = '';
  this.elements.forEach( ( element ) =>
  {
    result += _.introspector.node.exportString( element )
  });
  return result;
}

//

function _assignExportString()
{
  let result = '';
  let l = _.introspector.node.exportString( this.left );
  let r = _.introspector.node.exportString( this.right );
  if( r[ 0 ] === '\n' )
  result += l + ' =' + r;
  else
  result += l + ' = ' + r;
  return result;
}

//

function _assignLeftExportString()
{
  let result = this.prefix + this.path.join( '.' );
  return result;
}

// --
// introspector extension
// --

let NodeExtension =
{

  namespace,

  exportString,

  _namespaceExportString,
  _assignExportString,
  _assignLeftExportString,

}

Object.assign( _.introspector.node, NodeExtension );

})();
