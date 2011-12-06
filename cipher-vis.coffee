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

bin_array_to_hex = (a) ->
  parseInt(a.join(''), 2).toString(16).toUpperCase()

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
  log "2nd argument in Xor not valid binary" unless valid_bin(b2)
  log "Arguments in Xor have different length" unless b1.length == b2.length

  _.map(_.zip(b1, b2), (x) -> x[0] ^ x[1])


## Array operations

# Create an array that is the collection of the specified indices `idxs` of
# array `a`. Indicies in `idxs` are indexed starting at 1.
collect = (a, idxs) ->
  _.map(idxs, (i) -> a[i-1])

String.prototype.to_vector = (delim = ' ') -> _.without(this.split(delim), "")

Array.prototype.print = (n) ->
  if n?
    that = []
    _.each(this, (e, i) ->
      that.push e
      that.push(' ') if (i+1) % n == 0
    )
    that.join('')
  else
    this.join('')
Array.prototype.peek = () -> this[this.length - 1]
Array.prototype.to_int = () -> _.map(this, (x) -> parseInt(x))

Array.prototype.split_into_parts = (n) ->
  that = this
  m = this.length / n
  splits = []
  _.times(n, (i) ->
    splits.push that.slice(m*i, m*(i+1))
  )
  splits

# Shifts the elements of the array left `i` times. `i` elements at the
# beginning of the array are placed at the end.
Array.prototype.left_shift = (i) ->
  this.slice(i).concat(this.slice(0, i))


## DES

des = (hs_k, hs_p) ->

  ### Helper stuff ###

  #### Permutation tables ####

  permutation_tables =
    # Permuted choice 1 (PC-1). 64 bits -> 56 bits.
    pc1: "57  49  41  33  25  17  9
          1   58  50  42  34  26  18
          10  2   59  51  43  35  27
          19  11  3   60  52  44  36
          63  55  47  39  31  23  15
          7   62  54  46  38  30  22
          14  6   61  53  45  37  29
          21  13  5   28  20  12  4"
    # Permuted choice 2 (PC-2). 56 bits -> 48 bits.
    pc2: "14  17  11  24  1   5
           3  28  15  6   21  10
          23  19  12  4   26  8
          16  7   27  20  13  2
          41  52  31  37  47  55
          30  40  51  45  33  48
          44  49  39  56  34  53
          46  42  50  36  29  32"
    # Initial permutation (IP). 64 bits -> 64 bits.
    ip: "58  50  42  34  26  18  10  2
         60  52  44  36  28  20  12  4
         62  54  46  38  30  22  14  6
         64  56  48  40  32  24  16  8
         57  49  41  33  25  17  9   1
         59  51  43  35  27  19  11  3
         61  53  45  37  29  21  13  5
         63  55  47  39  31  23  15  7"
    # Final permutation (IP^-1). Inverse of IP. 64 bits -> 64 bits.
    ipinv: "40  8   48  16  56  24  64  32
            39  7   47  15  55  23  63  31
            38  6   46  14  54  22  62  30
            37  5   45  13  53  21  61  29
            36  4   44  12  52  20  60  28
            35  3   43  11  51  19  59  27
            34  2   42  10  50  18  58  26
            33  1   41  9   49  17  57  25"
    # Expansion function (E). 32 bits -> 48 bits.
    e: "32  1   2   3   4   5
        4   5   6   7   8   9
        8   9   10  11  12  13
        12  13  14  15  16  17
        16  17  18  19  20  21
        20  21  22  23  24  25
        24  25  26  27  28  29
        28  29  30  31  32  1"
    # Permutation (P). 32 bits -> 32 bits.
    p: "16  7   20  21
        29  12  28  17
        1   15  23  26
        5   18  31  10
        2   8   24  14
        32  27  3   9
        19  13  30  6
        22  11  4   25"

  permutations = {}
  _.each(permutation_tables, (v, k) ->
    permutations[k] = (a) -> collect(a, v.to_vector())
  )

  #### Feistel function ####

  f = (rn1, kn) ->

    ##### Substition (S) boxes #####

    # FIXME: formatting
    s_boxes = ["14 4  13 1  2  15 11 8  3  10 6  12 5  9  0  7
                0  15 7  4  14 2  13 1  10 6  12 11 9  5  3  8
                4  1  14 8  13 6  2  11 15 12 9  7  3  1  5  0
                15 12 8  2  4  9  1  7  5  11 3  14 10 0  6  13".to_vector().to_int(),

               "15 1  8  14 6  11 3  4  9  7  2  13 12 0  5  10
                3  13 4  7  15 2  8  14 12 0  1  10 6  9  11 5
                0  14 7  11 10 4  13 1  5  8  12 6  9  3  2  15
                13 8  10 1  3  15 4  2  11 6  7  12 0  5  14 9".to_vector().to_int(),

               "10 0  9  14 6  3  15 5  1  13 12 7  11 4  2  8
                13 7  0  9  3  4  6  10 2  8  5  14 12 11 15 1
                13 6  4  9  8  15 3  0  11 1  2  12 5  10 14 7
                1 10  13 0  6  9  8  7  4  15 14 3  11 5  2  12".to_vector().to_int(),

               "7  13 14 3  0  6  9  10 1  2  8  5  11 12 4  15
                13 8  11 5  6  15 0  3  4  7  2  12 1  10 14 9
                10 6  9  0  12 11 7  13 15 1  3  14 5  2  8  4
                3  15 0  6  10 1  13 8  9  4  5  11 12 7  2 14".to_vector().to_int(),

               "2 12   4  1   7 10  11  6   8  5   3 15  13  0  14  9
                14 11   2 12   4  7  13  1   5  0  15 10   3  9   8  6
                4  2   1 11  10 13   7  8  15  9  12  5   6  3   0 14
                11  8  12  7   1 14   2 13   6 15   0  9  10  4   5  3".to_vector().to_int(),

               "12  1  10 15   9  2   6  8   0 13   3  4  14  7   5 11
                10 15   4  2   7 12   9  5   6  1  13 14   0 11   3  8
                9 14  15  5   2  8  12  3   7  0   4 10   1 13  11  6
                4  3   2 12   9  5  15 10  11 14   1  7   6  0   8 13".to_vector().to_int(),

               "4 11   2 14  15  0   8 13   3 12   9  7   5 10   6  1
                13  0  11  7   4  9   1 10  14  3   5 12   2 15   8  6
                1  4  11 13  12  3   7 14  10 15   6  8   0  5   9  2
                6 11  13  8   1  4  10  7   9  5   0 15  14  2   3 12".to_vector().to_int(),

               "13  2   8  4   6 15  11  1  10  9   3 14   5  0  12  7
                1 15  13  8  10  3   7  4  12  5   6 11   0 14   9  2
                7 11   4  1   9 12  14  2   0  6  10 13  15  3   5  8
                2  1  14  7   4 10   8 13  15 12   9  0   3  5   6 11".to_vector().to_int()
              ]

    # Looks up S box value for 6-digit binary array `b`.
    s = (iter, b) ->
      i = parseInt([b[0], b[5]].join(''), 2)
      j = parseInt([b[1], b[2], b[3], b[4]].join(''), 2)

      s_val = s_boxes[iter][16*i + j].toString(2)
      ("0000".slice(s_val.length) + s_val).split('').to_int()

    ##### Feistel algorithm #####

    # 1. Expansion (32 bits -> 48 bits)
    e = permutations.e(rn1)

    # 2. Key mixing
    x = xor(e, kn)

    # 3. Substitution
    sixes = x.split_into_parts(8)
    ss = _.flatten(_.map(sixes, (six, iter) -> s(iter, six)))

    # 4. Permutation
    permutations.p(ss)

  ### Algorithm ###

  log "k: #{hs_k}"
  log "p: #{hs_p}"

  # Binary arrays of key and plaintext.
  k = hex_to_bin_array hs_k
  p = hex_to_bin_array hs_p

  log "k: #{k.print(4)}"
  log "p: #{p.print(4)}"

  #### Create 16 48-bit subkeys ####

  # Apply PC-1 to the initial key. This reduces the 64-bit key into
  # 56-bits. Becasue we've done no other transformations on the key so far, this
  # effectively means 8 of the bits were useless; thus, the effective key-length
  # is 56, not 64.
  k_prime = permutations.pc1(k)
  log "k': #{k_prime.print(4)}"

  c = []
  d = []

  # Split the permuted key into two halves.
  c.push k_prime.slice(0, 28)
  d.push k_prime.slice(28)

  # Create 16 different intermediary half-keys by left-shifting the half-keys by
  # these increments.
  shift_schedule = "1122222212222221".to_vector('')
  _.each(shift_schedule, (shift) ->
    c.push c.peek().left_shift(shift)
    d.push d.peek().left_shift(shift)
  )
  log "shift schedule: #{shift_schedule.print()}"
  _.each(c, (ci, i) -> log "c#{i}: #{ci.print(4)}")
  _.each(d, (di, i) -> log "d#{i}: #{di.print(4)}")

  # Create the 16 final subkeys by combining the 16 different half-keys and then
  # applying PC-2. The left-shifting only made each subkey slightly different,
  # but when the slightly different subkeys are put through PC-2, they become
  # very different.
  ks = _.map(_.zip(c, d), (cd) -> permutations.pc2(cd[0].concat(cd[1])))
  _.each(ks, (ki, i) -> log "k#{i}: #{ki.print(4)}")

  #### Initial permutation ####

  ip = permutations.ip(p)
  log "ip: #{ip.print(4)}"

  #### Rounds ####

  l = []
  r = []

  # Split the permuted block into two halves.
  l.push ip.slice(0, 32)
  r.push ip.slice(32)

  # Perform each round.
  # L_n = R_{n-1}
  # R_n = L_{n-1} + f(R_{n-1}, K_n)
  _.times(16, (n) ->
    l.push r.peek()
    r.push xor(l.peek(), f(r.peek(), ks[n]))
  )

  _.each(l, (li, i) -> log "l#{i}: #{li.print(4)}")
  _.each(r, (ri, i) -> log "r#{i}: #{ri.print(4)}")

  #### Final permutation ####

  ip1 = permutations.ipinv r.peek().concat(l.peek())
  log "ip^{-1}: #{ip1.print(4)}"

  # Convert back to hex.
  return bin_array_to_hex ip1


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
    # Set defaults
    $("#key").val("133457799BBCDFF1")
    $("#plaintext").val("0123456789ABCDEF")
