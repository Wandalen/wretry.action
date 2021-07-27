(function _ToLayeredHtml_s_()
{

'use strict';

// if( typeof module !== 'undefined' )
// {
//
//   const _ = require( '../../../../../node_modules/Tools' );
//
//   _.include( 'wLogger' );
//
// }

if( !_global_.jQuery )
return;

//

/**
 * @classdesc Creates a printer that writes messages into a DOM container. Based on [wLoggerTop]{@link wLoggerTop}.
 * @class wPrinterToLayeredHtml
 * @namespace Tools
 * @module Tools/base/Logger
 */

let $ = jQuery;
const _global = _global_;
const _ = _global_.wTools;
const Parent = _.Logger;
const Self = wPrinterToLayeredHtml;
function wPrinterToLayeredHtml( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterToLayeredHtml';

//

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self, o );

  self.containerDom = $( self.containerDom );
  _.assert( self.containerDom.length > 0, 'wPrinterToLayeredHtml : not found containerDom' );

  self.containerDom.addClass( self.contentCssClass );

  if( self.vertical )
  self.containerDom.addClass( 'vertical' );
  else
  self.containerDom.addClass( 'horizontal' );

  self.currentDom = self.containerDom;

}

//

function write()
{
  let self = this;

  /* */

  if( arguments.length === 1 )
  if( self.canPrintFrom( arguments[ 0 ] ) )
  {
    self.printFrom( arguments[ 0 ] );
    return;
  }

  /* */

  let o = _.LoggerBasic.prototype.write.apply( self, arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );

  /* */

  let data = _.strConcat.apply( {}, arguments );
  data = data.split( '\n' );

  for( let d = 0 ; d < data.length ; d ++ )
  {
    if( d > 0 )
    self._makeNextLineDom();
    let terminal = self._makeTerminalDom();
    terminal.text( data[ d ] );
  }

  /* */

  return o;
}

//

function levelSet( level )
{
  let self = this;

  _.assert( level >= 0, 'level cant go below zero level to', level );
  _.assert( isFinite( level ) );

  let dLevel = level - self[ levelSymbol ];

  Parent.prototype.levelSet.call( self, level );

  if( dLevel > 0 )
  {
    for( let l = 0 ; l < dLevel ; l++ )
    self.currentDom = self._makeBranchDom();
  }
  else if( dLevel < 0 )
  {
    for( let l = 0 ; l < -dLevel ; l++ )
    self.currentDom = self.currentDom.parent();
  }

}

//

function _makeBranchDom( )
{
  let self = this;
  let result = $( '<' + self.elementCssTag + '>' );

  if( _.props.keys( self.attributes ).length )
  _.dom.s.attr( result, self.attributes );

  self.currentDom.append( result );
  result.addClass( self.branchCssClass );

  if( self.usingRandomColor )
  {
    let color = _.color.randomRgbWithSl( 0.5, 0.5 );
    color[ 3 ] = self.opacity;
    // color = [ 0.75,1,1,0.5 ];
    result.css( 'background-color', _.color.colorToRgbaHtml( color ) );
  }

  return result;
}

//

function _makeTerminalDom()
{
  let self = this;
  let result = $( '<' + self.elementCssTag + '>' );

  if( _.props.keys( self.attributes ).length )
  _.dom.s.attr( result, self.attributes );

  self.currentDom.append( result );
  result.addClass( self.terminalCssClass );

  return result;
}

//

function _makeNextLineDom()
{
  let self = this;

  if( !self.usingNextLineDom )
  return;

  let result = $( '<' + self.elementCssTag + '>' );
  result.text( ' ' );

  result.addClass( self.nextLineCssClass );
  self.currentDom.append( result );

  return result;
}

// --
// relations
// --

let levelSymbol = Symbol.for( 'level' );

let Composes =
{

  contentCssClass : 'layered-log-content',
  branchCssClass : 'layered-log-branch',
  terminalCssClass : 'layered-log-terminal',
  nextLineCssClass : 'layered-log-next-line',

  elementCssTag : 'span',

  opacity : 0.2,
  usingRandomColor : 0,
  usingNextLineDom : 0,

  vertical : 0,

}

let Aggregates =
{
}

let Associates =
{
  containerDom : null,
  currentDom : null,
}

// --
// prototype
// --

let Proto =
{

  init,

  write,

  levelSet,

  _makeBranchDom,
  _makeTerminalDom,
  _makeNextLineDom,


  // relations

  /* constructor * : * Self, */
  Composes,
  Aggregates,
  Associates,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
