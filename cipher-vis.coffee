root = exports ? this

$(document).ready ->

  ## Settings

  DEBUG = false

  ## Misc. Utilities

  String.prototype.reverse = () -> this.split('').reverse().join('')

  is_string = (s) -> typeof s == "string"

  is_array = (a) -> $.isArray(a)

  log = (x) -> console.log(x)

  # Determine if all characters in `str` are hex.
  all_hex = (str) ->
    _.all(str.split(""), (s) ->
      if s == s.toLowerCase()
        "0" < s < "f"
      else
        "0" < s < "F"
    )

  # Determine if all characters in array `a` are binary (`0` or `1`).
  all_bin = (a) ->
    log "all_bin called with non-array argument" unless $.isArray(a)
    _.all(a, (d) -> d == 0 or d == 1)


  ## Conversion Functions

  # Converts a hex string to a (little endian) binary string.
  hexs_to_bins = (hs) ->
    log("INVALID HEX STRING") unless all_hex(hs)

    # parseInt will return a big endian binary string, so we have to reverse it.
    parseInt(hs, 16).toString(2)

  # Converts a hex string to a (little endian) binary array.
  hexs_to_bina = (hs) ->
    _.map(hexs_to_bins(hs).split(''), (i_s) -> parseInt(i_s))


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

  String.prototype.to_idx_table = () -> _.without(this.split(' '), "")

  Array.prototype.print = () -> this.join('')

  Array.prototype.left_shift = () ->
    ...


  ## DES

  des = (hs_k, hs_p) ->

    log "k: #{hs_k}"
    log "p: #{hs_p}"

    # Binary arrays of key and plaintext.
    k = hexs_to_bina hs_k
    p = hexs_to_bina hs_p

    log "k: #{k.print()}"
    log "p: #{p.print()}"

    ### Create subkeys ###
    # We generate 16 48-bit subkeys.

    # PC-1
    pc1 = (a) ->
      table = "57  49  41  33  25  17   9
                1  58  50  42  34  26  18
               10   2  59  51  43  35  27
               19  11   3  60  52  44  36
               63  55  47  39  31  23  15
                7  62  54  46  38  30  22
               14   6  61  53  45  37  29
               21  13   5  28  20  12   4".to_idx_table()

      collect(a, table)

    # 56-bit permutation of k.
    k_prime = pc1(k)
    log "k': #{k_prime.print()}"

    # Split permuted key into two halves.
    c0 = k_prime.slice(0, 28)
    c1 = k_prime.slice(28)
    log "c0: #{c0.print()}"
    log "c1: #{c1.print()}"











  # Validate the key and plaintext; return error if etiher fails to validate.
  validate = (key, plain) ->

    generic_validate = (name, str) ->

      if str == ""
        "#{name} empty"
      else if str.length < 32
        "#{name} too short"
      else if str.length > 32
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

  # Run DES when the arrows are clicked.
  $("#encipher").click ->
    k = $("#key").val()
    p = $("#plaintext").val()

    val = validate(k, p)

    if val
      $("#error").text(val).fadeIn(500)
    else
      $("#error").fadeOut(500, () -> $(this).text(val))
      $("#ciphertext").text des(k, p)

