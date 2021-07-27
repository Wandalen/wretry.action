( function _Config_s_()
{

'use strict';

// real global

if( !_realGlobal_.Config )
_realGlobal_.Config = { debug : true }
if( _realGlobal_.Config.debug === undefined )
_realGlobal_.Config.debug = true;
if( _realGlobal_.Config.interpreter === undefined )
if( ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) )
_realGlobal_.Config.interpreter = 'njs';
else
_realGlobal_.Config.interpreter = 'browser';
if( _realGlobal_.Config.isWorker === undefined )
if( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' )
_realGlobal_.Config.isWorker = true;
else
_realGlobal_.Config.isWorker = false;

// current global

if( !_global_.Config )
_global_.Config = Object.create( _realGlobal_.Config )
if( _global_.Config.debug === undefined )
_global_.Config.debug = true;
if( _global_.Config.interpreter === undefined )
_global_.Config.interpreter = _realGlobal_.Config.interpreter;
if( _global_.Config.isWorker === undefined )
_global_.Config.isWorker = _realGlobal_.Config.isWorker

})();
