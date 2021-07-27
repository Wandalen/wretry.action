( function _l1_Path_s_()
{

'use strict';

/**
 * @summary Collection of cross-platform routines to operate paths reliably and consistently.
 * @namespace wTools.path
 * @extends Tools
 */

const _global = _global_;
const _ = _global_.wTools;
_.path = _.path || Object.create( null );

// --
// implementation
// --

// function _normalize( o )
// {
//   // let debug = 0;
//   // if( 0 )
//   // debug = 1;
//
//   // _.routine.assertOptions( _normalize, arguments );
//   _.assert( _.strIs( o.src ), 'Expects string' );
//
//   if( !o.src.length )
//   return '';
//
//   let result = o.src;
//
//   result = this.refine( result );
//
//   // if( debug )
//   // console.log( 'normalize.refined : ' + result );
//
//   /* detrailing */
//
//   if( o.tolerant )
//   {
//     /* remove "/" duplicates */
//     result = result.replace( this._delUpDupRegexp, this.upToken );
//   }
//
//   let endsWithUp = false;
//   let beginsWithHere = false;
//
//   /* remove right "/" */
//
//   if( result !== this.upToken && !_.strEnds( result, this.upToken + this.upToken ) && _.strEnds( result, this.upToken ) )
//   {
//     endsWithUp = true;
//     result = _.strRemoveEnd( result, this.upToken );
//   }
//
//   /* undoting */
//
//   while( !_.strBegins( result, this.hereUpToken + this.upToken ) && _.strBegins( result, this.hereUpToken ) )
//   {
//     beginsWithHere = true;
//     result = _.strRemoveBegin( result, this.hereUpToken );
//   }
//
//   /* remove second "." */
//
//   if( result.indexOf( this.hereToken ) !== -1 )
//   {
//
//     while( this._delHereRegexp.test( result ) )
//     result = result.replace( this._delHereRegexp, function( match, postSlash )
//     {
//       return postSlash || '';
//     });
//     if( result === '' )
//     result = this.upToken;
//
//   }
//
//   /* remove .. */
//
//   if( result.indexOf( this.downToken ) !== -1 )
//   {
//
//     while( this._delDownRegexp.test( result ) )
//     result = result.replace( this._delDownRegexp, function( /* match, notBegin, split, preSlash, postSlash */ )
//     {
//       let match = arguments[ 0 ];
//       let notBegin = arguments[ 1 ];
//       let split = arguments[ 2 ];
//       let preSlash = arguments[ 3 ];
//       let postSlash = arguments[ 4 ];
//
//       if( preSlash === '' )
//       return notBegin;
//       if( !notBegin )
//       return notBegin + preSlash;
//       else
//       return notBegin + ( postSlash || '' );
//     });
//
//   }
//
//   /* nothing left */
//
//   if( !result.length )
//   result = '.';
//
//   /* dot and trail */
//
//   if( o.detrailing )
//   if( result !== this.upToken && !_.strEnds( result, this.upToken + this.upToken ) )
//   result = _.strRemoveEnd( result, this.upToken );
//
//   if( !o.detrailing && endsWithUp )
//   if( result !== this.rootToken )
//   result = result + this.upToken;
//
//   if( !o.undoting && beginsWithHere )
//   result = this._dot( result );
//
//   // if( debug )
//   // console.log( 'normalize.result : ' + result );
//
//   return result;
// }
//
// _normalize.defaults =
// {
//   src : null,
//   tolerant : false,
//   detrailing : false,
//   undoting : false,
// }
//
// //
//
// /**
//  * Regularize a path by collapsing redundant delimeters and resolving '..' and '.' segments,so A//B,A/./B and
//     A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links.
//     On Windows,it converts forward slashes to backward slashes. If the path is an empty string,method returns '.'
//     representing the current working directory.
//  * @example
//    let path = '/foo/bar//baz1/baz2//some/..'
//    path = wTools.normalize( path ); // /foo/bar/baz1/baz2
//  * @param {string} src path for normalization
//  * @returns {string}
//  * @function normalize
//  * @namespace Tools.path
//  */
//
// function normalize( src )
// {
//   let result = this._normalize({ src, tolerant : false, detrailing : false, undoting : false });
//
//   _.assert( _.strIs( src ), 'Expects string' );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( result.lastIndexOf( this.upToken + this.hereToken + this.upToken ) === -1 );
//   _.assert( !_.strEnds( result, this.upToken + this.hereToken ) );
//
//   if( Config.debug )
//   {
//     let i = result.lastIndexOf( this.upToken + this.downToken + this.upToken );
//     _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
//   }
//
//   return result;
// }
//
// //
//
// function canonize( src )
// {
//   let result = this._normalize({ src, tolerant : false, detrailing : true, undoting : true });
//
//   _.assert( _.strIs( src ), 'Expects string' );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( result === this.upToken || _.strEnds( result, this.upToken + this.upToken ) || !_.strEnds( result, this.upToken ) );
//   _.assert( result.lastIndexOf( this.upToken + this.hereToken + this.upToken ) === -1 );
//   _.assert( !_.strEnds( result, this.upToken + this.hereToken ) );
//
//   if( Config.debug )
//   {
//     let i = result.lastIndexOf( this.upToken + this.downToken + this.upToken );
//     _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
//   }
//
//   return result;
// }

// --
// extension
// --

let Extension =
{

  // _normalize,
  // normalize,
  // canonize,

}

//

Object.assign( _.path, Extension );

})();
