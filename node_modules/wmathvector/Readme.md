# module::MathVector [![status](https://github.com/Wandalen/wMathVector/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wMathVector/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Collection of functions for vector math. `MathVector` introduces missing in JavaScript type `VectorAdapter`. Vector adapter is an implementation of the abstract interface, a kind of link that defines how to interpret data as the vector. The adapter could specify offset, length, and stride what changes how the original container is interpreted but does not alter its data. The length of the vector specified by the adapter is not necessarily equal to the length of the original container, siblings elements of such vector are not necessarily sibling in the original container. Thanks to adapters storage format of vectors do not make a big difference for math algorithms. Module `MathVector` implements math functions that accept vector specified by either adapter or Array/Buffer. Use MathVector to be more functional with math and less constrained with storage format.

### Try out from the repository

```
git clone https://github.com/Wandalen/wMathVector
cd wMathVector
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wmathvector@stable'
```

`Willbe` is not required to use the module in your project as submodule.

### Why?

Math algorithms should be independent of the data type or form of the vector. This module revolves around the principle.

Features of this implementation of vector mathematics are:

- **Cleanliness**: the module does not inject methods, does not contaminate or alter the standard interface.
- **Zero-copy principle**: the module makes it possible to avoid redundant moving of memory thanks to the concept of the adapter.
- **Simplicity**: a regular array or typed buffer could be interpreted as a vector, no need to use special classes.
- **Usability**: the readability and conciseness of the code which uses the module are as important for us as the performance of the module.
- **Flexibility**: it's highly flexible, thanks to the ability to specify a vector with the help of an adapter. You can write and use your own implementation of a vector adapter.
- **Applicability**: it implements the same interface for different data types and forms of specifying. The code written for the adapter looks the same as the code written for the array.
- **Reliability**: the module has good test coverage.
- **Accessibility**: the module has documentation.
- **Functional programming principles**: the module uses the principles of functional programming.
  - The vector is not an object, but an abstraction.
  - Implementation of vectors have no fields "x", "y", "z".
  - All mathematical functions have an implementation that expects vectors in arguments rather than in the context.
  - Аdapter is a nonmutable object.
- **Native implementation**: under the NodeJS, it optionally uses binding to the native implementation of [BLAS-like](https://github.com/flame/blis) library ( not ready ).
- **GPGPU** implementation: under the browser, it optionally uses WebGL ( not ready ).
- **Performance**: the optimized build has high performance ( not ready ).

### Concepts of vector and vector adapter

The vector in this module means an ordered set of scalars. The vector is not an object, but an abstraction.

Vector adapter is an implementation of the abstract interface, a kind of link that defines how to interpret data as the vector. The interface of the adapter has many implementations.

### Forms of vector specifying

The vector can be defined by

- an array ( Array )
- a typed buffer ( BufferTyped )
- an adapter ( VectorAdapter )

To use the vector in the form of an array or a buffer, use the namespace `_.vector`. To use the vector specified by the adapter, use the namespace `_.vectorAdapter`.

```js

var array = [ 1, 2, 3 ];
var buffer = new F32x([ 1, 2, 3 ]);
var vad = _.vad.from([ 1, 2, 3 ]);

console.log( 'arrayIs( array ) :', _.arrayIs( array ) );
/* log : arrayIs( array ) : true */
console.log( 'arrayIs( buffer ) :', _.arrayIs( buffer ) );
/* log : arrayIs( buffer ) : false */
console.log( 'arrayIs( vad ) :', _.arrayIs( vad ) );
/* log : arrayIs( vad ) : false */
console.log( '' )

console.log( 'longIs( array ) :', _.longIs( array ) );
/* log : longIs( array ) : true */
console.log( 'longIs( buffer ) :', _.longIs( buffer ) );
/* log : longIs( buffer ) : true */
console.log( 'longIs( vad ) :', _.longIs( vad ) );
/* log : longIs( vad ) : false */
console.log( '' )

console.log( 'vectorIs( array ) :', _.vectorIs( array ) );
/* log : vectorIs( array ) : true */
console.log( 'vectorIs( buffer ) :', _.vectorIs( buffer ) );
/* log : vectorIs( buffer ) : true */
console.log( 'vectorIs( vad ) :', _.vectorIs( vad ) );
/* log : vectorIs( vad ) : true */
console.log( '' )

```

Check `arrayIs()` is true only for `array`. Check `longIs()` is true only for `array` and `buffer`. But check `vectorIs()` is true for all forms of vector.

### Simple operation on vectors

A simple example of the operation of adding two vectors.

```js
var vector1 = [ 1, 2, 3 ];
var vector2 = [ 4, 5, 6 ];

_.vector.add( vector1, vector2 );

console.log( vector1 );
/* log : [ 5, 7, 9 ] */
console.log( vector2 );
/* log : [ 4, 5, 6 ] */
```

Vector `vector1` is used simultaneously as a container to store the result and as one of the arguments of a mathematical function.

### The adapter is an abstraction

The vector can also be specified with the help of an adapter. An adapter is a special object to make algorithms more abstract and to use the same code for very different forms of vector specifying.

```js
var array1 = [ 1, 2, 3 ];
var array2 = [ 4, 5, 6 ];
var vector1 = _.vectorAdapter.from( array1 );
var vector2 = _.vectorAdapter.from( array2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.Array :: 1.000 2.000 3.000 */
console.log( 'vector2 :', vector2 );
/* log : vector2 :  VectorAdapter.x3.Array :: 4.000 5.000 6.000 */

_.vectorAdapter.add( vector1, vector2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.Array :: 5.000 7.000 9.000 */
console.log( 'vector2 :', vector2 );
/* log : vector2 :  VectorAdapter.x3.Array :: 4.000 5.000 6.000 */

console.log( 'array1 :', array1 );
/* log : array1 : [ 5, 7, 9 ] */
console.log( 'array2 :', array2 );
/* log : array2 : [ 4, 5, 6 ] */
```

The sample creates arrays `array1` and `array2`. For them, simple adapters `vector1` and `vector2` are specified. Vectors `vector2` is added to vector `vector2`. As you can see, not only the value of `vector1` but also the value of `array1` has changed.

Important: Adapters do not own data. Metaphorically, the adapter is an advanced kind of link on data.

### An adapter is a kind of link

Another example with an adapter is the multiplication of a vector by a scalar.

```js
var array = [ 1, 2, 3 ];
var vector1 = _.vectorAdapter.from( array );

_.vector.mul( array, 2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.Array :: 2.000, 4.000, 6.000 */
```

The adapter `vector1` does not make a copy of the vector but is a link to the data of the original array `array`. After multiplying the array, the adapter has a value of 2 times greater than the original.

### An adapter is an interpretation

Another technical metaphor is interpretation. The adapter does not own the data, but points to it and specifies a way to interpret it.

### Alternative interfaces

This example shows three alternative ways to use the same interface.

```js
var array1 = [ 1, 2, 3 ];
var adapter1 = _.vectorAdapter.from( array1 );

_.vector.mul( array1, 2 );
_.vectorAdapter.mul( adapter1, 2 );
adapter1.mul( 2 );

console.log( 'adapter1 :', adapter1 );
/* log : adapter1 :  VectorAdapter.x3.Array :: 8.000, 16.000, 24.000 */
```

Three consecutive multiplication of a vector using the data container `array1`, using the adapter `adapter1` and using the adapter method `adapter1.mul()` increase the value of all vector elements, making them eight times greater.

### Convention dst=null

Set the value of the first argument to `null` ( `dst = null` ) to write the result of the operation to the new vector.

```js
var srcVector1 = [ 1, 2, 3 ];
var srcVector2 = [ 4, 5, 6 ];
var dstVector = _.vector.add( null, srcVector1, srcVector2 );

console.log( srcVector1 );
/* log : [ 1, 2, 3 ] */
console.log( srcVector2 );
/* log : [ 4, 5, 6 ] */
console.log( dstVector );
/* log : [ 5, 7, 9 ] */
console.log( dstVector === srcVector1 );
/* log : false */
```

Because the first argument of the call `_.vector.add`  is `null`, a new container is created for the result. The container gets a type of the input argument `Array`. It is used to write down the result of adding two vectors `srcVector1` and` srcVector2`.

The same convention applies to all adapters and all routines of the module `MathVector`.

### Advantage of using adapters

The vector adapter is an abstract interface that has many very different implementation. Changing the implementation will not affect algorithms on vectors. You may implement your own implementation of vector adapter, and algorithms implemented in the module will stay applicable to your implementation. That's the flexibility of vector adapters.

Another strength of using vector adapters is an application [zero-copy principle](https://en.wikipedia.org/wiki/Zero-copy) of programming on practice. Thanks to vector adapter, there is no need to copy memory from a binary file to apply some math to its content. You specify adapters and call algorithms, you need, passing adapters as arguments. No copy happens.

### Adapter from range

Let's say there is a large typed `Float32` buffer `buffer1` in one-gigabyte size and a second buffer `buffer2` one-megabyte length. Somewhere in the first buffer, with some offset, a vector is hidden. We interpret the entire second buffer as a vector. How to multiply the first vector by the second and save the result in the first buffer? How to avoid useless moving of megabytes of bytes from one place to another during the process of applying math algorithms?

```js
var buffer1 = new F32x([ 1, 2, 3, 4, 5, 6, 7 ]);
var buffer2 = new F32x([ 4, 5, 6 ]);
var vector1 = _.vectorAdapter.from( buffer1, 1, 3 );
var vector2 = _.vectorAdapter.from( buffer2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 2.000, 3.000, 4.000 */
console.log( 'vector2 :', vector2 );
/* log : vector2 :  VectorAdapter.x3.F32x :: 4.000, 5.000, 6.000 */

_.vectorAdapter.add( vector1, vector2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 6.000, 8.000, 10.000 */
console.log( 'vector2 :', vector2 );
/* log : vector2 :  VectorAdapter.x3.F32x :: 4.000, 5.000, 6.000 */

console.log( 'buffer1 :', buffer1 );
/* log : buffer1 : [ 1, 6, 8, 10, 5, 6, 7 ] */
console.log( 'buffer2 :', buffer2 );
/* log : buffer2 : [ 4, 5, 6 ] */
```

When creating the adapter `vector1` from the buffer` buffer1`, we pass the offset `1` element and specify that the vector has length `3` elements. The entire second buffer is interpreted as a vector. The result of the add operation is written to the vector `vector1`. Since the adapter was created from elements 1 - 3 of the buffer `buffer1`, values of all elements outside this range remained unchanged.

![VectorAdapterFromRange.png](./doc/img/VectorAdapterFromRange.png)

The diagram explains the logic of interpreting part of a buffer as a vector. Created adapter `vector1` uses `3` elements of buffer `buffer1`, not starting from the first one. Adapter `vector2` uses the whole buffer `buffer2` and has length `3` elements too.

### Comparison with standard typed buffers

You can achieve the same effect by setting [offset](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/byteOffset), and [size](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/byteLength) typed buffer ( BufferTyped ) when constructing it from a non-typed buffer ( BufferRaw ). But that's where the standard views exhausted its flexibility. Standard views do not allow:

- Set up stride.
- Change direction.
- Specify a complex data format.
- Use array or arguments array as the original data container, only the untyped buffer.

### Specifying stride

This example is similar to the previous one. There is a large typed `Float32` buffer `buffer1` in one-gigabyte size and a second buffer `buffer2` one-megabyte length. Somewhere in the first buffer, with some offset, a vector is hidden. We interpret the entire second buffer as a vector. How to multiply the first vector by the second and save the result in the first buffer? But this time, suppose that the vector in the first buffer not only does not start from the beginning but does not go in sequence. Suppose a vector `vector1` has stride `2`. The next element of the vector is next, but one element in the buffer.

```js
var buffer1 = new F32x([ 1, 2, 3, 4, 5, 6, 7 ]);
var buffer2 = new F32x([ 4, 5, 6 ]);
var vector1 = _.vectorAdapter.fromLongLrangeAndStride( buffer1, 1, 3, 2 );
var vector2 = _.vectorAdapter.from( buffer2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 2.000, 4.000, 6.000 */
console.log( 'vector2 :', vector2 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 4.000, 5.000, 6.000 */

_.vectorAdapter.add( vector1, vector2 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 6.000, 9.000, 12.000 */
console.log( 'vector2 :', vector2 );
/* log : vector2 :  VectorAdapter.x3.F32x :: 4.000, 5.000, 6.000 */

console.log( 'vector1 :', vector1 );
/* log : vector1 : [ 1, 6, 3, 9, 5, 12, 7 ] */
console.log( 'vector2 :', vector2 );
/* log : vector2 : [ 4, 5, 6 ] */
```

The routine `_.vectorAdapter.fromLongLrangeAndStride` creates an adapter `vector1` with an offset of `1` element, `3` elements length and stride `2` elements. Then adding vector `vector2` to vector `vector1`.

![VectorAdapterFromRangeAndStride.png](./doc/img/VectorAdapterFromRangeAndStride.png)

The diagram explains the logic of interpreting part of a buffer as a vector with the help of an option stride. Created adapter `vector1` uses `3` elements of buffer `buffer1` next but one. The adapter of the vector has stride `2` elements and length `3` elements. Adapter `vector2` uses the whole buffer `buffer2` and has length `3` elements too.

### Mixing different types of vectors

Vectors with different types of elements can be mixed.

The following types are supported:

- `Array`;
- `ArgumentsArray`;
- `Number`;
- `I8x` ( `Int8Array` );
- `U8x` ( `Ui8Array` );
- `U8ClampedX` ( `Ui8ClampedArray` );
- `I16x` ( `Int16Array` );
- `U16x` ( `Ui16Array` );
- `I32x` ( `Int32Array` );
- `U32x` ( `Ui32Array` );
- `F32x` ( `Float32Array` );
- `F64x` ( `Float64Array` );
- `I64x` ( `BigInt64Array` );
- `U64x` ( `BigUint64Array` ).

### Mixing vector forms

The routines of namespace `_.vector` can work with both adapters and standard types.

The routines of namespace `_.vectorAdapter` throws an error when trying to pass them a non-adapter.

### Adapter interface

The adapter interface implements the minimum set of methods and fields required to operate the vector. These include:

- The method `eGet( i )` ( from "element get" ) is intended to get the value of the i-th element.
- The method `eSet( i, e )` ( from "element set" ) is intended to set the value of i-th element.
- The field `length` is a length of the vector in elements.

### An example of a complex format to specify a vector

The format in which the vector is specified is hidden behind the abstract interface so it can have any complexity, and its implementation details are irrelevant for the algorithms of the module `MathVector`.

For example, the number can be interpreted as a vector of arbitrary length.

```js
var vector1 = _.vectorAdapter.fromNumber( 1, 3 );
var vector2 = _.vectorAdapter.from([ 4, 5, 6 ]);

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 1.000, 1.000, 1.000 */
console.log( 'vector2 :', vector2 );
/* log : vector1 :  VectorAdapter.x3.Array :: 4.000, 5.000, 6.000 */

_.vectorAdapter.add( vector2, vector1 );

console.log( 'vector1 :', vector1 );
/* log : vector1 :  VectorAdapter.x3.F32x :: 1.000, 1.000, 1.000 */
console.log( 'vector2 :', vector2 );
/* log : vector2 :  VectorAdapter.x3.Array :: 5.000, 6.000, 7.000 */
```

The adapter `vector1` is created from a number. All values of vector `vector1` have values `1`, and its length is `3` elements. Adding vector `vector1` to vector` vector2` has the same effects as adding scalar `1` to vector `vector2`.

The example should demonstrate the flexibility of the vector adapters.

### Coercing to type Long

Use the routine `_.vector.toLong()` to convert the adapter to the `Long` type. The routine `toLong` returns the original behind the adapter if it's possible, otherwise creates a new container of the same type as the original that filled by the content of vector.

```js

var long1 = new F32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
var vector1 = _.vectorAdapter.fromLongLrangeAndStride( long1, 1, 3, 2 );
var long2 = _.vector.toLong( vector1 );

console.log( long2 );
/* log : [ 1, 3, 5 ] */
console.log( _.entity.strType( long2 ) );
/* log : Float32Array */
```
