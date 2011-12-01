root = exports ? this

$(document).ready ->

  log = (x) -> console.log(x)

  # Determine if all characters in `str` are hex.
  all_hex = (str) ->
    _.all(str.split(""), (s) ->
      if s == s.toLowerCase()
        "0" < s < "f"
      else
        "0" < s < "F"
    )

  # Converts a hex string to a (big endian) binary string.
  hex_to_bin = (hs) ->
    log("INVALID HEX STRING") unless all_hex(hs)
    parseInt(hs, 16).toString(2)

  # Xor on two binary strings.
  xor = (bs1, bs2) ->
    console.log("XORING STRINGS OF DIFFERENT LENGTHS") unless bs1.length == bs2.length
    _.map( _.zip(bs1.split(''), bs2.split('')), (x) -> x[0] ^ x[1]).join('')

  # DES implementation.
  des = (k, p) ->
    p

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
      $("#error").text val
    else
      $("#ciphertext").text des(k, p)

