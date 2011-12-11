root = exports ? this


## Settings

DEBUG = true


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
