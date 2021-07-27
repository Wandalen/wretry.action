( function _l1_Module_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const __ = _realGlobal_.wTools;
let ModuleFileNative = null;

_.module = _.module || Object.create( null );
__.module = __.module || Object.create( null );

// --
//
// --

const _toolsPath = __dirname + '/../../../../node_modules/Tools';
function toolsPathGet()
{
  return _toolsPath;
}

//

const _toolsDir = __dirname + '/../../../../wtools';
function toolsDirGet()
{
  return _toolsDir;
}

// --
// module extension
// --

var ModuleExtension =
{

  toolsPathGet,
  toolsDirGet,

}

Object.assign( _.module, ModuleExtension );

// --
// tools extension
// --

let ToolsExtension =
{

}

Object.assign( _, ToolsExtension );

})();
