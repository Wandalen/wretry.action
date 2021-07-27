( function _ProcessBasic_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to execute system commands, run shell, batches, launch external processes from JavaScript application. Module Process leverages not only outputting data from an application but also inputting, makes application arguments parsing and accounting easier. Use the module to get uniform experience from interaction with an external processes on different platforms and operating systems.
  @module Tools/base/ProcessBasic
*/

if( typeof module !== 'undefined' )
{
  require( '../include/Basic.s' );
  require( '../include/Mid.s' );
  module[ 'exports' ] = _global_.wTools;
}

})();
