( function _Repo_s_()
{

'use strict';

const _ = _global_.wTools;
_.repo = _.repo || Object.create( null );
_.repo.provider = _.repo.provider || Object.create( null );

// --
// meta
// --

function _request_functor( fo )
{

  _.routine.options( _request_functor, fo );
  _.assert( _.strDefined( fo.description ) );
  _.assert( _.aux.is( fo.act ) );
  _.assert( _.strDefined( fo.act.name ) );

  const description = fo.description;
  const actName = fo.act.name;

  request_body.defaults =
  {
    logger : 0,
    throwing : 1,
    originalRemotePath : null,
    ... fo.act.defaults,
  }

  const request = _.routine.unite( request_head, request_body );
  return request;

  function request_head( routine, args )
  {
    let o = args[ 0 ];
    if( _.strIs( o ) )
    o = { remotePath : o };
    o = _.routine.options( request, o );
    _.assert( args.length === 1 );
    return o;
  }

  function request_body( o )
  {
    let ready = _.take( null );
    let path = _.git.path;

    _.map.assertHasAll( o, request.defaults );
    o.logger = _.logger.maybe( o.logger );

    o.originalRemotePath = o.originalRemotePath || o.remotePath;
    if( _.strIs( o.remotePath ) )
    o.remotePath = path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });

    ready
    .then( () =>
    {
      let provider = _.repo.providerForPath({ remotePath : o.remotePath, throwing : o.throwing });
      if( provider && !_.routineIs( provider[ actName ] ) )
      throw _.err( `Repo provider ${provider.name} does not support routine ${actName}` );
      return provider[ actName ]( o );
    })
    .then( ( op ) =>
    {
      if( !_.map.is( op ) )
      throw _.err( `Routine ${actName} should return options map. Got:${op}` );

      if( op.result === undefined )
      throw _.err( `Options map returned by routine ${actName} should have {result} field. Got:${op}` );

      return o;
    })
    .catch( ( err ) =>
    {
      if( o.throwing )
      throw _.err( err, `\nFailed to ${description} for ${path.str( o.originalRemotePath )}` );
      _.errAttend( err );
      return null;
    })

    if( o.sync )
    {
      ready.deasync();
      return ready.sync();
    }

    return ready;
  }

}

_request_functor.defaults =
{
  description : null,
  act : null,
}

//

function _collectionExportString_functor( fo )
{

  _.routine.options( _collectionExportString_functor, fo );
  _.assert( arguments.length === 1 );
  _.assert( _.routine.is( fo.elementExportRoutine ) );
  _.assert( _.routine.is( fo.elementExportRoutine.body ) );
  _.assert( _.aux.is( fo.elementExportRoutine.defaults ) );
  _.assert( _.routine.is( fo.formatHeadRoutine ) || _.strDefined( fo.elementsString ) );
  _.assert( _.routine.is( fo.formatHeadRoutine ) || fo.formatHeadRoutine === null );

  const elementsString = fo.elementsString;
  const elementExportRoutine = fo.elementExportRoutine;
  const formatHeadRoutine = fo.formatHeadRoutine ? fo.formatHeadRoutine : formatHeadRoutineDefault;

  elementArrayExportString_body.defaults =
  {
    ... fo.elementExportRoutine.defaults,
    withHead : 1,
    verbosity : 2,
  }

  elementArrayExportString_body.itDefaults =
  {
    tab : '',
    dtab : '  ',
  }

  const elementArrayExportString = _.routine.unite( elementArrayExportString_head, elementArrayExportString_body );
  return elementArrayExportString;

  function elementArrayExportString_head( routine, args )
  {
    _.assert( 1 <= args.length && args.length <= 2 );
    let o = args[ 1 ];
    o = _.routine.options( routine, o );
    o.it = o.it || _.props.extend( null, routine.itDefaults );
    return _.unroll.from([ args[ 0 ], o ]);
  }

  function elementArrayExportString_body( object, o )
  {

    o.verbosity = _.logger.verbosityFrom( o.verbosity );

    if( o.verbosity <= 0 )
    return '';

    if( o.verbosity === 1 )
    {
      if( !object.elements.length )
      return ``;
      return formatHeadRoutine( object, o );
    }

    let result = '';
    object.elements.forEach( ( element ) =>
    {
      if( result.length )
      result += '\n';
      /* xxx : use _.stringer.verbosityUp() */
      result += o.it.tab + o.it.dtab + elementExportRoutine.body.call( _.repo, element, o );
    });

    if( result.length && o.withHead )
    result = `${formatHeadRoutine( object, o )}\n${result}`;

    return result;

  }

  function formatHeadRoutineDefault( object, o )
  {
    let prefix = _.ct.format( elementsString, o.secondaryStyle );
    return `${o.it.tab}${object.elements.length} ${prefix}`;
  }

}

_collectionExportString_functor.defaults =
{
  elementExportRoutine : null,
  formatHeadRoutine : null,
  elementsString : null
}

// --
// provider
// --

function providerForPath( o )
{
  if( _.strIs( o ) )
  o = { remotePath : o };

  _.assert( arguments.length === 1 );
  _.routine.options( providerForPath, o );

  let parsed;
  o.originalRemotePath = o.originalRemotePath || o.remotePath;

  let providerKey = providerGetService( o.originalRemotePath );

  let provider = _.repo.provider[ providerKey ];

  if( !provider )
  {
    if( providerKey )
    {
      provider = _.repo.provider.git;
    }
    else
    {
      providerKey = providerGetProtocol();
      provider = _.repo.provider[ providerKey ];
    }

    if( !provider )
    throw _.err( `No repo provider for path::${ o.originalRemotePath }` );
  }

  return provider;

  /* */

  function providerGetService( remotePath )
  {
    if( _.strIs( o.remotePath ) )
    parsed = o.remotePath = _.git.path.parse({ remotePath, full : 1, atomic : 0, objects : 1 });
    else
    parsed = o.remotePath;

    if( parsed.service )
    {
      _.assert( _.map.assertHasAll( parsed, { user : null, repo : null } ) );
      _.assert( parsed.protocols === undefined || parsed.protocols.length <= 1 || parsed.protocols[ 0 ] === 'git' );
      return parsed.service;
    }
  }

  /* */

  function providerGetProtocol()
  {
    if( !parsed.protocol )
    return _.fileSystem.defaultProtocol;
    return parsed.protocol;
  }
}

// function providerForPath( o )
// {
//   _.routine.options( providerForPath, o );
//   o.originalRemotePath = o.originalRemotePath || o.remotePath;
//   if( _.strIs( o.remotePath ) )
//   o.remotePath = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });
//   let provider = _.repo.provider[ o.remotePath.service ];
//   if( !provider )
//   throw _.err( `No repo provider for service::${o.remotePath.service}` );
//   return provider;
// }

providerForPath.defaults =
{
  originalRemotePath : null,
  remotePath : null,
  throwing : 0,
};

//

function providerAmend( o )
{
  _.routine.options( providerAmend, o );
  _.assert( _.mapIs( o.src ) );
  _.assert( _.strIs( o.src.name ) || _.strsAreAll( o.src.names ) );

  if( !o.src.name )
  o.src.name = o.src.names[ 0 ];
  if( !o.src.names )
  o.src.names = [ o.src.name ];

  _.assert( _.strIs( o.src.name ) );
  _.assert( _.strsAreAll( o.src.names ) );

  let was;
  o.src.names.forEach( ( name ) =>
  {
    _.assert( _.repo.provider[ name ] === was || _.repo.provider[ name ] === undefined );
    was = was || _.repo.provider[ name ];
  });

  o.src.names.forEach( ( name ) =>
  {
    let dst = _.repo.provider[ name ];
    if( !dst )
    dst = _.repo.provider[ name ] = Object.create( null );
    let name2 = dst.name || o.src.name;
    _.props.extend( dst, o.src );
    dst.name = name2;
  });

}

providerAmend.defaults =
{
  src : null,
}

// --
// pr
// --

function pullIs( element )
{
  if( !_.object.isBasic( element ) )
  return false;
  return element.type === 'repo.pull';
}

//

function pullExportString_body( element, o )
{

  _.assert( _.repo.pullIs( element ) );
  o.verbosity = _.logger.verbosityFrom( o.verbosity );

  if( o.verbosity <= 0 )
  return '';

  // let name = _.ct.format( `name::`, o.secondaryStyle ) + element.name;
  // let id = `program#${element.id}`;
  // let state = _.ct.format( `state::`, o.secondaryStyle ) + element.state;
  // let service = _.ct.format( `service::`, o.secondaryStyle ) + element.service;
  // let result = `${id} ${name} ${state} ${service}`;

  let id = `pr#${element.id}`;
  let from = _.ct.format( 'from::', o.secondaryStyle ) + element.from.name;
  let to = _.ct.format( 'to::', o.secondaryStyle ) + element.to.tag;
  let description = _.ct.format( 'description::', o.secondaryStyle ) + element.description.head;
  let result = `${id} ${from} ${to} ${description} `;

  return result;
}

pullExportString_body.defaults =
{
  secondaryStyle : 'tertiary',
  verbosity : 1,
  it : null,
}

let pullExportString = _.routine.unite( 1, pullExportString_body );

//

let pullCollectionExportString = _collectionExportString_functor
({
  elementExportRoutine : pullExportString,
  elementsString : 'program(s)',
});

//

let pullListAct = Object.create( null );

pullListAct.name = 'pullListAct';
pullListAct.defaults =
{
  token : null,
  remotePath : null,
  sync : 1,
  withOpened : 1,
  withClosed : 0,
}

//

let pullList = _request_functor
({
  description : 'get list of pull requests',
  act : pullListAct,
})

//

let pullOpenAct = Object.create( null );

pullOpenAct.name = 'pullOpenAct';
pullOpenAct.defaults =
{
  token : null,
  remotePath : null,
  descriptionHead : null,
  descriptionBody : null,
  srcBranch : null,
  dstBranch : null,
  logger : null,
};

//

function pullOpen( o )
{
  let ready = _.take( null );
  // let ready2 = new _.Consequence();
  let currentBranch;

  if( _.strIs( o ) )
  o = { remotePath : o };
  o = _.routine.options( pullOpen, o );
  o.logger = _.logger.maybe( o.logger );

  if( o.srcBranch === null )
  o.srcBranch = currentBranchGet();
  if( o.dstBranch === null )
  o.dstBranch = currentBranchGet();

  if( !o.token && o.throwing )
  throw _.errBrief( 'Cannot autorize user without user token.' )

  // let parsed = this.objectsParse( o.remotePath );
  let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });

  ready.then( () =>
  {
    if( parsed.service === 'github.com' )
    return pullOpenOnRemoteServer();
    if( o.throwing )
    throw _.err( 'Unknown service' );
    return null;
  })
  .finally( ( err, pr ) =>
  {
    if( err )
    {
      if( o.throwing )
      throw _.err( err, '\nFailed to open pull request' );
      _.errAttend( err );
      return null;
    }
    return pr;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function currentBranchGet()
  {
    if( currentBranch )
    return currentBranch;

    _.assert( _.strDefined( o.localPath ), 'Expects local path {-o.localPath-}' );

    let tag = _.git.tagLocalRetrive
    ({
      localPath : o.localPath,
      detailing : 1,
    });

    if( tag.isBranch )
    currentBranch = tag.tag;
    else
    currentBranch = 'master';
    return currentBranch;
  }

  /* */

  function pullOpenOnRemoteServer()
  {
    const provider = _.repo.providerForPath({ remotePath : o.remotePath });
    let o2 = _.props.extend( null, o );
    o2.remotePath = parsed;
    return provider.pullOpenAct( o2 ); /* xxx : think how to refactor or reorganize it */
  }

  // /* aaa : for Dmytro : move out to github provider */ /* Dmytro : moved to provider */
  // function pullOpenOnGithub()
  // {
  //   let ready = _.take( null );
  //   ready
  //   .then( () =>
  //   {
  //     let github = require( 'octonode' );
  //     let client = github.client( o.token );
  //     let repo = client.repo( `${ parsed.user }/${ parsed.repo }` );
  //     let o2 =
  //     {
  //       descriptionHead : o.descriptionHead,
  //       descriptionBody : o.descriptionBody,
  //       head : o.srcBranch,
  //       base : o.dstBranch,
  //     };
  //     repo.pr( o2, onRequest );
  //
  //     /* */
  //
  //     return ready2
  //     .then( ( args ) =>
  //     {
  //       if( args[ 0 ] )
  //       throw _.err( `Error code : ${ args[ 0 ].statusCode }. ${ args[ 0 ].message }` ); /* Dmytro : the structure of HTTP error is : message, statusCode, headers, body */
  //
  //       if( o.logger && o.logger.verbosity >= 3 )
  //       o.logger.log( args[ 1 ] );
  //       else if( o.logger && o.logger.verbosity >= 1 )
  //       o.logger.log( `Succefully created pull request "${ o.descriptionHead }" in ${ o.remotePath }.` )
  //
  //       return args[ 1 ];
  //     });
  //   });
  //   return ready;
  // }
  //
  // /* aaa : for Dmytro : ?? */ /* Dmytro : really strange code */
  // function onRequest( err, body, headers )
  // {
  //   return _.time.begin( 0, () => ready2.take([ err, body ]) );
  // }

}

pullOpen.defaults =
{
  throwing : 1,
  sync : 1,
  logger : 2,
  token : null,
  remotePath : null,
  localPath : null,
  // title : null, /* aaa : for Dmytro : rename to descriptionHead */
  // body : null, /* aaa : for Dmytro : rename to descriptionBody */
  descriptionHead : null,
  descriptionBody : null,
  srcBranch : null, /* aaa : for Dmytro : should get current by default */ /* Dmytro : implemented and covered */
  dstBranch : null, /* aaa : for Dmytro : should get current by default */ /* Dmytro : implemented and covered */
};

// --
// program
// --

function programIs( object )
{
  if( !_.object.isBasic( object ) )
  return false;
  return object.type === 'repo.program';
}

//

function programExportString_body( element, o )
{

  _.assert( _.repo.programIs( element ) );
  o.verbosity = _.logger.verbosityFrom( o.verbosity );

  if( o.verbosity <= 0 )
  return '';

  let name = _.ct.format( `name::`, o.secondaryStyle ) + element.name;
  let id = `program#${element.id}`;
  let state = _.ct.format( `state::`, o.secondaryStyle ) + element.state;
  let service = _.ct.format( `service::`, o.secondaryStyle ) + element.service;
  let result = `${id} ${name} ${state} ${service}`;

  return result;
}

programExportString_body.defaults =
{
  secondaryStyle : 'tertiary',
  verbosity : 1,
  it : null,
}

let programExportString = _.routine.unite( 1, programExportString_body );

//

let programCollectionExportString = _collectionExportString_functor
({
  elementExportRoutine : programExportString,
  elementsString : 'program(s)',
});

//

let programListAct = Object.create( null );

programListAct.name = 'programListAct';
programListAct.defaults =
{
  token : null,
  remotePath : null,
  sync : 1,
  withOpened : 1,
  withClosed : 0,
}

//

let programList = _request_functor
({
  description : 'get list of programs',
  act : programListAct,
})

// --
// etc
// --

function vcsFor( o )
{
  if( !_.mapIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1 );
  _.routine.options( vcsFor, o );

  if( _.arrayIs( o.filePath ) && o.filePath.length === 0 )
  return null;

  if( !o.filePath )
  return null;

  _.assert( _.strIs( o.filePath ) );
  _.assert( _.git.path.isGlobal( o.filePath ) );
  // _.assert( _.uri.isGlobal( o.filePath ) );

  let parsed = _.git.path.parse( o.filePath );
  // let parsed = _.uri.parseFull( o.filePath );

  if( _.git && _.longHas( _.git.protocols, parsed.protocol ) )
  return _.git;
  if( _.npm && _.longHasAny( _.npm.protocols, parsed.protocol ) )
  return _.npm;
  if( _.http && _.longHasAny( _.http.protocols, parsed.protocol ) )
  return _.http;

  // if( _.git && _.longHasAny( parsed.protocols, _.git.protocols ) )
  // return _.git;
  // if( _.npm && _.longHasAny( parsed.protocols, _.npm.protocols ) )
  // return _.npm;

  return null;
}

vcsFor.defaults =
{
  filePath : null,
};

// --
// declare
// --

let Extension =
{

  // meta

  _request_functor,
  _collectionExportString_functor,

  // provider

  providerForPath,
  providerAmend,

  // pr

  pullIs,
  pullExportString,
  pullCollectionExportString,

  pullListAct,
  pullList, /* aaa : for Dmytro : cover */ /* Dmytro : covered */

  pullOpenAct, /* aaa : for Dmytro : add */ /* Dmytro : added */
  pullOpen,

  // program

  programIs,
  programExportString,
  programCollectionExportString,

  programListAct,
  programList,

  // etc

  vcsFor,

}

/* _.props.extend */Object.assign( _.repo, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
