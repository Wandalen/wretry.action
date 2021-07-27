(function _Chainer_s_()
{

'use strict';

/**
 * @classdesc Encapsulates chainability of printers, loggers and consoles. Use it to construct a chain.
   @class wChainer
   @namespace Tools
   @module Tools/base/Logger
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wChainer;
function wChainer( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Chainer';

// --
// inter
// --

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  return self;
}

//

function finit()
{
  let self = this;
  self.unchainEverything();
  _.Copyable.prototype.finit.call( self );
}

//

function _chain( o )
{
  let self = this;
  let result = 1;

  o = _.routine.options_( self._chain, arguments );

  if( self._chainDescriptorLike( o.outputPrinter ) )
  o.outputPrinter = o.outputPrinter.outputPrinter;
  if( self._chainDescriptorLike( o.inputPrinter ) )
  o.inputPrinter = o.inputPrinter.inputPrinter;

  _.assert( arguments.length === 1 );
  _.assert( _.printerLike( o.outputPrinter ) || _.argumentsArray.like( o.outputPrinter ) || _.streamIs( o.outputPrinter ) );
  _.assert( _.printerLike( o.inputPrinter ) || _.argumentsArray.like( o.inputPrinter ) || _.streamIs( o.inputPrinter ) );
  _.assert( _.longHas( _.PrinterChainingMixin.Combining, o.outputCombining ), () => 'unknown outputCombining mode ' + _.strQuote( o.outputCombining ) );
  _.assert( _.longHas( _.PrinterChainingMixin.Combining, o.inputCombining ), () => 'unknown inputCombining mode ' + _.strQuote( o.inputCombining ) );

  /* */

  if( _.printerLike( o.inputPrinter ) && o.inputPrinter[ chainerSymbol ] )
  if( o.inputPrinter[ chainerSymbol ].outputs && o.inputPrinter[ chainerSymbol ].outputs.length )
  {
    if( o.inputCombining === 'supplement' )
    {
      result = 0;
      return result;
    }
    else if( o.inputCombining === 'rewrite' )
    {
      o.inputPrinter[ chainerSymbol ].outputUnchain();
    }
  }

  /* */

  if( _.printerLike( o.outputPrinter ) && o.outputPrinter[ chainerSymbol ] )
  if( o.outputPrinter[ chainerSymbol ].inputs && o.outputPrinter[ chainerSymbol ].inputs.length )
  {
    if( o.outputCombining === 'supplement' )
    {
      result = 0;
      return result;
    }
    else if( o.outputCombining === 'rewrite' )
    {
      o.outputPrinter[ chainerSymbol ].inputUnchain();
    }
  }

  /* */

  if( _.argumentsArray.like( o.outputPrinter ) )
  {
    result = 0;

    o.outputPrinter.forEach( ( outputPrinter ) =>
    {
      let o2 = _.props.extend( null, o );
      o2.outputPrinter = outputPrinter;

      if( self._chainDescriptorLike( outputPrinter ) )
      {
        o2.originalOutput = outputPrinter.originalOutput;
        o2.exclusiveOutput = outputPrinter.exclusiveOutput;
      }

      result += self._chain( o2 );
    });

    return result;
  }

  /* */

  if( _.argumentsArray.like( o.inputPrinter ) )
  {
    result = 0;

    o.inputPrinter.forEach( ( inputPrinter ) =>
    {
      let o2 = _.props.extend( null, o );
      o2.inputPrinter = inputPrinter;

      if( self._chainDescriptorLike( inputPrinter ) )
      {
        o2.originalOutput = inputPrinter.originalOutput;
        o2.exclusiveOutput = inputPrinter.exclusiveOutput;
      }

      result += self._chain( o2 );
    });

    return result;
  }

  /* */

  _.assert( !!o.outputPrinter, 'Expects {-o.outputPrinter-}' );
  _.assert( o.inputPrinter !== o.outputPrinter, 'Output to itself is not correct chaining' );

  let cd = self._chainDescriptorMake( o );

  let inputChainer = cd.inputPrinter[ chainerSymbol ] || self.MakeFor( cd.inputPrinter );
  let outputChainer = cd.outputPrinter[ chainerSymbol ] || self.MakeFor( cd.outputPrinter );

  /* output check */

  if( Config.debug )
  if( inputChainer.hasOutputClose( o.outputPrinter ) )
  _.assert( 0, () => _.strConcat([ 'inputPrinter', _.entity.exportStringDiagnosticShallow( o.inputPrinter ), o.inputPrinter.name, 'already has outputPrinter', _.entity.exportStringDiagnosticShallow( o.outputPrinter ), 'in outputs' ] ) );

  /* input check */

  if( Config.debug )
  if( !o.originalOutput )
  if( inputChainer.hasInputClose( o.outputPrinter ) )
  _.assert( 0, () => _.strConcat([ 'Close loop, inputPrinter', _.entity.exportStringDiagnosticShallow( o.inputPrinter ), 'to outputPrinter', _.entity.exportStringDiagnosticShallow( o.outputPrinter ) ]) );

  /*
    no need to check inputs if chaining is originalOutput
  */

  if( Config.debug )
  if( !o.originalOutput )
  if( inputChainer.hasInputDeep( o.outputPrinter ) )
  _.assert( 0, () => _.strConcat([ 'Deep loop, inputPrinter', _.entity.exportStringDiagnosticShallow( o.inputPrinter ), 'to outputPrinter', _.entity.exportStringDiagnosticShallow( o.outputPrinter ) ]) );

  if( cd.outputCombining === 'prepend' )
  {
    _.arrayPrependOnceStrictly( outputChainer.inputs, cd );
  }
  else
  {
    _.arrayAppendOnceStrictly( outputChainer.inputs, cd );
  }

  if( cd.inputCombining === 'prepend' )
  {
    _.arrayPrependOnceStrictly( inputChainer.outputs, cd );
  }
  else
  {
    _.arrayAppendOnceStrictly( inputChainer.outputs, cd );
  }

  /**/

  if( _.streamIs( cd.outputPrinter ) )
  {
    inputChainer._outputToStream( cd );
  }
  else if( _.consoleIs( cd.outputPrinter ) )
  {
    inputChainer._outputToConsole( cd );
  }

  if( _.streamIs( cd.inputPrinter ) )
  {
    outputChainer._inputFromStream( cd );
  }
  else if( _.consoleIs( cd.inputPrinter ) )
  {
    outputChainer._inputFromConsole( cd );
  }

  /* */

  if( cd.originalOutput )
  {
    outputChainer.hasOriginalOutputs = +1;
  }

  if( cd.exclusiveOutput )
  {
    _.assert( !inputChainer.exclusiveOutputPrinter, 'console is already excluded by printer', _.entity.exportStringDiagnosticShallow( inputChainer.exclusiveOutputPrinter ) );
    inputChainer.exclusiveOutputPrinter = o.outputPrinter;
  }

  return result;
}

_chain.defaults =
{
  outputPrinter : null,
  inputPrinter : null,
  outputCombining : 'append',
  inputCombining : 'append',
  originalOutput : 0,
  exclusiveOutput : 0,
}

//

function _inputFromConsole( cd )
{
  let self = this;
  let inputChainer = cd.inputPrinter[ chainerSymbol ];

  _.assert( arguments.length === 1 );
  _.assert( _.consoleIs( cd.inputPrinter ) );
  _.assert( cd.inputPrinter.outputs === undefined );
  _.assert( !cd.inputPrinter.isPrinter );
  _.assert( !!inputChainer );

  self.Channel.forEach( ( channel, c ) =>
  {
    _.assert( _.routineIs( inputChainer.readFromMap[ channel ] ) );
    cd.inputPrinter[ channel ] = inputChainer.readFromMap[ channel ];
  });

}

//

function _outputToConsole( cd )
{
  let self = this;
  let outputChainer = cd.outputPrinter[ chainerSymbol ];

  _.assert( arguments.length === 1 );
  _.assert( _.consoleIs( cd.outputPrinter ) );
  _.assert( cd.outputPrinter.outputs === undefined );
  _.assert( !cd.outputPrinter.isPrinter );
  _.assert( _.object.isBasic( outputChainer ) );

  cd.write = Object.create( null );

  self.Channel.forEach( ( channel, c ) =>
  {
    cd.write[ channel ] = outputChainer.readFromMap[ channel ];
  });

}

//

function _outputToStream( cd )
{
  let self = this;
  let stream = cd.outputPrinter;

  _.assert( stream.writable && _.routineIs( stream._write ) && _.object.isBasic( stream._writableState ), 'Provided stream is not writable!.' );
  _.assert( cd.write === null );

  cd.write = Object.create( null );

  self.Channel.forEach( ( channel, c ) =>
  {
    cd.write[ channel ] = function()
    {
      stream.write.apply( stream, arguments );
    }
  });

}

//

function _inputFromStream( cd )
{
  let self = this;
  let outputChannel = 'log';
  let stream = cd.inputPrinter;
  let outputPrinter = cd.outputPrinter;

  _.assert( stream.readable && _.routineIs( stream._read ) && _.object.isBasic( stream._readableState ), 'Provided stream is not readable!.' );
  _.assert( !cd.onDataHandler );

  cd.onDataHandler = onDataHandler;
  stream.on( 'data', cd.onDataHandler );

  function onDataHandler( data )
  {
    if( _.bufferAnyIs( data ) )
    data = _.bufferToStr( data );

    // if( _.strEnds( data, '\n' ) )
    // data = _.strRemoveEnd( data, '\n' );

    outputPrinter._writeAct( outputChannel, [ data ] );
    // outputPrinter[ outputChannel ].call( outputPrinter, data );
  }

}

//

/**
 * Adds new logger( output ) to output list.
 *
 * Each message from current logger will be transfered
 * to each logger from that list. Supports several combining modes: 0, rewrite, supplement, append, prepend.
 * If output already exists in the list and combining mode is not 'rewrite'.
 * @returns True if new output is succesfully added, otherwise return false if output already exists and combining mode is not 'rewrite'
 * or if list is not empty and combining mode is 'supplement'.
 *
 * @param { Object } output - Logger that must be added to list.
 * @param { Object } o - Options.
 * @param { Object } [ o.leveling=null ] - Controls logger leveling mode: 0, false or '' - logger uses it own leveling methods,
 * 'delta' -  chains together logger and output leveling methods.
 * @param { Object } [ o.combining=null ] - Mode which controls how new output appears in list:
 *  0, false or '' - combining is disabled;
 * 'rewrite' - clears list before adding new output;
 * 'append' - adds output to the end of list;
 * 'prepend' - adds output at the beginning;
 * 'supplement' - adds output if list is empty.
 *
 * @example
 * let l = new _.Logger({ output : console });
 * l.outputTo( logger, { combining : 'rewrite' } ); //returns true
 * logger._prefix = '--';
 * l.log( 'abc' );//logger prints '--abc'
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * let l2 = new _.Logger({ output : console });
 * l1.outputTo( logger, { combining : 'rewrite' } );
 * l2.outputTo( l1, { combining : 'rewrite' } );
 * logger._prefix = '*';
 * logger._postfix = '*';
 * l2.log( 'msg from l2' );//logger prints '*msg from l2*'
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * let l2 = new _.Logger({ output : console });
 * let l3 = new _.Logger({ output : console });
 * logger.outputTo( l1, { combining : 'rewrite' } );
 * logger.outputTo( l2, { combining : 'append' } );
 * logger.outputTo( l3, { combining : 'append' } );
 * l1._prefix = '*';
 * l2._prefix = '**';
 * l3._prefix = '***';
 * logger.log( 'msg from logger' );
 * //l1 prints '*msg from logger'
 * //l2 prints '**msg from logger'
 * //l3 prints '***msg from logger'
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * l.outputTo( logger, { combining : 'rewrite', leveling : 'delta' } );
 * logger.up( 2 );
 * l.up( 1 );
 * logger.log( 'aa\nb' );
 * l.log( 'c\nd' );
 * //logger prints
 * // ---aa
 * // ---b
 * // ----c
 * // -----d
 *
 * @method outputTo
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( output ) is not a Object or null.
 * @throws { Exception } If specified combining mode is not allowed.
 * @throws { Exception } If specified leveling mode is not allowed.
 * @throws { Exception } If combining mode is disabled and output list has multiple elements.
 * @class wChainer
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

function outputTo( output, o )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options_( self.outputTo, o || null );

  let o2 = _.props.extend( null, o );
  o2.inputPrinter = self.printer;
  o2.outputPrinter = output;
  o2.inputCombining = o.combining;
  delete o2.combining;

  return Self._chain( o2 );
}

outputTo.defaults =
{
  combining : 'append',
  originalOutput : 0,
}

//

/**
 * Adds current logger( self ) to output list of logger( input ).
 *
 * Logger( self ) will take each message from source( input ).
 * If( input ) is not a Logger, write methods in( input ) will be replaced with methods from current logger( self ).
 * @returns True if logger( self ) is succesfully added to source( input ) output list, otherwise returns false.
 *
 * @param { Object } input - Object that will be input for current logger.
 * @param { Object } o  - Options.
 * @param { String } [ o.combining='rewrite' ] - Specifies combining mode for outputTo method @see {@link wTools.outputTo}.
 * By default rewrites output list of( input ) object if it exists.
 *
 * @example
 * logger.inputFrom( console );
 * logger._prefix = '*';
 * console.log( 'msg for logger' ); //logger prints '*msg for logger'
 *
 * @example
 * let l = new _.Logger({ output : console });
 * logger.inputFrom( l );
 * logger._prefix = '*';
 * l.log( 'msg from logger' ); //logger prints '*msg from logger'
 *
 * @method inputFrom
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( input ) is not a Object.
 * @class wChainer
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

function inputFrom( input, o )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options_( self.outputTo, o || null );

  let o2 = _.props.extend( null, o );
  o2.inputPrinter = input;
  o2.outputPrinter = self.printer;
  o2.outputCombining = o.combining;
  delete o2.combining;

  return Self._chain( o2 );
}

var defaults = inputFrom.defaults = Object.create( null );

defaults.combining = 'append';
defaults.exclusiveOutput = 0;

//

function inputsUnchainAll()
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.inputs.forEach( ( input ) =>
  {
    result += self.inputUnchain( input.inputPrinter );
  });

  return result;
}

//

function outputsUnchainAll()
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.inputs.forEach( ( input ) =>
  {
    result += self.outputUnchain( input.inputPrinter );
  });

  return result;
}

//

function _unchain( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.printerLike( o.outputPrinter ) || _.streamIs( o.outputPrinter ) );
  _.assert( _.printerLike( o.inputPrinter ) || _.streamIs( o.inputPrinter ) );
  _.assert( o.inputPrinter !== o.outputPrinter );

  let inputChainer = o.inputPrinter[ chainerSymbol ];
  let outputChainer = o.outputPrinter[ chainerSymbol ];

  let cd1 = _.arrayRemovedElementOnceStrictly( inputChainer.outputs, o.outputPrinter, ( cd ) => cd.outputPrinter, ( e ) => e );
  let cd2 = _.arrayRemovedElementOnceStrictly( outputChainer.inputs, o.inputPrinter, ( cd ) => cd.inputPrinter, ( e ) => e );

  _.assert( cd1 === cd2 );

  if( _.streamIs( o.inputPrinter ) )
  {
    _.assert( _.routineIs( cd1.onDataHandler ) );
    o.inputPrinter.removeListener( 'data', cd1.onDataHandler );
    _.assert( o.inputPrinter.listeners( 'data' ).indexOf( cd1.onDataHandler ) === -1 );
  }

  if( _.consoleIs( o.inputPrinter ) && !inputChainer.outputs.length )
  self._restoreOriginalWriteConsole( inputChainer );

  self._chainDescriptorFree( cd1 );

  if( cd1.exclusiveOutput )
  {
    _.assert( inputChainer.exclusiveOutputPrinter === o.outputPrinter )
    inputChainer.exclusiveOutputPrinter = null;
  }

  if( cd1.originalOutput )
  {
    outputChainer.hasOriginalOutputs -= 1;
    _.assert( outputChainer.hasOriginalOutputs >= 0 );
  }

  return 1;
}

_unchain.defaults =
{
  inputPrinter : null,
  outputPrinter : null,
}

//

function outputUnchain( output )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.printerLike( output ) || _.streamIs( output ) || output === undefined );

  if( output === undefined )
  {
    let result = 0;
    for( let i = self.outputs.length - 1; i >= 0; i-- )
    {
      result += self.outputUnchain( self.outputs[ i ].outputPrinter );
    }

    return result;
  }

  return self._unchain({ inputPrinter : self.printer, outputPrinter : output });
}

//

/**
 * Removes current logger( self ) from output list of logger( input ).
 *
 * Logger( self ) will not be receiving any messages from source( input ).
 * If( input ) is not a Logger, restores it original write methods.
 * @returns True if logger( self ) is succesfully removed from source( input ) output list, otherwise returns false.
 *
 * @param { Object } input - Object that will not be longer an input for current logger( self ).
 *
 * @example
 * logger.inputUnchain( console );
 * logger._prefix = '*';
 * console.log( 'msg for logger' ); //console prints 'msg for logger'
 *
 * @example
 * let l = new _.Logger({ output : console });
 * logger.inputFrom( l, { combining : 'append' } );
 * logger._prefix = '*';
 * l.log( 'msg for logger' ) //logger prints '*msg for logger'
 * logger.inputUnchain( l );
 * l.log( 'msg for logger' ) //l prints 'msg for logger'
 *
 * @method inputUnchain
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( input ) is not a Object.
 * @class wChainer
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

function inputUnchain( input )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.printerLike( input ) || _.streamIs( input ) || input === undefined );

  if( input === undefined )
  {
    let result = 0;
    for( let i = self.inputs.length - 1; i >= 0; i-- )
    {
      result += self.inputUnchain( self.inputs[ i ].inputPrinter );
    }
    return result;
  }

  return self._unchain({ inputPrinter : input, outputPrinter : self.printer });
}

inputUnchain.defaults =
{
  inputPrinter : null,
  outputPrinter : null,
}

//

function unchainEverything()
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  result += self.outputUnchain();
  result += self.inputUnchain();

  return result;
}

//

function _restoreOriginalWriteConsole( chainer )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.object.isBasic( chainer ) );
  _.assert( _.consoleIs( chainer.printer ) );
  _.assert( !chainer.outputs.length > 0, 'Can\'t restore original write methods when console has outputs' );

  self.Channel.forEach( ( channel, c ) =>
  {
    _.assert( _.routineIs( chainer.originalWriteMap[ channel ] ) );
    chainer.printer[ channel ] = chainer.originalWriteMap[ channel ];
  });

}


// --
//
// --

function _chainDescriptorMake( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  let r = new ChainDescriptor();

  let options = _.mapOnly_( null, o, self.ChainDescriptorFields );

  Object.assign( r, self.ChainDescriptorFields );

  /* !!! : remove it later */
  _.accessor.forbid
  ({
    object : o,
    names :
    {
      input : 'input',
      output : 'output',
    }
  });

  Object.preventExtensions( r );
  Object.assign( r, options );
  return r;
}

//

function _chainDescriptorFree( cd )
{
  _.assert( arguments.length === 1 );
  cd.freed = 1;
  Object.freeze( cd );
}

//

function Get( printable )
{
  _.assert( arguments.length === 1 );
  return printable[ chainerSymbol ];
}

//

function MakeFor( printer )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.printerLike( printer ) || _.streamIs( printer ) );
  _.assert( !printer[ chainerSymbol ] );

  let chainer = new Self();
  chainer.printer = printer;
  printer[ chainerSymbol ] = chainer; /* qqq xxx : instead of writing the field use HashMap */

  if( _.streamIs( printer ) )
  return chainer;

  self.Channel.forEach( ( channel, c ) =>
  {
    _.assert( _.routineIs( printer[ channel ] ), () => 'Console should have method ' + _.strQuote( channel ) );

    if( _.consoleIs( printer ) )
    {
      chainer.originalWriteMap[ channel ] = printer[ channel ];
    }
    else chainer.originalWriteMap[ channel ] = function writeToChannelWithoutExclusion()
    {
      debugger;
      return this._writeToChannelWithoutExclusion( channel, arguments );
    }

    if( _.consoleIs( printer ) )
    chainer.readFromMap[ channel ] = _.routineJoin( undefined, self._printerReadFromConsole, [ channel, printer ] );
    else
    chainer.readFromMap[ channel ] = _.routineJoin( undefined, self._printerReadFromPrinter, [ channel ] );

  });

  return chainer;
}

//

function _printerReadFromConsole( channel, defaultConsole )
{
  let result;
  let console = this || defaultConsole;

  _.assert( !!console, `Expects context` );

  let chainer = console[ chainerSymbol ];
  let cds = chainer.outputs;
  let args = _.longSlice( arguments, 2 );

  _.assert( _.arrayIs( cds ) );
  _.assert( _.routineIs( chainer.originalWriteMap[ channel ] ) );

  if( chainer.exclusiveOutputPrinter )
  {
    result = chainer.exclusiveOutputPrinter[ channel ].apply( chainer.exclusiveOutputPrinter, args );
    return result;
  }
  else
  {
    cds.forEach( ( cd ) =>
    {
      _.assert( cd.inputPrinter === console );
      if( !chainer.exclusiveOutputPrinter || cd.originalOutput )
      cd.outputPrinter[ channel ].apply( cd.outputPrinter, args );
    });
    return chainer.originalWriteMap[ channel ].apply( console, args );
  }

}

//

function _printerReadFromPrinter( channel )
{
  let result;
  let self = this;
  let chainer = this[ chainerSymbol ];
  let cds = chainer.outputs;
  let args = _.longSlice( arguments, 1 );

  _.assert( 0, 'not tested' );
  /* xxx */

  _.assert( _.arrayIs( cds ) );
  _.assert( _.routineIs( chainer.originalWriteMap[ channel ] ) );

  if( chainer.exclusiveOutputPrinter )
  {
    result = chainer.exclusiveOutputPrinter[ channel ].apply( chainer.exclusiveOutputPrinter, arguments );
  }

  if( chainer.exclusiveOutputPrinter )
  return result;
  else
  return chainer.originalWriteMap[ channel ].apply( self, arguments );

}

// --
//
// --

function _nameGet()
{
  let self = this;
  return self.printer.name;
}

//

function _nameSet( src )
{
  let self = this;

  if( src === null )
  return;

  if( !self.printer )
  return;

  self.printer.name = src
}

// --
// dichotomy
// --

function _hasInput( input, o )
{
  let self = this;

  o = _.routine.options_( _hasInput, o || null );
  _.assert( _.mapIs( o ) );
  _.assert( _.printerLike( input ) || _.processIs( input ) || _.streamIs( input ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  // _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  // _.assert( _.mapIs( o ) );
  // _.assert( _.printerLike( input ) || _.processIs( input ) || _.streamIs( input ) );
  // _.routine.options_( _hasInput, o );

  for( let d = 0 ; d < self.inputs.length ; d++ )
  {
    if( self.inputs[ d ].inputPrinter === input )
    {
      if( o.withoutOutputToOriginal && self.inputs[ d ].originalOutput )
      continue;
      return true;
    }
  }

  if( o.deep )
  for( let d = 0 ; d < self.inputs.length ; d++ )
  {
    let inputs = self.inputs[ d ].inputPrinter.inputs;
    if( o.withoutOutputToOriginal && self.inputs[ d ].originalOutput )
    continue;
    if( inputs && inputs.length )
    {
      if( _hasInput.call( self.inputs[ d ].inputPrinter, input, o ) )
      return true;
    }
  }

  return false;
}

_hasInput.defaults =
{
  deep : 0,
  withoutOutputToOriginal : 1,
}

//

function hasInputClose( input )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return self._hasInput( input, { deep : 0 } );
}

//

function hasInputDeep( input )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return self._hasInput( input, { deep : 1 } );
}

//

function _hasOutput( output, o )
{
  let self = this;

  o = _.routine.options_( _hasOutput, o || null );
  _.assert( _.mapIs( o ) );
  _.assert( _.printerLike( output ) || _.processIs( output ) || _.streamIs( output ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  for( let d = 0 ; d < self.outputs.length ; d++ )
  {
    if( self.outputs[ d ].outputPrinter === output )
    {
      if( o.withoutOutputToOriginal && self.outputs[ d ].originalOutput )
      continue;
      return true;
    }
  }

  if( o.deep )
  for( let d = 0 ; d < self.outputs.length ; d++ )
  {
    let outputs = self.outputs[ d ].outputPrinter.outputs;
    if( o.withoutOutputToOriginal && self.outputs[ d ].originalOutput )
    continue;
    if( outputs && outputs.length )
    {
      if( _hasOutput.call( self.outputs[ d ].outputPrinter, output, o ) )
      return true;
    }
  }

  return false;
}

_hasOutput.defaults =
{
  deep : 0,
  withoutOutputToOriginal : 1,
}

//

function hasOutputClose( output )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return self._hasOutput( output, { deep : 0 } );
}

//

function hasOutputDeep( output )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return self._hasOutput( output, { deep : 1 } );
}

function _chainDescriptorLike( src )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( src instanceof self.ChainDescriptor )
  {
    return true;
  }
  else if( _.objectLike( src ) )
  {
    return _.mapHasAll( src, self.ChainDescriptorFields );
  }

  return false;
}

// --
// fields
// --

let chainerSymbol = Symbol.for( 'chainer' );

/* xxx : use blueprint */
function ChainDescriptor(){};
ChainDescriptor.prototype = Object.create( null );

let ChainDescriptorFields =
{
  exclusiveOutput : 0,
  originalOutput : 0,
  inputPrinter : null,
  outputPrinter : null,
  inputCombining : null,
  outputCombining : null,
  freed : 0,
  write : null,
  onDataHandler : null
}

let Combining = [ 'rewrite', 'supplement', 'append', 'prepend' ];

let Channel = _.LoggerBasic.Channel;
_.assert( Channel.length > 0 );

// --
// relations
// --

let Composes =
{
  name : null,
  hasOriginalOutputs : 0,
}

let Aggregates =
{
}

let Associates =
{
  printer : null,
  inputs : _.define.own( [] ),
  outputs : _.define.own( [] ),
  originalWriteMap : _.define.own( {} ),
  readFromMap : _.define.own( {} ),
  exclusiveOutputPrinter : null,
}

let Restricts =
{
}

let Statics =
{

  _chain,

  Get,
  MakeFor,
  _chainDescriptorMake,
  _printerReadFromConsole,
  _printerReadFromPrinter,

  ChainDescriptor,
  ChainDescriptorFields,

  _chainDescriptorLike,

  Combining,
  Channel,

}

let Forbids =
{
  chainDescriptors : 'chainDescriptors',
}

let Accessors =
{
  name : 'name',
}

// --
// declare
// --

let Extension =
{

  // inter

  init,
  finit,

  _outputToConsole,
  _inputFromConsole,
  _outputToStream,
  _inputFromStream,

  outputTo,
  inputFrom,

  _unchain,
  outputUnchain,
  inputUnchain,
  unchainEverything,

  _restoreOriginalWriteConsole,

  //

  _chainDescriptorMake,
  _chainDescriptorFree,
  MakeFor,
  _printerReadFromConsole,
  _printerReadFromPrinter,

  //

  _nameGet,
  _nameSet,

  // dichotomy

  _hasInput,
  hasInputClose,
  hasInputDeep,

  _hasOutput,
  hasOutputClose,
  hasOutputDeep,

  _chainDescriptorLike,

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
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

// --
// export
// --

_[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
