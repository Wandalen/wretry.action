( function _l5_Path_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.path;

// --
//
// --

function escape( filePath )
{
  let self = this;
  let splits = self.split( filePath );

  splits = splits.map( ( split ) =>
  {

    {
      let i = 0;
      while( split[ i ] === '"' )
      i += 1;
      if( i > 0 )
      split = split.substring( 0, i ) + split;
    }

    {
      let i = split.length-1;
      while( split[ i ] === '"' )
      i -= 1;
      if( i < split.length-1 )
      split = split + split.substring( i+1, split.length );
    }

    let left = _.strLeft_( split, self.escapeTokens )
    if( left.entry )
    return `"${split}"`;
    return split;

  });

  return splits.join( self.upToken );
}

// --
// extension
// --

let Extension =
{
  escape,
}

_.props.supplement( Self, Extension );

})();
