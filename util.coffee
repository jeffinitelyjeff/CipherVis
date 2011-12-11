root = exports ? this

# This file contains helpful utility functions for the cipher algorithms
# performed by Cipher Vis.

# Faster logging syntax.
log = (x) -> console.log(x)

## Miscellaneous utilities ##

utils =

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

str =

  # Convert string `this` to integer array.
  to_a: () -> arr.to_int.call(this.split(''))

  # Create copy of string `this` with characters reversed.
  reverse: () -> this.split('').reverse().join('')

  # Determine if string `this` is all uppercase.
  is_upper: () -> this == this.toUpperCase()

  # Determine if string `this` is all lowercase.
  is_lower: () -> this == this.toLowerCase()

  # Determine if all characters in string `this` are valid hex characters.
  is_hex: () ->
    _.all(this.split(''), (s) ->
      (str.is_lower.call(s) and "0" <= s <= "f") or
      (str.is_lower.call(s) and "0" <= s <= "F")
    )

  # Determine if all characters in string `this` are binary chars.
  is_bin: () -> _.all(this, (d) -> d == "0" or d == "1")

  # Convert hexadecimal string `this` to binary string.
  to_bin: () ->
    switch this.length
      when 0 then ''
      when 1 then
        log "INVALID HEX CHAR" unless str.is_hex.call(this)
        s = parseInt(this, 16).toString(2)
        '0000'.slice(s.length) + s
      else
        _.reduce(this.split(''), ((mem, h) -> mem + str.to_bin.call(h)), '')

  # Convert hexadecimal string `this` to binary array.
  to_bin_array: () -> str.to_bin.call(this).split('')

  # Converts string `this` to an array of integers, split by delimeter `delim`
  # (the default value is `' '`).
  to_vector: (delim = ' ') -> _.without(this.split(delim), '').to_int()


## Array utilities ##
# These are all functions that should be added to `Array.prototype`. We use the
# `arr.to_hex.call(a)` form to use the functions before they're added to the
# `Array` prototype; when these functions are imported in the main files, they
# will be accessible as `a.to_hex()`.

arr =

  # Determine if all characters in array `this` are binary integers (`0` or `1`).
  is_bin: () -> _.all(this, (d) -> utils.is_num(d) and (d == 0 or d == 1))

  # Create copy of array `this` where each element is an integer.
  to_int: () -> _.map(this, (x) -> parseInt(x))

  # Convert binary array `this` to hexadecimal string.
  to_hex: () -> parseInt(this.join(''), 2).toString(16).toUpperCase()

  # Create an array which is the bitwise (element-wise) xor of arrays `this` and
  # `that`. Assumes `this` and `that` are both binary arrays.
  xor: (that) ->
    log "FIRST XOR OPERAND NOT BINARY" unless arr.is_bin.call(this)
    log "SECOND XOR OPERAND NOT BINARY" unless arr.is_bin.call(that)
    log "XOR OPERANDS HAVE DIFFERENT LENGTHS" unless this.length == that.length
    _.map(_.zip(this, that), (x) -> x[0] ^ x[1])

  # Create an array that is the specified indices `idxs` of array
  # `this`. Indices in `idxs` are 1-indexed (first element has index 1).
  collect: (idxs) -> _.map(idxs, (i) -> this[i-1])

  # Forms a prettified string representation of array `this`. If `n` is
  # provided, will insert a space every `n` characters.
  print: (n = 0) ->
    that = []
    _.each(this, (e, i) ->
      that.push e
      that.push(' ') if (i+1) % n == 0
    )
    that.join('')

  # Returns the last element of array `this`.
  peek: () -> this[this.length - 1]

  # Splits array `this` into `n` parts each (except the last probably) of length
  # `this.length / n`.
  into_parts: (n) ->
    m = this.length / n
    splits = []
    _.times(n, (i) -> splits.push this.slice(m*i, m*(i+1)))
    splits

  # Shifts the elements of array `this` left `n` times. `n` elements at the
  # beginning of the array are placed at the end (in order).
  shift_left: (n) -> this.slice(n).concat(this.slice(0, n))


# Export the collections of functions.
root.utils = utils
root.str = str
root.arr = arr
