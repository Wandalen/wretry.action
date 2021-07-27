( function _Trie_s_()
{

'use strict';

/**
 * Modest implementation of trie.
 * @module Tools/base/Trie
*/

const _ = _global_.wTools;
_.trie = _.trie || Object.create( null );

// --
// dichotomy
// --

function is( node )
{
  if( !_.aux.is( node ) )
  return false;
  if( !node.ups )
  return false;
  return true;
}

//

function make()
{
  _.assert( arguments.length === 0 );
  let node = Object.create( null );
  node.vals = new Set();
  node.ups = Object.create( null );
  return node;
}

// --
// writer
// --

function makeWithPath_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    o = { root : args[ 0 ], path : args[ 1 ] }
  }

  _.routine.options( routine, o );
  _.assert( _.longIs( o.path ) );
  _.assert( o.root === null || self.is( o.root ), () => `Expects node of trie or null, but got ${_.strType( o.root )}` );

  return o;
}

//

function makeWithPath_body( o )
{
  let self = this;

  if( o.root === null )
  o.root = self.make();

  let trace = o.trace = [];

  trace.push([ o.root, 0, o.path.length ]);

  for( let i = 0 ; i < trace.length ; i++ )
  act( ... trace[ i ] );

  return o;

  function act( node, f, l )
  {
    if( f === l )
    {
      o.child = node;
      return;
    }
    let node2 = node.ups[ o.path[ f ] ];
    if( !node2 )
    node2 = node.ups[ o.path[ f ] ] = self.make();
    trace.push([ node2, f+1, l ]);
  }

}

makeWithPath_body.defaults =
{
  root : null,
  path : null,
}

let makeWithPath = _.routine.unite( makeWithPath_head, makeWithPath_body );

//

function addSingle_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 3 );

  let o = args[ 0 ]
  if( args.length === 3 )
  {
    if( args.length === 3 )
    o = { root : args[ 0 ], path : args[ 1 ], val : args[ 2 ] }
    else
    o = { root : args[ 0 ] };
  }

  _.routine.options( routine, o );
  _.assert( _.longIs( o.path ) );
  _.assert( o.root === null || self.is( o.root ), () => `Expects node of trie or null, but got ${_.strType( o.root )}` );

  return o;
}

//

function addSingle_body( o )
{
  let self = this;
  self.makeWithPath.body.call( self, o );
  o.child.vals.add( o.val );
  return o;
}

addSingle_body.defaults =
{
  root : null,
  path : null,
  val : null,
}

let addSingle = _.routine.unite( addSingle_head, addSingle_body );

//

function addMultiple_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 3 );

  let o = args[ 0 ]
  if( args.length === 3 )
  {
    if( args.length === 3 )
    o = { root : args[ 0 ], path : args[ 1 ], vals : args[ 2 ] }
    else
    o = { root : args[ 0 ] };
  }

  _.routine.options( routine, o );
  _.assert( _.longIs( o.path ) );
  _.assert( o.root === null || self.is( o.root ), () => `Expects node of trie or null, but got ${_.strType( o.root )}` );
  _.assert( _.countable.is( o.vals ) );

  return o;
}

//

function addMultiple_body( o )
{
  let self = this;
  self.makeWithPath.body.call( self, o );
  if( o.onVal )
  {
    for( let val of o.vals )
    o.child.vals.add( o.onVal( val, o ) );
  }
  else
  {
    for( let val of o.vals )
    o.child.vals.add( val );
  }
  return o;
}

addMultiple_body.defaults =
{
  root : null,
  path : null,
  vals : null,
  onVal : null,
}

let addMultiple = _.routine.unite( addMultiple_head, addMultiple_body );

//

function addDeep_body( o )
{
  let self = this;
  let path = o.path;
  let l = o.path.length;

  for( let i = 0 ; i <= l ; i++ )
  {
    o.path = path.slice( i, l );
    self.addMultiple.body.call( self, o );
  }

  o.path = path;
  return o;
}

addDeep_body.defaults =
{
  ... addMultiple.defaults,
}

let addDeep = _.routine.unite( addMultiple_head, addDeep_body );

//

function delete_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ];

  _.routine.options( routine, o );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );
  _.assert( self.is( o.node ), () => `Expects node of trie, but got ${_.strType( o.node )}` );
  _.assert
  (
    o.vals === null || _.countableIs( o.vals ), () => `Vals should countable if specified, but it is ${_.strType( o.vals )}`
  );

  return o;
}

//

function delete_body( o )
{
  let self = this;

  if( o.vals === null )
  for( let val of o.node.vals )
  {
    o.node.vals.delete( val );
  }
  else
  for( let val of o.vals )
  {
    o.node.vals.delete( val );
  }

  return o;
}

delete_body.defaults =
{
  node : null,
  vals : null,
}

let _delete = _.routine.unite( delete_head, delete_body );

//

function deleteWithPath_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );

  let o = args[ 0 ]
  if( args.length == 2 )
  {
    o = { root : args[ 0 ], path : args[ 1 ] }
  }
  else if( args.length == 3 )
  {
    if( args.length === 3 )
    o = { root : args[ 0 ], path : args[ 1 ], vals : args[ 2 ] }
    else
    o = { root : args[ 0 ] };
  }

  _.routine.options( routine, o );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );
  _.assert( _.longIs( o.path ) );
  _.assert
  (
    o.vals === null || _.countableIs( o.vals ), () => `Vals should countable if specified, but it is ${_.strType( o.vals )}`
  );

  return o;
}

//

function deleteWithPath_body( o )
{
  let self = this;

  self.withPath.body.call( self, o );
  if( !o.child )
  return o;

  o.node = o.child;
  self.delete.body.call( self, o );

  if( o.child.vals.size === 0 && Object.keys( o.child.ups ).length === 0 && o.shrinking )
  self.shrinkWithPath.body.call( self, o );

  return o;
}

deleteWithPath_body.defaults =
{
  root : null,
  path : null,
  vals : null,
  shrinking : true,
}

let deleteWithPath = _.routine.unite( deleteWithPath_head, deleteWithPath_body );

//

function shrinkWithPath_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );

  let o = args[ 0 ]
  if( args.length == 2 )
  {
    o = { root : args[ 0 ], path : args[ 1 ] }
  }
  else if( args.length == 3 )
  {
    if( args.length === 3 )
    o = { root : args[ 0 ], path : args[ 1 ], vals : args[ 2 ] }
    else
    o = { root : args[ 0 ] };
  }

  _.routine.options( routine, o );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );
  _.assert( o.path === null || _.longIs( o.path ) );
  _.assert( o.trace === null || _.longIs( o.trace ) );

  return o;
}

//

function shrinkWithPath_body( o )
{
  let self = this;

  if( !o.trace )
  {
    self.withPath.body.call( self, o );
    if( !o.child )
    return o;
  }

  let node = o.trace[ o.trace.length - 1 ][ 0 ];
  if( node.vals.size !== 0 || Object.keys( node.ups ).length !== 0 )
  {
    o.child = undefined;
    return o;
  }

  for( let i = o.trace.length - 1 ; i >= 0 ; i-- )
  if( o.trace[ i ][ 0 ].vals.size > 0 )
  {
    o.childLevel = i + 1;
    o.child = o.trace[ o.childLevel ];
    if( !o.child )
    return;
    o.child = o.child[ 0 ];
    o.parent = o.trace[ i ][ 0 ];
    _.assert( o.parent.ups[ o.path[ i ] ] === o.child );
    delete o.parent.ups[ o.path[ i ] ];
    return o;
  }
  o.child = o.root;

  return o;
}

shrinkWithPath_body.defaults =
{
  root : null,
  path : null,
  trace : null,
}

let shrinkWithPath = _.routine.unite( shrinkWithPath_head, shrinkWithPath_body );

//

function shrink_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  let o = args[ 0 ]
  if( self.is( o ) )
  o = { root : o }

  _.routine.options( routine, o );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );

  return o;
}

//

function shrink_body( o )
{
  let self = this;

  let stack = [];
  stack.push([ o.root, null, null ]);

  debugger;

  for( let i = 0 ; i < stack.length ; i++ )
  actUp( ... stack[ i ] );

  for( let i = stack.length - 1 ; i >= 0 ; i-- )
  actDown( ... stack[ i ] );

  debugger;

  return o;

  function actUp( node )
  {
    for( let k in node.ups )
    {
      let node2 = node.ups[ k ];
      stack.push([ node2, k, node ]);
    }
  }

  function actDown( child, key, parent )
  {
    debugger;
    if( parent !== null )
    if( child.vals.size === 0 && Object.keys( child.ups ).length === 0 )
    {
      debugger;
      _.assert( parent.ups[ key ] === child );
      delete parent.ups[ key ];
      o.counter += 1;
    }

  }

}

shrink_body.defaults =
{
  counter : 0,
  root : null,
}

let shrink = _.routine.unite( shrink_head, shrink_body );

// --
// reader
// --

function withPath_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    o = { root : args[ 0 ], path : args[ 1 ] }
  }

  _.routine.options( routine, o );
  _.assert( _.longIs( o.path ) );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );

  return o;
}

//

function withPath_body( o )
{
  let self = this;
  let trace = o.trace = [];

  trace.push([ o.root, 0, o.path.length ]); /* xxx : remove 3rd argument */

  for( let i = 0 ; i < trace.length ; i++ )
  act( ... trace[ i ] );

  return o;

  function act( node, f, l )
  {
    if( f === l )
    {
      o.child = node;
      return;
    }
    let node2 = node.ups[ o.path[ f ] ];
    if( !node2 )
    return;
    trace.push([ node2, f+1, l ]);
  }

}

withPath_body.defaults =
{
  root : null,
  path : null,
}

let withPath = _.routine.unite( withPath_head, withPath_body );

//

function valEach_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  let o = args[ 0 ]
  if( self.is( o ) )
  {
    o = { root : args[ 0 ] }
  }

  _.routine.options( routine, o );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );

  return o;
}

//

function valEach_body( o )
{
  let self = this;

  o.vals = o.vals || new Set;

  let stack = [];
  stack.push([ o.root ]);

  if( _.setIs( o.vals ) )
  {
    while( stack.length )
    actSet( ... stack.pop() );
  }
  else
  {
    while( stack.length )
    actArray( ... stack.pop() );
  }

  return o;

  function actSet( node )
  {
    for( let k in node.ups )
    {
      let node2 = node.ups[ k ];
      stack.push([ node2 ]);
    }
    for( let val of node.vals )
    {
      o.vals.add( val );
    }
  }

  function actArray( node )
  {
    for( let k in node.ups )
    {
      let node2 = node.ups[ k ];
      stack.push([ node2 ]);
    }
    for( let val of node.vals )
    {
      _.arrayAppendOnce( o.vals, val );
    }
  }

}

valEach_body.defaults =
{
  root : null,
  vals : null,
}

let valEach = _.routine.unite( valEach_head, valEach_body );

//

function valEachAbove_head( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    o = { root : args[ 0 ], path : args[ 1 ] }
  }

  _.routine.options( routine, o );
  _.assert( self.is( o.root ), () => `Expects node of trie, but got ${_.strType( o.root )}` );

  return o;
}

//

function valEachAbove_body( o )
{
  let self = this;

  o.vals = o.vals || [];

  self.withPath.body.call( self, o );
  if( !o.child )
  return o;

  o.root = o.child;
  self.valEach.body.call( self, o );

  return o;
}

valEachAbove_body.defaults =
{
  root : null,
  path : null,
  vals : null,
}

let valEachAbove = _.routine.unite( withPath_head, valEachAbove_body );

// --
// declare
// --

let Proto =
{

  // dichotomy

  is,
  make,

  // writer

  makeWithPath,
  addSingle,
  addMultiple,
  add : addMultiple,
  addDeep,
  delete : _delete,
  deleteWithPath,
  shrinkWithPath,
  shrink,

  // reader

  withPath,
  valEach,
  valEachAbove,

}

//

/* _.props.extend */Object.assign( _.trie, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

