root = exports ? this


## Settings

DEBUG = true


## Misc. Utilities

String.prototype.reverse = () -> this.split('').reverse().join('')

is_string = (s) -> typeof s == "string"

is_array = (a) -> $.isArray(a)

log = (x) -> console.log(x)

# Determine if all characters in `str` are hex.
all_hex = (str) ->
  _.all(str.split(""), (s) ->
    (s == s.toLowerCase() and "0" <= s <= "f") or
    (s != s.toLowerCase() and "0" <= s <= "F")
  )

# Determine if all characters in array `a` are binary (`0` or `1`).
all_bin = (a) ->
  log "all_bin called with non-array argument" unless $.isArray(a)
  _.all(a, (d) -> d == 0 or d == 1)


## Conversion Functions

hex_digit_to_bin_array = (h) ->
  s = parseInt(h, 16).toString(2)
  ("0000".slice(s.length) + s).split("").to_int()

hex_to_bin_array = (s) ->
  log("INVALID HEX STRING") unless all_hex(s)
  _.reduce(s.split(""), ((mem, h) -> mem.concat(hex_digit_to_bin_array(h))), [])

## Binary Operations

# Returns whether `n` is a valid binary representation (array or string of
# `0`s and `1`s). Will only check if every digit is a `0` or `1` if DEBUG is on.
valid_bin = (n) ->
  (is_string(n) or is_array(n)) and
  (not DEBUG or
    (is_string(n) and all_bin(n.split(''))) or
    (is_array(n) and all_bin(n)))

# Xor on two binary arrays or strings; returns a binary array.
xor = (b1, b2) ->
  log "1st argument in Xor not vaild binary" unless valid_bin(b1)
  log "2nd argument in Xor not valid binary" unless vaild_bin(b2)
  log "Arguments in Xor have different length" unless b1.length == b2.length

  _.map(_.zip(b1, b2), (x) -> x[0] ^ x[1])


## Array operations

# Create an array that is the collection of the specified indices `idxs` of
# array `a`. Indicies in `idxs` are indexed starting at 1.
collect = (a, idxs) ->
  _.map(idxs, (i) -> a[i-1])

String.prototype.to_vector = (delim = ' ') -> _.without(this.split(delim), "")

Array.prototype.print = () -> this.join('')
Array.prototype.peek = () -> this[this.length - 1]
Array.prototype.to_int = () -> _.map(this, (x) -> parseInt(x))

# Shifts the elements of the array left `i` times. `i` elements at the
# beginning of the array are placed at the end.
Array.prototype.left_shift = (i) ->
  this.slice(i).concat(this.slice(0, i))


## DES

des = (hs_k, hs_p) ->

  permutation_tables =
    # 64 bits -> 56 bits
    pc1: "57  49  41  33  25  17  9
          1   58  50  42  34  26  18
          10  2   59  51  43  35  27
          19  11  3   60  52  44  36
          63  55  47  39  31  23  15
          7   62  54  46  38  30  22
          14  6   61  53  45  37  29
          21  13  5   28  20  12  4"
    # 56 bits -> 48 bits
    pc2: "14  17  11  24  1   5
           3  28  15  6   21  10
          23  19  12  4   26  8
          16  7   27  20  13  2
          41  52  31  37  47  55
          30  40  51  45  33  48
          44  49  39  56  34  53
          46  42  50  36  29  32"
    # 64 bits -> 64 bits
    ip: "58  50  42  34  26  18  10  2
         60  52  44  36  28  20  12  4
         62  54  46  38  30  22  14  6
         64  56  48  40  32  24  16  8
         57  49  41  33  25  17  9   1
         59  51  43  35  27  19  11  3
         61  53  45  37  29  21  13  5
         63  55  47  39  31  23  15  7"






  permutations = {}
  _.each(permutation_tables, (v, k) ->
    permutations[k] = (a) -> collect(a, v.to_vector())
  )

  log "k: #{hs_k}"
  log "p: #{hs_p}"

  # Binary arrays of key and plaintext.
  k = hex_to_bin_array hs_k
  p = hex_to_bin_array hs_p

  log "k: #{k.print()}"
  log "p: #{p.print()}"

  ### Create subkeys ###
  # We generate 16 48-bit subkeys.


  # Apply PC-1. 64 bits -> 56 bits.
  k_prime = permutations.pc1(k)
  log "k': #{k_prime.print()}"

  # Split permuted key into two halves.
  c = []
  d = []

  c.push k_prime.slice(0, 28)
  d.push k_prime.slice(28)

  shift_schedule = "1122222212222221".to_vector('')
  log "shift schedule: #{shift_schedule.print()}"

  _.each(shift_schedule, (shift) ->
    c.push c.peek().left_shift(shift)
    d.push d.peek().left_shift(shift)
  )

  _.each(c, (ci, i) -> log "c#{i}: #{ci.print()}")
  _.each(d, (di, i) -> log "d#{i}: #{di.print()}")





# Validate the key and plaintext; return error if etiher fails to validate.
validate = (key, plain) ->

  generic_validate = (name, str) ->

    if str == ""
      "#{name} empty"
    else if str.length < 16
      "#{name} too short"
    else if str.length > 16
      "#{name} too long"
    else unless all_hex(str)
      "non-hex chars in #{name}"
    else
      ""

  caps = (str) ->
    str.charAt(0).toUpperCase() + str.slice(1)

  k_msg = generic_validate("key", key)
  p_msg = generic_validate("plaintext", plain)

  if k_msg
    if p_msg
      "#{caps(k_msg)}; #{p_msg}"
    else
      caps(k_msg)
  else
    if p_msg
      caps(p_msg)
    else
      ""


$(document).ready ->

  # Run DES when the arrows are clicked.
  $("#encipher").click ->
    k = $("#key").val()
    p = $("#plaintext").val()

    val = validate(k, p)

    if val
      $("#error").text(val).fadeIn(500)
    else
      $("#error").fadeOut(500, () -> $(this).text(""))
      $("#ciphertext").text des(k, p)

  $("#plaintext, #key").keydown (e) -> $("#encipher").click() if e.keyCode == 13

  if DEBUG
    $("#key").val("596F7572206C6970")
    $("#plaintext").val("732061726520736D")
