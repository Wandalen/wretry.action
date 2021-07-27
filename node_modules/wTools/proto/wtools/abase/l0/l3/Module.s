( function _l3_Module_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

const _toolsPath = _.path.canonize( __dirname + '/../../../../node_modules/Tools' );
function toolsPathGet()
{
  return _toolsPath;
}

//

const _toolsDir = _.path.canonize( __dirname + '/../../../../wtools' );
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
