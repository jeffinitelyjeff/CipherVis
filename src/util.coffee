root = exports ? this

# This file contains helpful utility functions for the cipher algorithms
# performed by Cipher Vis.

# Faster logging syntax.
log = (s) ->
  console.log(s)
  return s

# Faster error syntax. Probably won't use this much because anonymous errors are
# harder to test against.
err = (s) ->
  throw new Error(s)

## Miscellaneous utilities ##

utils =

  log: log

  err: err

  # Determine if variable `s` is a string. There are several methods for type
  # introspection in JavaScript, so this provides an easy abstraction away from
  # those details and provides consistency with other `is_` functions.
  is_string: (s) -> typeof s == "string"

  # Determine if variable `a` is an array. There are several methods for type
  # introspection in JavaScript, so this provides an easy abstraction away from
  # those details and provides consistency with other `is_` functions.
  is_array: (a) -> $.isArray(a)

  # Determine if variable `x` is a number. There are several methods for type
  # introspection in JavaScript, so this provides an easy abstraction away from
  # those details and provides consistency with other `is_` functions.
  is_num: (x) -> typeof x == "number"


## String utilities ##
# These are all functions that should be added to `String.prototype`. We use the
# `str.is_lower.call(s)` form to use the functions before they're added to the
# `String` prototype; when these functions are imported in the main files, they
# will be accessible as `s.is_lower()`.

str = {}

# Convert string `this` to integer array.
str.to_int_a = () -> arr.to_int.call(this.split(''))

# Create copy of string `this` with characters reversed.
str.reverse = () -> this.split('').reverse().join('')

# Capitalize the first character of string `this`
str.caps = () -> this.charAt(0).toUpperCase() + this.slice(1)

# Determine if string `this` is all uppercase.
str.is_upper = () -> "" + this == this.toUpperCase()

# Determine if string `this` is all lowercase.
str.is_lower = () -> "" + this == this.toLowerCase()

# Determine if all characters in string `this` are valid hex characters.
str.is_hex = () ->
  _.all(this.split(''), (s) ->
    (str.is_lower.call(s) and "0" <= s <= "f") or
    (not str.is_lower.call(s) and "0" <= s <= "F")
  )

# Determine if all characters in string `this` are binary chars.
str.is_bin = () -> _.all(this, (d) -> d == "0" or d == "1")

# Convert hexadecimal string `this` to binary string.
str.to_bin = () ->
  switch this.length
    when 0 then ''
    when 1
      throw str.to_bin.err_char unless str.is_hex.call(this)
      s = parseInt(this, 16).toString(2)
      '0000'.slice(s.length) + s
    else
      _.reduce(this.split(''), ((mem, h) -> mem + str.to_bin.call(h)), '')
str.to_bin.err_char = new Error "str.to_bin: invalid hex char"
# Shorthand for `str.to_bin`.
str.to_b = str.to_bin

# Convert hexadecimal string `this` to binary array.
str.to_bin_array = () ->
  throw str.to_bin_array.err_hex unless str.is_hex.call(this)
  str.to_int_a.call(str.to_bin.call(this))
str.to_bin_array.err_hex = new Error "str.to_bin_array: string not hex"
# Shorthand for `str.to_bin_array`.
str.to_ba = str.to_bin_array

# Converts string `this` to an array of integers, split by delimeter `delim`
# (the default value is `' '`).
str.to_vector = (delim = ' ') -> _.without(this.split(delim), '').to_int()

# Repeats string `this` `n` number of times. Like `n * this` in Python.
str.repeat = (n = 1) -> new Array(n+1).join(this)

# Creates a copy of `this` with enough `0`s in front such that the new length
# is at least `n`.
str.pad = (n, c = '0') -> ("" + c).repeat(n).slice(this.length) + this


## Array utilities ##
# These are all functions that should be added to `Array.prototype`. We use the
# `arr.to_hex.call(a)` form to use the functions before they're added to the
# `Array` prototype; when these functions are imported in the main files, they
# will be accessible as `a.to_hex()`.

arr = {}

# Determine if all characters in array `this` are binary integers (`0` or `1`).
arr.is_bin = () -> _.all(this, (d) -> utils.is_num(d) and (d == 0 or d == 1))

# Create copy of array `this` where each element is an integer.
arr.to_int = () -> _.map(this, (x) -> parseInt(x))

# Convert binary array `this` to hexadecimal string.
arr.to_hex = () ->
  throw arr.to_hex.err_bin unless arr.is_bin.call(this)
  parseInt(this.join(''), 2).toString(16).toUpperCase()
arr.to_hex.err_bin = new Error "arr.to_hex: array is not binary"

# Create an array which is the bitwise (element-wise) xor of arrays `this` and
# `that`. Assumes `this` and `that` are both binary arrays.
arr.xor = (that) ->
  throw arr.xor.err_diff_len unless this.length == that.length
  throw arr.xor.err_op1 unless arr.is_bin.call(this)
  throw arr.xor.err_op2 unless arr.is_bin.call(that)
  _.map(_.zip(this, that), (x) -> x[0] ^ x[1])
arr.xor.err_op1 = new Error "arr.xor: 1st operand not binary"
arr.xor.err_op2 = new Error "arr.xor: 2nd operand not binary"
arr.xor.err_diff_len = new Error "arr.xor: operands have different length"

# Create an array that is the specified indices `idxs` of array
# `this`. Indices in `idxs` are 1-indexed (first element has index 1).
arr.collect = (idxs) ->
  _.map(idxs, (i) ->
    throw arr.collect.err_neg unless i > 0
    this[i-1]
  )
arr.collect.err_neg = new Error "arr.collect: non-pos int encountered"

# Forms a prettified string representation of array `this`. If `n` is
# provided, will insert a space every `n` characters.
arr.print = (n = 0) ->
  that = []
  _.each(this, (e, i) ->
    that.push e
    that.push(' ') if (i+1) % n == 0
  )
  that.join('')

# Returns the last element of array `this`.
arr.peek = () -> this[this.length - 1]

# Splits array `this` into `n` parts each (except the last probably) of length
# `this.length / n`.
arr.into_parts = (n) ->
  m = this.length / n
  splits = []
  _.times(n, (i) -> splits.push this.slice(m*i, m*(i+1)))
  splits

# Shifts the elements of array `this` left `n` times. `n` elements at the
# beginning of the array are placed at the end (in order).
arr.shift_left = (n) -> this.slice(n).concat(this.slice(0, n))


# Export the collections of functions.
root.utils = utils
root.str = str
root.arr = arr
