( function _Files_s_()
{

'use strict';

/**
 * Collection of classes to abstract files systems. Many interfaces provide files, but not called as file systems and treated differently. For example server-side gives access to local files and browser-side HTTP/HTTPS protocol gives access to files as well, but in the very different way, it does the first. This problem forces a developer to break fundamental programming principle DRY and make code written to solve a problem not applicable to the same problem, on another platform/technology. Files treats any file-system-like interface as files system. Files combines all files available to the application into the single namespace where each file has unique Path/URI, so that operating with several files on different files systems is not what user of the module should worry about. If Files does not have an adapter for your files system you may design it providing a short list of stupid methods fulfilling completely or partly good defined API and get access to all sophisticated general algorithms on files for free. Is concept of file applicable to external entities of an application? Files makes possible to treat internals of a program as files system(s). Use the module to keep DRY.
  @module Tools/mid/Files
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../include/Top.s' );
  module[ 'exports' ] = _;
}

})();
