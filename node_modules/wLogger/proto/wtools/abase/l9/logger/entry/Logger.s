( function _Logger_s_( )
{

'use strict';

/**
 * Class to log data consistently which supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.
  @module Tools/base/Logger
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../include/Mid.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
