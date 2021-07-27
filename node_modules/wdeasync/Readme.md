# module::wDeasync [![status](https://img.shields.io/github/workflow/status/Wandalen/wDeasync/GypPublish?label=publish%3A)](https://github.com/Wandalen/wDeasync/actions/workflows/GypPublish.yml) [![NPM version](http://img.shields.io/npm/v/wdeasync.svg)](https://www.npmjs.org/package/wdeasync)

Deasync turns async function into sync, implemented with a blocking mechanism by calling Node.js event loop at JavaScript layer. The core of deasync is writen in C++.

## About this fork

This fork is created to provide prebuild versions of the library. [Original repository](https://github.com/abbr/deasync)

## Motivation

Suppose you maintain a library that exposes a function <code>getData</code>. Your users call it to get actual data:
<code>var myData = getData();</code>
Under the hood data is saved in a file so you implemented <code>getData</code> using Node.js built-in <code>fs.readFileSync</code>. It's obvious both <code>getData</code> and <code>fs.readFileSync</code> are sync functions. One day you were told to switch the underlying data source to a repo such as MongoDB which can only be accessed asynchronously. You were also told to avoid pissing off your users, <code>getData</code> API cannot be changed to return merely a promise or demand a callback parameter. How do you meet both requirements?

You may tempted to use [node-fibers](https://github.com/laverdet/node-fibers) or a module derived from it, but node fibers can only wrap async function call into a sync function inside a fiber. In the case above you cannot assume all  callers are inside fibers. On the other hand, if you start a fiber in `getData` then `getData` itself will still return immediately without waiting for the async call result. For similar reason ES6 generators introduced in Node v0.11 won't work either.

What really needed is a way to block subsequent JavaScript from running without blocking entire thread by yielding to allow other events in the event loop to be handled. Ideally the blockage is removed as soon as the result of async function is available. A less ideal but often acceptable alternative is a `sleep` function which you can use to implement the blockage like ```while( !done ) sleep( 100 );```. It is less ideal because sleep duration has to be guessed. It is important the `sleep` function not only shouldn't block entire thread, but also shouldn't incur busy wait that pegs the CPU to 100%.
</small>

DeAsync supports both alternatives.

## Usages

Generic wrapper of async function with conventional API signature `function( p1, ...pn, function cb( error, result ){ } )`. Returns `result` and throws `error` as exception if not null:

```javascript
var wdeasync = require( 'wdeasync' );
var cp = require( 'child_process' );
var exec = wdeasync( cp.exec );
// output result of ls -la
try
{
  console.log(exec('ls -la'));
}
catch( err )
{
  console.log( err );
}
// done is printed last, as supposed, with cp.exec wrapped in wdeasync; first without.
console.log( 'done' );
```

For async function with unconventional API, for instance `function asyncFunction(p1,function cb(res){})`, use `loopWhile(predicateFunc)` where `predicateFunc` is a function that returns boolean loop condition

```javascript
var done = false;
var data;
asyncFunction(p1,function cb(res)
{
  data = res;
  done = true;
});
require( 'wdeasync' ).loopWhile( function(){ return !done; } );
// data is now populated
```

Sleep (a wrapper of setTimeout)

```javascript
function SyncFunction()
{
  var ret;
  setTimeout(function()
  {
      ret = "hello";
  },3000);
  while(ret === undefined)
  {
    require( 'wdeasync' ).sleep(100);
  }
  // returns hello with sleep; undefined without
  return ret;
}
```

## Installation

Unlike original implementation, this has binary distributed, so C++ compiler is not mandatory requirement. Altought, rare OS + CPU combinations might require to recompile `wdeasync`.

To install, run

```npm install wdeasync```


## Recommendation

Unlike other (a)sync js packages that mostly have only syntactic impact, DeAsync also changes code execution sequence. As such, it is intended to solve niche cases like the above one. If all you are facing is syntatic problem such as callback hell, using a less drastic package implemented in pure js is recommended.
