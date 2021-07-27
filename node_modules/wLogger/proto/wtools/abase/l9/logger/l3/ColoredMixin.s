(function _aColoredMixin_s_()
{

'use strict';

/**
 * @classdesc Extends printer with mechanism of message coloring. Works on server-side and in the browser. Supports colors stacking, output styling, ill colors and color collapse diagnosting.
 * @class wPrinterColoredMixin
 * @namespace Tools
 * @module Tools/base/Logger
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wPrinterColoredMixin;
function wPrinterColoredMixin( o )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterColoredMixin';

_.assert( _.routineIs( _.strSplitInlined ) );
// _.assert( _.routineIs( _.strSplitInlinedStereo_ ) );

// --
// stack
// --

function _stackPush( layer, color )
{
  let self = this;

  if( !self._colorsStack )
  self._colorsStack = { 'foreground' : [], 'background' : [] };

  self._colorsStack[ layer ].push( color );
}

//

function _stackPop( layer )
{
  let self = this;

  return self._colorsStack[ layer ].pop();
}

//

function _stackIsNotEmpty( layer )
{
  let self = this;

  if( self._colorsStack && self._colorsStack[ layer ].length )
  return true;

  return false;
}

// --
// transform
// --

function _transformActHtml( o )
{
  let self = this;
  let result = '';
  let spanCount = 0;
  let splitted = o._outputSplitted;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.arrayIs( o._outputSplitted ) );
  _.assert( !o._outputForTerminal );

  let options = _.mapOnly_( null, o, _transformActHtml.defaults );
  _.routine.options_( _transformActHtml, options );

  for( let i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      let style = splitted[ i ][ 0 ];
      let color = splitted[ i ][ 1 ].trim();

      if( color && color !== 'default' )
      {
        color = _.color.rgbaFromTry( color );
        if( color )
        color = _.color.rgbaFrom({ src : color, colorMap : _.color.ColorMap })
      }

      if( style === 'foreground')
      {
        self.foregroundColor = color;
      }
      else if( style === 'background')
      {
        self.backgroundColor = color;
      }

      let fg = self.foregroundColor;
      let bg = self.backgroundColor;

      if( !fg || fg === 'default' )
      fg = null;

      if( !bg || bg === 'default' )
      bg = null;

      if( color === 'default' && spanCount )
      {
        result += `</${options.tag}>`;
        spanCount--;
      }
      else
      {
        let style = '';

        if( options.compact )
        {
          if( fg )
          style += `color:${ _.color.colorToRgbaHtml( fg ) };`;

          if( bg )
          style += `background:${ _.color.colorToRgbaHtml( bg ) };`;
        }
        else
        {
          fg = fg || 'transparent';
          bg = bg || 'transparent';
          style = `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };`;
        }

        if( style.length )
        result += `<${options.tag} style='${style}'>`;
        else
        result += `<${options.tag}>`;

        spanCount++;
      }
    }
    else
    {
      let text = _.strReplaceAll( splitted[ i ], '\n', '<br>' );

      if( !options.compact && !spanCount )
      {
        result += `<${options.tag}>${text}</${options.tag}>`;
      }
      else
      result += text;
    }
  }

  _.assert( spanCount === 0 );

  o._outputForTerminal = [ result ];
  return o;
}

_transformActHtml.defaults =
{
  tag : 'span',
  compact : true,
}

//

function _transformAct_nodejs( o )
{
  let self = this;
  let result = '';
  let splitted = o._outputSplitted;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.arrayIs( o._outputSplitted ) );
  _.assert( !o._outputForTerminal );

  splitted.forEach( function( split )
  {
    let output = !!_.color;

    if( _.arrayIs( split ) )
    {
      self._directiveApply( split );
      if( output && self.outputRaw )
      output = 0;
      if( output && self.outputGray && _.longHas( self.DirectiveColoring, split[ 0 ] ) )
      output = 0;

      if( !self.inputRaw && !self.outputRaw )
      if( split[ 0 ] === 'cls' )
      result += self._directiveClsApply( split[ 1 ].trim() );
      else if( split[ 0 ] === 'move' )
      result += self._directiveMoveApply( split[ 1 ].trim() );
      else if( split[ 0 ] === 'cll' )
      result += `\x1b[K`;
    }
    else
    {
      output = output && !self.outputRaw && !self.outputGray;
    }

    let styling = !self.outputRaw;

    if( _.strIs( split ) )
    {
      if( styling )
      {
        if( self._resetStyle )
        {
          result += `\x1b[0;0m`
          self._resetStyle = false;
        }

        if( self.underline )
        result += `\x1b[4m`;
      }

      if( output )
      {
        self._diagnoseColorCheck();

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode_nodejs( self.foregroundColor ) }m`;

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode_nodejs( self.backgroundColor, true ) }m`;
      }

      result += split;

      if( styling )
      {
        if( self.underline )
        result += `\x1b[24m`;
      }

      if( output )
      {
        if( self.backgroundColor )
        result += `\x1b[49;0m`;
        if( self.foregroundColor )
        result += `\x1b[39;0m`;
      }
    }

  });

  o._outputForTerminal = [ result ];
  return o;
}

//

function _transformAct_browser( o )
{
  let self = this;
  let result = [ '' ];
  let splitted = o._outputSplitted;
  let styled = false;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.arrayIs( o._outputSplitted ) );
  _.assert( !o._outputForTerminal );

  splitted.forEach( function( split )
  {
    let output = !!_.color;

    if( _.arrayIs( split ) )
    {
      self._directiveApply( split );
      if( output && self.outputRaw )
      output = 0;
      if( output && self.outputGray && _.longHas( self.DirectiveColoring, split[ 0 ] ) )
      output = 0;

      if( !self.inputRaw && !self.outputRaw )
      if( split[ 0 ] === 'cls' )
      {
        if( _.routineIs( clear ) )
        clear();
      }
    }
    else
    {
      output = output && !self.outputRaw && !self.outputGray;
    }

    let styling = !self.outputRaw;

    if( _.strIs( split ) )
    {
      let foregroundColor = 'none';
      let backgroundColor = 'none';
      let textDecoration = 'none';

      let style = [];

      if( styling )
      {
        if( self._resetStyle )
        {
          self._resetStyle = false;
          styled = true;
        }

        if( self.underline )
        {
          textDecoration = 'underline';
          styled = true;
        }
      }

      /* qqq : make it working without _.color */

      if( output )
      {
        if( self.foregroundColor )
        {
          foregroundColor = _.color.colorToRgbaHtml( self.foregroundColor);
          styled = true;
        }

        if( self.backgroundColor )
        {
          backgroundColor = _.color.colorToRgbaHtml( self.backgroundColor);
          styled = true;
        }
      }

      if( styled )
      {
        result[ 0 ] += '%c';

        style.push( `color:${ foregroundColor }` );
        style.push( `background:${ backgroundColor }` )
        style.push( `text-decoration:${ textDecoration }` )

        result.push( style.join( ';' ) );
      }

      result[ 0 ] += split;
    }

  });

  o._outputForTerminal = result;
  return o;
}

//

function _transformActWithoutColors( o )
{
  let self = this;
  let result = '';
  let splitted = o._outputSplitted;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.arrayIs( o._outputSplitted ) );
  _.assert( !o._outputForTerminal );

  for( let i = 0 ; i < splitted.length ; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    result += splitted[ i ];
  }

  o._outputForTerminal = [ result ];
  return o;
}

//

function _transformColorApply( o )
{
  let self = this;

  _.assert( _.strIs( o.joinedInput ) );

  /* xxx */

  if( self.permanentStyle )
  {
    o.joinedInput = _.ct.formatFinal( o.joinedInput, self.permanentStyle );
  }

  if( self.coloringConnotation )
  {
    if( self.attributes.connotation === 'positive' )
    o.joinedInput = _.ct.formatFinal( o.joinedInput, 'positive' );
    else if( self.attributes.connotation === 'negative' )
    o.joinedInput = _.ct.formatFinal( o.joinedInput, 'negative' );
  }

  if( self.coloringHeadAndTail )
  if( self.attributes.head || self.attributes.tail )
  if( _.strStrip( o.joinedInput ) )
  {
    let reserve = self.verbosityReserve();
    if( self.attributes.head && reserve > 1 )
    o.joinedInput = _.ct.formatFinal( o.joinedInput, 'head' );
    else if( self.attributes.tail && reserve > 1 )
    o.joinedInput = _.ct.formatFinal( o.joinedInput, 'tail' );
  }

}

//

function _transformSplit( o )
{
  let self = this;
  let result = [ '' ];

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.joinedInput ) );
  _.assert( !o._outputSplitted );
  _.assert( !o._outputForTerminal );

  if( self.raw || self.rawAll )
  {
    o._outputSplitted = [ o.joinedInput ]; /* xxx */
    return;
  }

  let splits = o._outputSplitted = self._split( o.joinedInput );

  let inputRaw = self.inputRaw;
  let inputGray = self.inputGray;
  let outputRaw = self.outputRaw;
  let outputGray = self.outputGray;

  splits.forEach( ( split, i ) =>
  {

    if( !_.arrayIs( split ) )
    return;

    let directive = split[ 0 ];
    let value = split[ 1 ];
    let input = true;

    if( directive === 'inputRaw' )
    inputRaw += _.boolFrom( value.trim() ) ? +1 : -1;
    else if( inputRaw )
    input = false;
    else if( inputGray && _.longHas( self.DirectiveColoring, directive ) )
    input = false;

    if( !input )
    {
      split = '❮' + split[ 0 ] + ':' + split[ 1 ] + '❯';
      splits[ i ] = split;
      return;
    }

    if( directive === 'inputGray' )
    inputGray += _.boolFrom( value.trim() ) ? +1 : -1;
    if( directive === 'outputRaw' )
    outputRaw += _.boolFrom( value.trim() ) ? +1 : -1;
    if( directive === 'outputGray' )
    outputGray += _.boolFrom( value.trim() ) ? +1 : -1;

  });

}

//

/* qqq : implement please */
function TransformCssStylingToDirectives( input )
{
  //https://developers.google.com/web/tools/chrome-devtools/console/console-write#styling_console_output_with_css

  if( !_.strHas( input[ 0 ], '%c' ) )
  return input;

  let result = [ '' ];

  let splitted = _.strSplitFast
  ({
    src : input[ 0 ],
    delimeter : '%c',
    preservingEmpty : 0,
    preservingDelimeters : 0
  });

  splitted.forEach( ( chunk, i ) =>
  {
    let styles = input[ i + 1 ];

    if( styles )
    {
      let splits = _.strSplitFast
      ({
        src : styles,
        delimeter : [ ';', ':' ],
        preservingEmpty : 0,
        preservingDelimeters : 0
      });

      if( splits.length > 1 )
      for( let i = 0; i < splits.length; i += 2 )
      {
        let key = _.strStrip( splits[ i ] );
        let value = _.strStrip( splits[ i + 1 ] );

        if( value === 'none' )
        continue;

        if( key === 'color' )
        {
          value = _.color.rgbaHtmlFrom( value );
          value = _.color.colorNameNearest( value );
          chunk = _.color.strFg( chunk, value );
        }
        else if( key === 'background' )
        {
          value = _.color.rgbaHtmlFrom( value );
          value = _.color.colorNameNearest( value )
          chunk = _.color.strBg( chunk, value );
        }
        else if( key === 'text-decoration' )
        {
          chunk = `❮${value} : true❯${chunk}❮${value} : false❯`
        }
      }
    }

    result[ 0 ] += chunk;
  })

  if( !result[ 0 ] )
  return input;

  result.push( ... input.slice( splitted.length + 1 ) );

  return result;
}

// --
//
// --

function _join( splitted )
{
  let self = this;
  _.assert( _.arrayIs( splitted ) );

  let result = '';
  splitted.forEach( ( split, i ) =>
  {
    if( _.strIs( split ) )
    result += split
    else if( _.arrayIs( split ) )
    result += '❮' + split.join( ':' ) + '❯';
    else _.assert( 0 );
  });

  return result;
}

//

function _split( src )
{
  let self = this;
  _.assert( _.strIs( src ) );
  let splitted = _.ct.parse
  ({
    src,
    onInlined : self._splitHandle.bind( self ),
    // preservingEmpty : 0,
    // stripping : 0,
  });
  return splitted;
}

//

function _splitHandle( split )
{
  let self = this;
  let parts = split.split( ':' );
  if( parts.length === 2 )
  {
    parts[ 0 ] = parts[ 0 ].trim();
    if( !_.longHas( self.Directive, parts[ 0 ] ) )
    return;
    return parts;
  }
}

//

function _directiveApply( directive )
{
  let self = this;
  let handled = 0;
  let name = directive[ 0 ];
  let value = directive[ 1 ];

  if( name === 'inputRaw' )
  {
    self.inputRaw = _.boolFrom( value.trim() );
    return true;
  }

  if( self.inputRaw )
  return;

  if( !self.inputGray )
  {
    if( name === 'foreground' || name === 'fg' )
    {
      self.foregroundColor = value;
      return true;
    }
    else if( name === 'background' || name === 'bg' )
    {
      self.backgroundColor = value;
      return true;
    }
  }

  if( name === 'outputGray' )
  {
    self.outputGray = _.boolFrom( value.trim() );
    return true;
  }
  else if( name === 'inputGray' )
  {
    self.inputGray = _.boolFrom( value.trim() );
    return true;
  }
  else if( name === 'outputRaw' )
  {
    self.outputRaw = _.boolFrom( value.trim() );
    return true;
  }
  else if( name === 'underline' )
  {
    self.underline = _.boolFrom( value.trim() );
    return true;
  }
  else if( name === 'style' )
  {
    self.styleSet( value.trim() );
    return true;
  }

}

//

/*
move:eol
move:bol
move:bos
move:eos
move:pl
move:nl
move:pc
move:nc

b = begin
e = end
l = line
s = screen
c = char
p = prev
n = next

*/

function _directiveMoveApply( value )
{
  _.assert( Config.interpreter === 'njs' );

  let shellMoveDirectiveCodes =
  {
    eol,
    eos,
    'bol' : '0G',
    'bos' : '1;1H',
    'pl' : '1F',
    'nl' : '1E',
    'pc' : '1D',
    'nc' : '1C'
  }

  let code = shellMoveDirectiveCodes[ value ];

  _.assert( code !== undefined, 'Unknown value for directive move:', value );

  if( _.routineIs( code ) )
  code = code();

  /*
  for eos, eol returns empty string if program can't get sizes of the terminal
  */
  if( code.length )
  code = `\x1b[${code}`;

  return code;

  /* */

  function eol()
  {
    let result = '';

    if( process.stdout.columns )
    result = `${process.stdout.columns}G`;

    return result;
  };

  function eos()
  {
    let result = '';
    let stdo = process.stdout;

    if( !!stdo.rows && !!stdo.columns )
    result = `${stdo.rows};${stdo.columns}H`;

    return  result
  };

}

//

function _directiveClsApply( value )
{
  _.assert( Config.interpreter === 'njs' );

  let clsValuesMap =
  {
    '' : 2,
    'left' : 1,
    'right' : 0,
  }

  let cls = clsValuesMap[ value ];
  _.assert( cls !== undefined, 'Unknown value for directive "cls":', value );

  let code = `\x1b[${cls}J`;
  if( cls === 2 )
  code += `\x1b[H`;

  /*
  moves cursor to top left corner as terminal 'cls' does
  */

  return code;
}

//

function _transformAct( original )
{

  return function _transformAct( o )
  {
    let self = this;

    _.assert( _.mapIs( o ) );

    o = original.call( self, o );

    _.assert( _.strIs( o.joinedInput ) );
    _.assert( _.longIs( o.input ) );
    _.assert( o.output === null );
    _.assert( !!o.chainLink );
    _.assert( arguments.length === 1, 'Expects single argument' );

    if( !self.outputGray && _.color )
    self._transformColorApply( o );

    /* */

    if( !o.chainLink.outputPrinter.isPrinter )
    {

      if( !o._outputSplitted )
      self._transformSplit( o ); /* xxx */

      if( !o._outputForTerminal )
      {
        if( self.writingToHtml )
        self._transformActHtml( o );
        else if( Config.interpreter === 'njs' )
        self._transformAct_nodejs( o );
        else if( Config.interpreter === 'browser' )
        self._transformAct_browser( o );
      }

      _.assert( _.arrayIs( o._outputForTerminal ) );
      o.output = o._outputForTerminal;
    }
    else
    {
      o._outputForPrinter = [ o.joinedInput ];
      o.output = o._outputForPrinter;
      _.assert( _.arrayIs( o._outputForPrinter ) );
    }

    return o;
  }

}

//

function _rgbToCode_nodejs( rgb, isBackground )
{
  let name = _.color._colorNameNearest( rgb, _.color.ColorMapShell );
  let code = shellColorCodes[ name ];

  _.assert( _.numberIs( code ), 'nothing found for color: ', name );

  if( isBackground )
  code += 10; /* add 10 to convert fg code to bg code */

  return _.entity.exportString( code );
}

//

function _diagnoseColorCheck()
{
  let self = this;

  if( Config.interpreter === 'browser' )
  return;

  if( !self.foregroundColor || !self.backgroundColor )
  return;

  /* qqq : ??? */

  let stackFg = self._diagnosingColorsStack[ 'foreground' ];
  let stackBg = self._diagnosingColorsStack[ 'background' ];

  let fg = stackFg[ stackFg.length - 1 ];
  let bg = stackBg[ stackBg.length - 1 ];

  /* */

  let result = {};

  if( self.diagnosingColor )
  result.ill = self._diagnoseColorIll( fg, bg );

  if( self.diagnosingColorCollapse )
  result.collapse = self._diagnoseColorCollapse( fg, bg );

  return result;

}

//

function _diagnoseColorIll( fg, bg )
{
  let self = this;
  let ill = false;

  /* qqq : optimize */

  for( let i = 0; i < PoisonedColorCombination.length; i++ )
  {
    let combination = PoisonedColorCombination[ i ];
    if( combination.fg === fg.originalName && combination.bg === bg.originalName )
    {
      self.diagnosingColor = 0;
      ill = true;
      logger.styleSet( 'info.negative' );
      logger.warn( 'Warning!. Ill colors combination: ' );
      logger.warn( 'fg : ', fg.currentName, self.foregroundColor );
      logger.warn( 'bg : ', bg.currentName, self.backgroundColor );
      logger.warn( 'platform : ', combination.platform );
      logger.styleSet( 'default' );
    }
  }

  return ill;
}

//

function _diagnoseColorCollapse( fg, bg )
{
  let self = this;
  let collapse = false;

  if( _.long.identical( self.foregroundColor, self.backgroundColor ) )
  {
    if( fg.originalName !== bg.originalName )
    {
      let diff = _.color._colorDistance( fg.originalValue, bg.originalValue );
      if( diff <= 0.25 )
      collapse = true;
    }
  }

  if( collapse )
  {
    self.diagnosingColorCollapse = 0;
    logger.styleSet( 'info.negative' );
    logger.warn( 'Warning: Color collapse in native terminal.' );
    logger.warn( 'fg passed : ', fg.originalName, fg.originalValue );
    logger.warn( 'fg set : ', fg.currentName, self.foregroundColor );
    logger.warn( 'bg passed: ', bg.originalName, bg.originalValue );
    logger.warn( 'bg set : ', bg.currentName, self.backgroundColor );
    logger.styleSet( 'default' );
  }

  return collapse;
}

// --
// accessor
// --

function _foregroundColorGet()
{
  let self = this;
  return self[ symbolForForeground ];
}

//

function _backgroundColorGet()
{
  let self = this;
  return self[ symbolForBackground ];
}

//

function _foregroundColorSet( color )
{
  let self = this;
  let layer = 'foreground';

  self._colorSet( layer, color );
}

//

function _backgroundColorSet( color )
{
  let self = this;
  let layer = 'background';

  self._colorSet( layer, color );
}

//

function _colorSet( layer, color )
{
  let self = this;
  let symbol, diagnosticInfo;

  if( layer === 'foreground' )
  symbol = symbolForForeground;
  else if( layer === 'background' )
  symbol = symbolForBackground;
  else _.assert( 0, 'unexpected' );

  if( _.strIs( color ) )
  color = color.trim();

  if( !_.color )
  {
    self[ symbol ] = null;
    return;
  }

  _.assert( _.symbolIs( symbol ) );

  if( !_.color )
  {
    color = null;
  }

  /* */

  if( color && color !== 'default' )
  {
    let originalName = color;

    if( Config.interpreter === 'browser' ) /* xxx qqq : use field instead of Config.interpreter */
    {
      color = _.color.rgbaFromTry( color );
    }
    else
    {
      color = _.color.rgbaFromTry({ colorMap :  _.color.ColorMapShell, src : color, def : null });
      if( !color )
      color = _.color.rgbaFromTry( originalName );
    }

    if( !color )
    {
      debugger;
      throw _.err( `Can\'t set ${layer} color. Unknown color name: "${originalName}".` );
    }

    let originalValue = color;
    let currentName;

    if( color )
    {
      if( Config.interpreter === 'browser' )
      {
        color = _.color.rgbaFrom({ src : color, colorMap : _.color.ColorMap });
        currentName = _getColorName( _.color.ColorMap, color );
      }
      else
      {
        color = _.color.rgbaFrom({ src : color, colorMap :  _.color.ColorMapShell });
        currentName = _getColorName(  _.color.ColorMapShell, color );
      }

      diagnosticInfo =
      {
        originalValue,
        originalName,
        currentName,
        exact : !!_.color._colorDistance( color, originalValue )
      };

    }

  }

  /* */

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( layer ) )
    self[ symbol ] = self._stackPop( layer );
    else
    self[ symbol ] = null;

    if( self._diagnosingColorsStack  )
    self._diagnosingColorsStack[ layer ].pop();
  }
  else
  {
    if( self[ symbol ] )
    self._stackPush( layer, self[ symbol ] );

    self[ symbol ] = color;
    self._isStyled = 1;

    if( !self._diagnosingColorsStack  )
    self._diagnosingColorsStack = { 'foreground' : [], 'background' : [] };

    self._diagnosingColorsStack[ layer ].push( diagnosticInfo );
  }

  /* */

  function _getColorName( map, color )
  {
    let keys = _.props.onlyOwnKeys( map );
    for( let i = 0; i < keys.length; i++ )
    if( _.long.identical( map[ keys[ i ] ], color ) )
    return keys[ i ];

  }

}

//

function styleSet( src )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) || src === null );

  let special = [ 'default', 'reset' ];

  if( _.longHas( special, src ) )
  {
    if( src === 'reset' || self._stylesStack.length < 2 )
    {
      return self._styleReset();
    }
    else
    {
      self._stylesStack.pop();
      let style = self._stylesStack[ self._stylesStack.length - 1 ];
      return self._styleApply( style );
    }
  }

  let style = _.color.strColorStyle( src );

  _.assert( _.objectLike( style ), 'Unknown style:', src );

  let _style = _.props.extend( null, style );

  self._styleApply( _style );
  self._styleComplement( _style );

  self._stylesStack.push( _style );

}

//

function _styleApply( style )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectLike( style ) );

  if( style.fg )
  self.foregroundColor = style.fg;

  if( style.bg )
  self.backgroundColor = style.bg;

  if( style.underline )
  self.underline = style.underline;
}

//

function _styleComplement( style )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectLike( style ) );

  if( !style.fg )
  style.fg = self.foregroundColor;

  if( !style.bg )
  style.bg = self.backgroundColor;

  if( !style.underline )
  style.underline = self.underline;

}

//

function _styleReset()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self._resetStyle = true;

  self[ symbolForForeground ] = null;
  self[ symbolForBackground ] = null;
  self[ underlineSymbol ] = 0;
}

//

function _inputGraySet( src )
{
  let self = this;

  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.inputGray + ( src ? 1 : -1 );

  if( src < 0 )
  src = 0;

  self[ inputGraySymbol ] = src;

}

//

function _outputGraySet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.outputGray + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ outputGraySymbol ] = src;

}

//

function _inputRawSet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.inputRaw + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ inputRawSymbol ] = src;

}

//

function _outputRawSet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.outputRaw + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ outputRawSymbol ] = src;

}

//

function _underlineSet( src )
{
  let self = this;
  _.assert( _.boolLike( src ) );

  if( _.boolIs( src ) )
  src = self.underline + ( src ? 1 : -1 );

  if( src < 0 )
  debugger;

  if( src < 0 )
  src = 0;

  self[ underlineSymbol ] = src;

}

function _clsSet( src )
{
  let self = this;

  _.assert( src !== undefined );

  let clsValuesMap =
  {
    '' : 2,
    'left' : 1,
    'right' : 0,
    'null' : null
  }

  let value = clsValuesMap[ src ];
  _.assert( value !== undefined, 'Unknown value for directive "cls":', src );
  self[ clsSymbol ] = value;

}

// --
// string formatters
// --

function colorFormat( src, format )
{
  let self = this;
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( self.outputGray || !_.color || !_.ct.formatFinal )
  return src;
  return _.ct.formatFinal( src, format );
}

//

function colorBg( src, format )
{
  let self = this;
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( self.outputGray || !_.color || !_.ct.bg )
  return src;
  return _.ct.bg( src, format );
}

//

function colorFg( src, format )
{
  let self = this;
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( self.outputGray || !_.color || !_.ct.fg )
  return src;
  return _.ct.fg( src, format );
}

//

function escape( src )
{
  let self = this;
  _.assert( arguments.length === 1 );
  if( /*self.outputGray ||*/ !_.color || !_.ct.fg )
  return src;
  return _.ct.escape( src );
}

//

function str()
{
  debugger;
  return _.entity.exportStringDiagnosticShallow/*exportStringSimple*/.apply( _, arguments );
}

// --
// topic
// --

function topic()
{
  let self = this;

  let result = _.strConcat( arguments );

  if( !self.outputGray )
  result = _.ct.formatFinal( result, 'topic.up' );

  this.log();
  this.log( result );

  return result;
}

//

function topicUp()
{
  let self = this;

  let result = _.strConcat( arguments );

  if( !self.outputGray )
  result = _.ct.formatFinal( result, 'topic.up' );

  this.log();
  this.logUp( result );

  return result;
}

//

function topicDown()
{
  let self = this;

  let result = _.strConcat( arguments );

  if( !self.outputGray )
  result = _.ct.formatFinal( result, 'topic.down' );

  this.log();
  this.logDown( result );
  this.log();

  return result;
}

// --
// fields
// --

let levelSymbol = Symbol.for( 'level' );
let symbolForForeground = Symbol.for( 'foregroundColor' );
let symbolForBackground = Symbol.for( 'backgroundColor' );

let inputGraySymbol = Symbol.for( 'inputGray' );
let outputGraySymbol = Symbol.for( 'outputGray' );
let inputRawSymbol = Symbol.for( 'inputRaw' );
let outputRawSymbol = Symbol.for( 'outputRaw' );
let underlineSymbol = Symbol.for( 'underline' );

let shellColorCodes =
{
  'black'           : 30,
  'dark red'        : 31,
  'dark green'      : 32,
  'dark yellow'     : 33,
  'dark blue'       : 34,
  'dark magenta'    : 35,
  'dark cyan'       : 36,
  'dark white'      : 37,

  'bright black'    : 90,
  'red'             : 91,
  'green'           : 92,
  'yellow'          : 93,
  'blue'            : 94,
  'magenta'         : 95,
  'cyan'            : 96,
  'white'           : 97
}

/* let shellColorCodesUnix =
{
  'white'           : 37,
  'bright white'     : 97,
} */

let PoisonedColorCombination =
[

  { fg : 'white', bg : 'yellow', platform : 'win32' },
  { fg : 'green', bg : 'cyan', platform : 'win32' },
  { fg : 'red', bg : 'magenta', platform : 'win32' },
  { fg : 'yellow', bg : 'white', platform : 'win32' },
  { fg : 'cyan', bg : 'green', platform : 'win32' },
  { fg : 'cyan', bg : 'yellow', platform : 'win32' },
  { fg : 'magenta', bg : 'red', platform : 'win32' },
  { fg : 'bright black', bg : 'magenta', platform : 'win32' },
  { fg : 'dark yellow', bg : 'magenta', platform : 'win32' },
  { fg : 'dark blue', bg : 'blue', platform : 'win32' },
  { fg : 'dark cyan', bg : 'magenta', platform : 'win32' },
  { fg : 'dark green', bg : 'magenta', platform : 'win32' },
  { fg : 'dark white', bg : 'green', platform : 'win32' },
  { fg : 'dark white', bg : 'cyan', platform : 'win32' },
  { fg : 'green', bg : 'dark white', platform : 'win32' },
  { fg : 'blue', bg : 'dark blue', platform : 'win32' },
  { fg : 'cyan', bg : 'dark white', platform : 'win32' },
  { fg : 'bright black', bg : 'dark yellow', platform : 'win32' },
  { fg : 'bright black', bg : 'dark cyan', platform : 'win32' },
  { fg : 'dark yellow', bg : 'bright black', platform : 'win32' },
  { fg : 'dark yellow', bg : 'dark cyan', platform : 'win32' },
  { fg : 'dark red', bg : 'dark magenta', platform : 'win32' },
  { fg : 'dark magenta', bg : 'dark red', platform : 'win32' },
  { fg : 'dark cyan', bg : 'bright black', platform : 'win32' },
  { fg : 'dark cyan', bg : 'dark yellow', platform : 'win32' },
  { fg : 'dark cyan', bg : 'dark green', platform : 'win32' },
  { fg : 'dark green', bg : 'dark cyan', platform : 'win32' },

  /* */

  // { fg : 'white', bg : 'bright yellow', platform : 'darwin' }, /* qqq : check the color */
  { fg : 'green', bg : 'cyan', platform : 'darwin' },
  { fg : 'yellow', bg : 'cyan', platform : 'darwin' },
  { fg : 'blue', bg : 'bright blue', platform : 'darwin' },
  { fg : 'blue', bg : 'black', platform : 'darwin' },
  { fg : 'cyan', bg : 'yellow', platform : 'darwin' },
  { fg : 'cyan', bg : 'green', platform : 'darwin' },
  // { fg : 'bright yellow', bg : 'white', platform : 'darwin' },
  { fg : 'bright red', bg : 'bright magenta', platform : 'darwin' },
  { fg : 'bright magenta', bg : 'bright red', platform : 'darwin' },

  { fg : 'bright blue', bg : 'blue', platform : 'darwin' },
  // { fg : 'bright white', bg : 'bright cyan', platform : 'darwin' },
  { fg : 'bright green', bg : 'bright cyan', platform : 'darwin' },
  { fg : 'bright cyan', bg : 'bright green', platform : 'darwin' },

  /* */

  /* qqq : bright black? */

  { fg : 'white', bg : 'yellow', platform : 'linux' },
  { fg : 'green', bg : 'cyan', platform : 'linux' },
  { fg : 'yellow', bg : 'white', platform : 'linux' },
  { fg : 'blue', bg : 'magenta', platform : 'linux' },
  { fg : 'cyan', bg : 'green', platform : 'linux' },
  { fg : 'magenta', bg : 'blue', platform : 'linux' },
  { fg : 'dark yellow', bg : 'blue', platform : 'linux' },
  { fg : 'dark yellow', bg : 'magenta', platform : 'linux' },
  { fg : 'dark cyan', bg : 'blue', platform : 'linux' },
  { fg : 'dark green', bg : 'blue', platform : 'linux' },
  { fg : 'dark green', bg : 'magenta', platform : 'linux' },
  { fg : 'dark white', bg : 'green', platform : 'linux' },
  { fg : 'dark white', bg : 'yellow', platform : 'linux' },
  { fg : 'dark white', bg : 'cyan', platform : 'linux' },
  { fg : 'white', bg : 'dark white', platform : 'linux' },
  { fg : 'green', bg : 'dark white', platform : 'linux' },
  { fg : 'yellow', bg : 'dark white', platform : 'linux' },
  { fg : 'blue', bg : 'dark yellow', platform : 'linux' },
  { fg : 'blue', bg : 'dark cyan', platform : 'linux' },
  { fg : 'cyan', bg : 'dark white', platform : 'linux' },
  { fg : 'magenta', bg : 'dark yellow', platform : 'linux' },
  { fg : 'magenta', bg : 'dark cyan', platform : 'linux' },
  { fg : 'magenta', bg : 'dark green', platform : 'linux' },
  { fg : 'bright black', bg : 'dark magenta', platform : 'linux' },
  { fg : 'bright black', bg : 'dark blue', platform : 'linux' },
  { fg : 'dark magenta', bg : 'bright black', platform : 'linux' },
  { fg : 'dark magenta', bg : 'dark blue', platform : 'linux' },
  { fg : 'dark blue', bg : 'bright black', platform : 'linux' },
  { fg : 'dark blue', bg : 'dark magenta', platform : 'linux' },
  { fg : 'dark cyan', bg : 'dark green', platform : 'linux' },
  { fg : 'dark green', bg : 'dark cyan', platform : 'linux' },


]

let Directive = [ 'bg', 'background', 'fg', 'foreground', 'outputGray', 'inputGray', 'inputRaw', 'outputRaw', 'underline', 'cls', 'style', 'move', 'cll' ];
let DirectiveColoring = [ 'bg', 'background', 'fg', 'foreground' ];

// --
// relations
// --

let Composes =
{

  foregroundColor : null,
  backgroundColor : null,
  permanentStyle : null,

  coloringHeadAndTail : 1,
  coloringConnotation : 1,
  writingToHtml : 0,

  raw : 0,
  inputGray : 0,
  outputGray : 0,
  inputRaw : 0,
  outputRaw : 0,
  underline : 0,

}

let Aggregates =
{

}

let Associates =
{

}

let Restricts =
{

  _colorsStack : null,
  _diagnosingColorsStack : null, /* qqq : what for??? */
  _stylesStack : _.define.own( [] ),
  _resetStyle : 0,
  _isStyled : 0,
  _cursorSaved : 0,

}

let Statics =
{
  rawAll : 0,
  diagnosingColor : 1, /* xxx */
  diagnosingColorCollapse : 1,
  PoisonedColorCombination,
  Directive,
  DirectiveColoring,
  TransformCssStylingToDirectives
}

let Forbids =
{
  coloring : 'coloring',
  outputColoring : 'outputColoring',
  inputColoring : 'inputColoring',
}

let Accessors =
{

  foregroundColor : 'foregroundColor',
  backgroundColor : 'backgroundColor',

  inputGray : 'inputGray',
  outputGray : 'outputGray',
  inputRaw : 'inputRaw',
  outputRaw : 'outputRaw',
  underline : 'underline',

}

// --
// declare
// --

let Functors =
{

  _transformAct,

}

let Extension =
{

  // stack

  _stackPush,
  _stackPop,
  _stackIsNotEmpty,

  // transform

  _transformActHtml,
  _transformAct_nodejs,
  _transformAct_browser,
  _transformActWithoutColors,
  _transformColorApply,
  _transformSplit,

  //

  _join,
  _split,
  _splitHandle,
  _directiveApply,
  _directiveMoveApply,
  _directiveClsApply,

  _rgbToCode_nodejs,
  _diagnoseColorCheck,
  _diagnoseColorIll,
  _diagnoseColorCollapse,

  // accessor

  _foregroundColorGet,
  _backgroundColorGet,
  _foregroundColorSet,
  _backgroundColorSet,
  _colorSet,
  _underlineSet,

  styleSet,
  _styleApply,
  _styleComplement,
  _styleReset,

  _inputGraySet,
  _outputGraySet,
  _inputRawSet,
  _outputRawSet,

  // string formatters

  colorFormat,
  colorBg,
  colorFg,
  escape,
  str,

  // topic

  topic,
  topicUp,
  topicDown,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  extend : Extension,
  functors : Functors,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
