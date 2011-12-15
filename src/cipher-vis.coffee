root = exports ? this

log = root.utils.log
_.each(root.str, (f, name) -> String.prototype[name] = f)
_.each(root.arr, (f, name) -> Array.prototype[name] = f)
des = root.des

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
    else unless str.is_hex()
      "non-hex chars in #{name}"
    else
      ""

  k_msg = generic_validate("key", key)
  p_msg = generic_validate("plaintext", plain)

  if k_msg
    if p_msg
      "#{k_msg.caps()}; #{p_msg}"
    else
      k_msg.caps()
  else
    if p_msg
      p_msg.caps()
    else
      ""


$(document).ready ->

  results = {}

  # Run DES when the arrows are clicked.
  $("#encipher").click ->
    k = $("#key").val()
    p = $("#plaintext").val()

    val = validate(k, p)

    if val
      $("#error").text(val).fadeIn(500)
      results = {}
    else
      $("#error").fadeOut(500, () -> $(this).text(""))

      results = des(k, p)
      $("#ciphertext").text results.c_hex

      display_des($("#display"), results, -> return)

  $("#plaintext, #key").keydown (e) -> $("#encipher").click() if e.keyCode == 13

  if DEBUG
    # Set defaults
    $("#key").val("3B3898371520F75E")
    $("#plaintext").val("0123456789ABCDEF")

show = ($d, id, callback) ->
  t = 500
  $d.find(id).fadeIn(t).children(".step").fadeIn(t).end()
    .children(".spacer").slideUp(t, callback)

display_des = ($d, res, callback) ->
  display_des_binary($d, res, callback)

display_des_binary = ($d, res, callback) ->
  show($d, "#binary", -> display_des_ip($d, res, callback))

display_des_ip = ($d, res, callback) ->
  show($d, "#ip", -> display_des_subkeys($d, res, callback))

display_des_subkeys = ($d, res, callback) ->
  show($d, "#subkeys", -> display_des_pc1($d, res, callback))

display_des_pc1 = ($d, res, callback) ->
  show($d, "#subkeys", -> return)


