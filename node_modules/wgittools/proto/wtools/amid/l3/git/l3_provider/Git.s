( function _Git_s_()
{

'use strict';

const _ = _global_.wTools;
const Parent = _.repo;
_.repo.provider = _.repo.provider || Object.create( null );

// --
// implement
// --

function _open( o )
{
  _.assert( 0, 'not implemented' );
}

_open.defaults =
{
};

//

function repositoryInitAct( o )
{
  _.assert( 0, 'not implemented' );
}

repositoryInitAct.defaults =
{
};

//

function repositoryDeleteAct( o )
{
  _.assert( 0, 'not implemented' );
}

repositoryDeleteAct.defaults =
{
};

// --
// declare
// --

const Self =
{

  name : 'git',
  names : [ 'git', 'git+http', 'git+https', 'git+ssh', 'git+hd', 'git+file' ],

  //

  _open,

  repositoryInitAct,
  repositoryDeleteAct,

}

_.repo.providerAmend({ src : Self });

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
