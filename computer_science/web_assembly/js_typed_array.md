# **[JavaScript typed arrays](<https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Typed_arrays>)**

JavaScript typed arrays are array-like objects that provide a mechanism for reading and writing raw binary data in memory buffers.

Typed arrays are not intended to replace arrays for any kind of functionality. Instead, they provide developers with a familiar interface for manipulating binary data. This is useful when interacting with platform features, such as audio and video manipulation, access to raw data using WebSockets, and so forth. Each entry in a JavaScript typed array is a raw binary value in one of a number of supported formats, from 8-bit integers to 64-bit floating-point numbers.

Typed array objects share many of the same methods as arrays with similar semantics. However, typed arrays are not to be confused with normal arrays, as calling Array.isArray() on a typed array returns false. Moreover, not all methods available for normal arrays are supported by typed arrays (e.g., push and pop).

To achieve maximum flexibility and efficiency, JavaScript typed arrays split the implementation into buffers and views. A buffer is an object representing a chunk of data; it has no format to speak of, and offers no mechanism for accessing its contents. In order to access the memory contained in a buffer, you need to use a **[view](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Typed_arrays#views)**. A view provides a context — that is, a data type, starting offset, and number of elements.

![i](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Typed_arrays/typed_arrays.png)

Buffers
There are two types of buffers: **[ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer)** and **[SharedArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer)**. Both are low-level representations of a memory span. They have "array" in their names, but they don't have much to do with arrays — you cannot read or write to them directly. Instead, buffers are generic objects that just contain raw data. In order to access the memory represented by a buffer, you need to use a view.

Buffers support the following actions:

- **Allocate:** As soon as a new buffer is created, a new memory span is allocated and initialized to 0.
- **Copy:** Using the slice() method, you can efficiently copy a portion of the memory without creating views to manually copy each byte.
- **Transfer:** Using the transfer() and transferToFixedLength() methods, you can transfer ownership of the memory span to a new buffer object. This is useful when transferring data between different execution contexts without copying. After the transfer, the original buffer is no longer usable. A SharedArrayBuffer cannot be transferred (as the buffer is already shared by all execution contexts).
- **Resize:** Using the resize() method, you can resize the memory span (either claim more memory space, as long as it doesn't pass the pre-set maxByteLength limit, or release some memory space). SharedArrayBuffer can only be grown but not shrunk.

The difference between ArrayBuffer and SharedArrayBuffer is that the former is always owned by a single execution context at a time. If you pass an ArrayBuffer to a different execution context, it is transferred and the original ArrayBuffer becomes unusable. This ensures that only one execution context can access the memory at a time. A SharedArrayBuffer is not transferred when passed to a different execution context, so it can be accessed by multiple execution contexts at the same time. This may introduce race conditions when multiple threads access the same memory span, so operations such as **[Atomics](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics)** methods become useful.

## Views

There are currently two main kinds of views: typed array views and **[DataView](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView)**. Typed arrays provide **[utility methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray#instance_methods)** that allow you to conveniently transform binary data. DataView is more low-level and allows granular control of how data is accessed. The ways to read and write data using the two views are very different.

Both kinds of views cause ArrayBuffer.isView() to return true. They both have the following properties:

buffer
The underlying buffer that the view references.

byteOffset
The offset, in bytes, of the view from the start of its buffer.

byteLength
The length, in bytes, of the view.

Both constructors accept the above three as separate arguments, although typed array constructors accept length as the number of elements rather than the number of bytes.

## Typed array views

Typed array views have self-descriptive names and provide views for all the usual numeric types like Int8, Uint32, Float64 and so forth. There is one special typed array view, Uint8ClampedArray, which clamps the values between 0 and 255. This is useful for **[Canvas data processing](https://developer.mozilla.org/en-US/docs/Web/API/ImageData)**, for example.

| Type              | Value Range               | Size in bytes | Web IDL type        |
|-------------------|---------------------------|---------------|---------------------|
| Int8Array         | -128 to 127               | 1             | byte                |
| Uint8Array        | 0 to 255                  | 1             | octet               |
| Uint8ClampedArray | 0 to 255                  | 1             | octet               |
| Int16Array        | -32768 to 32767           | 2             | short               |
| Uint16Array       | 0 to 65535                | 2             | unsigned short      |
| Int32Array        | -2147483648 to 2147483647 | 4             | long                |
| Uint32Array       | 0 to 4294967295           | 4             | unsigned long       |
| Float16Array      | -65504 to 65504           | 2             | N/A                 |
| Float32Array      | -3.4e38 to 3.4e38         | 4             | unrestricted float  |
| Float64Array      | -1.8e308 to 1.8e308       | 8             | unrestricted double |
| BigInt64Array     | -263 to 263 - 1           | 8             | bigint              |
| BigUint64Array    | 0 to 264 - 1              | 8             | bigint              |
