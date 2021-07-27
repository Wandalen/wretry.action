( function _l5_Entity_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// exporter
// --

function exportStringDiagnosticShallow( src, opts )
{
  let result = '';
  _.assert( arguments.length === 1 || arguments.length === 2 );
  result = _.entity.exportStringDiagnosticShallow( src );
  return result;
}

//

/* xxx : qqq : for junior : take into account throwing cases */
/* qqq : for junior : optimize. ask how to */
function _exportStringShallow( src, o )
{

  _.assert( arguments.length === 2 );
  _.assert( _.number.is( o.widthLimit ) && o.widthLimit >= 0 );
  _.assert( _.number.is( o.heightLimit ) && o.heightLimit >= 0 );
  _.assert( o.src === undefined )
  _.assert( o.format === 'string.diagnostic' || o.format === 'string.code' );

  let result = '';
  let method = o.format === 'string.diagnostic' ? 'exportStringDiagnosticShallow' : 'exportStringCodeShallow';

  try
  {

    let namespace = this.namespaceForExporting( src );
    if( namespace === null )
    {
      _.assert( 0, 'not tested' );
      namespace = _.blank;
    }

    result = namespace[ method ]( src );
    result = _.strShort_({ src : result, widthLimit : o.widthLimit, heightLimit : o.heightLimit }).result;

  }
  catch( err )
  {
    debugger;
    throw err;
  }

  return result;
}

_exportStringShallow.defaults =
{
  format : null,
  widthLimit : 0,
  heightLimit : 0,
}

//

function exportStringCodeShallow( src, o ) /* */
{
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects one or two arguments' );

  o = _.routine.options_( exportStringCodeShallow, o || null );
  o.format = o.format || exportStringCodeShallow.defaults.format;

  return _.entity._exportStringShallow( src, o );
}

exportStringCodeShallow.defaults =
{
  format : 'string.code', /* [ 'string.diagnostic', 'string.code' ] */ /* qqq for junior : implement and cover */
  widthLimit : 0, /* qqq for junior : implement and cover, use strShort_ */
  heightLimit : 0, /* qqq for junior : implement and cover */
}

//

function exportStringDiagnosticShallow( src, o ) /* */
{
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects one or two arguments' );
  o = _.aux.supplement( o || null, exportStringDiagnosticShallow.defaults );
  o.format = o.format || exportStringDiagnosticShallow.defaults.format;
  return _.entity._exportStringShallow( src, o );
}

exportStringDiagnosticShallow.defaults =
{
  format : 'string.diagnostic', /* [ 'string.diagnostic', 'string.code' ] */ /* qqq for junior : implement and cover */
  widthLimit : 0, /* qqq for junior : implement and cover, use strShort_ */
  heightLimit : 0, /* qqq for junior : implement and cover */
}

// --
//
// --

function cloneDeep( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !src || _.primitive.is( src ) )
  {
    return src;
  }
  else if( _.replicate )
  {
    debugger;
    return _.replicate({ src });
  }
  else if( _.routine.is( src[ _.class.cloneDeepSymbol ] ) ) /* aaa2 : cover */ /* Dmytro : coverage extended for objects with method under symbol cloneShallowSymbol */
  {
    return src[ _.class.cloneDeepSymbol ]();
  }
  else if( _.routine.is( src.cloneDeep ) ) /* aaa2 : cover */ /* Dmytro : coverage extended for objects with method cloneShallow */
  {
    return src.cloneDeep();
  }
  else if( _.arrayIs( src ) )
  {
    return Array.from( src );
  }
  else if( _.longLike( src ) )
  {
    let toolsNamespace = this.Tools ? this.Tools : this;
    return toolsNamespace.long.make( src );
  }
  else if( _.hashMap.like( src ) || _.set.like( src ) )
  {
    return new src.constructor( src );
  }
  else if( _.aux.is( src ) )
  {
    return _.aux.cloneShallow( src );
  }
  else if( _.routine.is( src.constructor ) ) /* aaa2 : cover */ /* Dmytro : coverage extended for entities with constructor */
  {
    return new src.constructor( src );
  }
  else _.assert( 0, `Not clear how to make a new element of \`${_.entity.strType( src )}\` with \`_.entity.cloneDeep()\`` );

}

//

/**
 * Copies entity( src ) into( dst ) or returns own copy of( src ).Result depends on several moments:
 * -If( src ) is a Object - returns clone of( src ) using ( onRecursive ) callback function if its provided;
 * -If( dst ) has own 'copy' routine - copies( src ) into( dst ) using this routine;
 * -If( dst ) has own 'set' routine - sets the fields of( dst ) using( src ) passed to( dst.set );
 * -If( src ) has own 'clone' routine - returns clone of( src ) using ( src.clone ) routine;
 * -If( src ) has own 'slice' routine - returns result of( src.slice ) call;
 * -Else returns a copy of entity( src ).
 *
 * @param {object} dst - Destination object.
 * @param {object} src - Source object.
 * @param {routine} onRecursive - The callback function to copy each [ key, value ].
 * @see {@link wTools.mapCloneAssigning} Check this function for more info about( onRecursive ) callback.
 * @returns {object} Returns result of entities copy operation.
 *
 * @example
 * let dst = { set : function( src ) { this.str = src.src } };
 * let src = { src : 'string' };
 *  _.entity.assign2( dst, src );
 * console.log( dst.str )
 * // log "string"
 *
 * @example
 * let dst = { copy : function( src ) { for( let i in src ) this[ i ] = src[ i ] } }
 * let src = { src : 'string', num : 123 }
 *  _._.entity.assign2( dst, src );
 * console.log( dst )
 * // log Object { src: "string", num: 123 }
 *
 * @example
 *  _._.entity.assign2( null, new String( 'string' ) );
 * // returns 'string'
 *
 * @function assign
 * @throws {exception} If( arguments.length ) is not equal to 3 or 2.
 * @throws {exception} If( onRecursive ) is not a Routine.
 * @namespace Tools.entity
 *
 */

function assign2( dst, src, onRecursive )
{
  let result;

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  _.assert( arguments.length < 3 || _.routine.is( onRecursive ) );

  if( src === null )
  {

    result = src;

  }
  else if( dst && _.routine.is( dst.copy ) )
  {

    dst.copy( src );

  }
  else if( src && _.routine.is( src.clone ) )
  {

    if( dst instanceof src.constructor )
    {
      throw _.err( 'not tested' );
      result = src.clone( dst );
    }
    else if( _.primitive.is( dst ) || _.longIs( dst ) )
    {
      result = src.clone();
    }
    else _.assert( 0, 'unknown' );

  }
  else if( src && _.routine.is( src.slice ) )
  {

    result = src.slice();

  }
  else if( dst && _.routine.is( dst.set ) )
  {

    dst.set( src );

  }
  else if( _.object.isBasic( src ) )
  {

    if( onRecursive )
    {
      result = _.mapCloneAssigning
      ({
        srcMap : src,
        dstMap : _.primitive.is( dst ) ? Object.create( null ) : dst,
        onField : onRecursive
      });
    }
    else
    {
      result = _.mapCloneAssigning({ srcMap : src });
    }

  }
  else
  {

    result = src;

  }

  return result;
}

//

/**
 * Short-cut for _.entity.assign2 function. Copies specified( name ) field from
 * source container( srcContainer ) into( dstContainer ).
 *
 * @param {object} dstContainer - Destination object.
 * @param {object} srcContainer - Source object.
 * @param {string} name - Field name.
 * @param {mapCloneAssigning.onField} onRecursive - The callback function to copy each [ key, value ].
 * @see {@link wTools.mapCloneAssigning} Check this function for more info about( onRecursive ) callback.
 * @returns {object} Returns result of entities copy operation.
 *
 * @example
 * let dst = {};
 * let src = { a : 'string' };
 * let name = 'a';
 * _.entity.assign2FieldFromContainer( dst, src, name );
 * console.log( dst.a === src.a );
 * // log true
 *
 * @example
 * let dst = {};
 * let src = { a : 'string' };
 * let name = 'a';
 * function onRecursive( dstContainer, srcContainer, key )
 * {
 *   _.assert( _.strIs( key ) );
 *   dstContainer[ key ] = srcContainer[ key ];
 * };
 * _.entity.assign2FieldFromContainer( dst, src, name, onRecursive );
 * console.log( dst.a === src.a );
 * // log true
 *
 * @function assignFieldFromContainer
 * @throws {exception} If( arguments.length ) is not equal to 3 or 4.
 * @namespace Tools.entity
 *
 */

function assign2FieldFromContainer( /* dstContainer, srcContainer, name, onRecursive */ )
{
  let dstContainer = arguments[ 0 ];
  let srcContainer = arguments[ 1 ];
  let name = arguments[ 2 ];
  let onRecursive = arguments[ 3 ];
  let result;

  _.assert( _.strIs( name ) || _.symbol.is( name ) );
  _.assert( arguments.length === 3 || arguments.length === 4 );

  let dstValue = Object.hasOwnProperty.call( dstContainer, name ) ? dstContainer[ name ] : undefined;
  let srcValue = srcContainer[ name ];

  if( onRecursive )
  result = _.entity.assign2( dstValue, srcValue, onRecursive );
  else
  result = _.entity.assign2( dstValue, srcValue );

  if( result !== undefined )
  dstContainer[ name ] = result;

  return result;
}

//

/**
 * Short-cut for _.entity.assign2 function. Assigns value of( srcValue ) to container( dstContainer ) field specified by( name ).
 *
 * @param {object} dstContainer - Destination object.
 * @param {object} srcValue - Source value.
 * @param {string} name - Field name.
 * @param {mapCloneAssigning.onField} onRecursive - The callback function to copy each [ key, value ].
 * @see {@link wTools.mapCloneAssigning} Check this function for more info about( onRecursive ) callback.
 * @returns {object} Returns result of entity field assignment operation.
 *
 * @example
 * let dstContainer = { a : 1 };
 * let srcValue = 15;
 * let name = 'a';
 * _.entity.assign2Field( dstContainer, srcValue, name );
 * console.log( dstContainer.a );
 * // log 15
 *
 * @function assignField
 * @throws {exception} If( arguments.length ) is not equal to 3 or 4.
 * @namespace Tools
 *
 */

function assign2Field( /* dstContainer, srcValue, name, onRecursive */ )
{
  let dstContainer = arguments[ 0 ];
  let srcValue = arguments[ 1 ];
  let name = arguments[ 2 ];
  let onRecursive = arguments[ 3 ];

  let result;

  _.assert( _.strIs( name ) || _.symbol.is( name ) );
  _.assert( arguments.length === 3 || arguments.length === 4 );

  let dstValue = dstContainer[ name ];

  if( onRecursive )
  {
    throw _.err( 'not tested' );
    result = _.entity.assign2( dstValue, srcValue, onRecursive );
  }
  else
  {
    result = _.entity.assign2( dstValue, srcValue );
  }

  if( result !== undefined )
  dstContainer[ name ] = result;

  return result;
}

// --
// tools extension
// --

let ToolsExtension =
{

}

//

Object.assign( _, ToolsExtension );

// --
// entity extension
// --

let EntityExtension =
{

  // exporter

  exportStringDiagnosticShallow,

  _exportStringShallow,
  exportString : exportStringDiagnosticShallow,
  exportStringCodeShallow,
  exportStringDiagnosticShallow,

  // etc

  cloneDeep,

  assign2, /* xxx : refactor */
  assign2FieldFromContainer, /* dubious */
  assign2Field, /* dubious */

}

//

Object.assign( _.entity, EntityExtension );

})();
