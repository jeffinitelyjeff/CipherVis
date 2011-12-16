root = exports ? this

DEFAULT_T = 1000

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

## Display helpers ##

# Reveal a step by sliding it up.
show = ($d, id, callback, t = show.default_t) ->
  $d.find(id).fadeIn(t).children(".spacer").slideUp(t, callback)
show.default_t = DEFAULT_T

# Reveal a step and contained code.
show_code = ($d, id, callback, t = show.default_t, t2 = show_code.default_t2) ->
  show $d, id, ( ->
    $d.find(id).find(".code_line").fadeIn(t2, callback)
    callback()
  ), t
show_code.default_t2 = show.default_t / 2

# Handles placing text in code boxes such that it's spaced properly (does this
# by actually inserting several spans).
insert = ($d, id, cl, text, num) ->
  if root.utils.is_string(text)
    text = text.split('')
  words = text.print(num).split(' ')
  spans = _.map(words, (word) ->
    $("<span></span>").addClass("word").text(word).get(0)
  )
  $d.find(id).find(cl).empty().append(spans)
  $(spans).show()

## Display steps ##

display_des = ($d, res, callback) ->
  populate_data($d, res)
  show_binary($d, res, callback)

populate_data = ($d, res) ->
  insert $d, "#binary", ".one", res.p_hex, 1
  insert $d, "#binary", ".two", res.p, 4

  insert $d, "#ip", ".one", res.p, 4
  insert $d, "#ip", ".two", res.ip, 4

  insert $d, "#pc1", ".one", res.k, 4
  insert $d, "#pc1", ".two", res.k_pc1, 4

  insert $d, "#split-key", ".one", res.cd[0].slice(0, 28), 4
  insert $d, "#split-key", ".two", res.cd[0].slice(28), 4

  _.times(16, (i) ->
    insert $d, "#shift#{i+1}", ".one", res.cd[i+1].slice(0, 28), 4
    insert $d, "#shift#{i+1}", ".two", res.cd[i+1].slice(28), 4
    insert $d, "#shift#{i+1}", ".three", res.ks[i], 4
  )

  insert $d, "#split", ".one", res.l[0], 4
  insert $d, "#split", ".two", res.r[0], 4

  _.times(16, (i) ->
    insert $d, "#round#{i+1}", ".one", res.l[i+1], 4
    insert $d, "#round#{i+1}", ".two", res.r[i+1], 4
  )

show_binary = ($d, res, callback) ->
  show_code $d, "#binary", -> show_ip($d, res, callback)

show_ip = ($d, res, callback) ->
  show_code $d, "#ip", -> show_subkeys($d, res, callback)

show_subkeys = ($d, res, callback) ->
  show $d, "#subkeys", -> show_pc1($d, res, callback)

show_pc1 = ($d, res, callback) ->
  $("#subkey-list").show()
  show_code $d, "#pc1", -> show_split_key($d, res, callback)

show_split_key = ($d, res, callback) ->
  show_code $d, "#split-key", -> show_shifts($d, res, callback)

show_shifts = ($d, res, callback) ->
  show $d, "#shifts", -> show_shift(1, $d, res, callback)

show_shift = (i, $d, res, callback) ->
  if i == 16
    f = -> show_split($d, res, callback)
  else
    f = -> show_shift(i+1, $d, res, callback)

  t = show.default_t

  $d.find("#shift#{i}").fadeIn(t / 2, ->
    $d.find("#shift#{i}").children(".pc2_container").slideDown(t / 4, f)
  )

show_split = ($d, res, callback) ->
  show_code $d, "#split", -> show_rounds($d, res, callback)

show_rounds = ($d, res, callback) ->
  show $d, "#rounds", -> show_round(1, $d, res, callback)

show_round = (i, $d, res, callback) ->
  if i == 16
    f = -> return # FIXME: next step
  else
    f = -> show_round(i+1, $d, res, callback)

  t = show.default_t

  $d.find("#round#{i}").fadeIn(t / 2, f)
