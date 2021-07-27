( function _l7_Time_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function rarely_functor( perTime, routine )
{
  let lastTime = _.time.now() - perTime;

  _.assert( arguments.length === 2 );
  _.assert( _.number.is( perTime ) );
  _.assert( _.routine.is( routine ) );

  return function fewer()
  {
    let now = _.time.now();
    let elapsed = now - lastTime;
    if( elapsed < perTime )
    return;
    lastTime = now;
    return routine.apply( this, arguments );
  }

}

//

function once( delay, onBegin, onEnd )
{
  let con = _.Consequence ? new _.Consequence({ /* sourcePath : 2 */ }) : undefined;
  let taken = false;
  let options;
  let optionsDefault =
  {
    delay : null,
    onBegin : null,
    onEnd : null,
  }

  if( _.object.isBasic( delay ) )
  {
    options = delay;
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.map.assertHasOnly( options, optionsDefault );
    delay = options.delay;
    onBegin = options.onBegin;
    onEnd = options.onEnd;
  }
  else
  {
    _.assert( 2 <= arguments.length && arguments.length <= 3 );
  }

  // _.assert( 0, 'not tested' );
  _.assert( delay >= 0 );
  _.assert( _.primitive.is( onBegin ) || _.routine.is( onBegin ) || _.object.isBasic( onBegin ) );
  _.assert( _.primitive.is( onEnd ) || _.routine.is( onEnd ) || _.object.isBasic( onEnd ) );

  return function once()
  {

    if( taken )
    {
      /*console.log( 'once :', 'was taken' );*/
      return;
    }
    taken = true;

    if( onBegin )
    {
      if( _.routine.is( onBegin ) ) onBegin.apply( this, arguments );
      else if( _.object.isBasic( onBegin ) ) onBegin.take( arguments );
      if( con )
      con.take( null );
    }

    _.time.out( delay, function()
    {

      if( onEnd )
      {
        if( _.routine.is( onEnd ) ) onEnd.apply( this, arguments );
        else if( _.object.isBasic( onEnd ) ) onEnd.take( arguments );
        if( con )
        con.take( null );
      }
      taken = false;

    });

    return con;
  }

}

//

function debounce( o ) /* Dmytro : routine returns routine. Is it valid result? */
{
  _.assert( arguments.length <= 3 );

  if( arguments.length > 1 )
  {
    o =
    {
      routine : arguments[ 0 ],
      delay : arguments[ 1 ],
      immediate : ( arguments.length > 2 ? arguments[ 2 ] : null ),
    }
  }

  _.routine.options( debounce, o  );

  _.assert( _.routine.is( o.routine ) );
  _.assert( _.number.is( o.delay ) );

  let timer, lastCallTime, routine, result;

  return debounced;

  /* */

  function debounced()
  {
    lastCallTime = _.time.now();
    routine = _.routine.join( this, o.routine, arguments );
    let execNow = o.immediate && !timer
    if( !timer )
    timer = setTimeout( onDelay, o.delay );
    if( execNow )
    result = routine();
    return result;
  };

  function onDelay()
  {
    var elapsed = _.time.now() - lastCallTime;

    if( elapsed > o.delay )
    {
      timer = null;
      if( !o.immediate )
      result = routine();
    }
    else
    {
      timer = setTimeout( onDelay, o.delay - elapsed );
    }
  };
}

debounce.defaults =
{
  routine : null,
  delay : 100,
  immediate : false
}

// --
// declaration
// --

let TimeExtension =
{

  rarely_functor, /* check */
  once, /* qqq : cover by light test */

  debounce

}

//

_.props.supplement( _.time, TimeExtension );

})();
