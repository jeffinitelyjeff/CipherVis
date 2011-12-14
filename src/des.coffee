root = exports ? this

log = root.utils.log
_.each(root.str, (f, name) -> String.prototype[name] = f)
_.each(root.arr, (f, name) -> Array.prototype[name] = f)

# Data Encryption Standard (DES) implementation.

## Tables ##

### Permutations tables ###
_({

    # Permuted choice 1 (PC-1). 64 bits --> 56 bits.
    pc1: "57  49  41  33  25  17   9
           1  58  50  42  34  26  18
          10   2  59  51  43  35  27
          19  11   3  60  52  44  36
          63  55  47  39  31  23  15
           7  62  54  46  38  30  22
          14   6  61  53  45  37  29
          21  13   5  28  20  12   4"

    # Permuted choice 2 (PC-2). 56 bits --> 48 bits.
    pc2: "14  17  11  24   1   5
           3  28  15   6  21  10
          23  19  12   4  26   8
          16   7  27  20  13   2
          41  52  31  37  47  55
          30  40  51  45  33  48
          44  49  39  56  34  53
          46  42  50  36  29  32"

    # Initial permutation (IP). 64 bits --> 64 bits.
    ip: "58  50  42  34  26  18  10  2
         60  52  44  36  28  20  12  4
         62  54  46  38  30  22  14  6
         64  56  48  40  32  24  16  8
         57  49  41  33  25  17   9  1
         59  51  43  35  27  19  11  3
         61  53  45  37  29  21  13  5
         63  55  47  39  31  23  15  7"

    # Final permutation (IP^-1). Inverse of IP. 64 bits --> 64 bits.
    ipinv: "40  8  48  16  56  24  64  32
            39  7  47  15  55  23  63  31
            38  6  46  14  54  22  62  30
            37  5  45  13  53  21  61  29
            36  4  44  12  52  20  60  28
            35  3  43  11  51  19  59  27
            34  2  42  10  50  18  58  26
            33  1  41   9  49  17  57  25"

    # Expansion function (E). 32 bits --> 48 bits.
    e: "32   1   2   3   4   5
         4   5   6   7   8   9
         8   9  10  11  12  13
        12  13  14  15  16  17
        16  17  18  19  20  21
        20  21  22  23  24  25
        24  25  26  27  28  29
        28  29  30  31  32   1"

    # Permutation (P). 32 bits --> 32 bits.
    p: "16   7  20  21
        29  12  28  17
         1  15  23  26
         5  18  31  10
         2   8  24  14
        32  27   3   9
        19  13  30   6
        22  11   4  25"

# Allow us to easily apply permutations like `k.perm_pc1()`.
}).each((v,k) -> Array.prototype["perm_#{k}"] = () -> this.collect(v.to_vector()))


### Substitution tables ###
s_boxes = _([
                # s1
      "14  4 13  1  2 15 11  8  3 10  6 12  5  9  0  7
        0 15  7  4 14  2 13  1 10  6 12 11  9  5  3  8
        4  1 14  8 13  6  2 11 15 12  9  7  3  1  5  0
       15 12  8  2  4  9  1  7  5 11  3 14 10  0  6 13"

                # s2
      "15  1  8 14  6 11  3  4  9  7  2 13 12  0  5 10
        3 13  4  7 15  2  8 14 12  0  1 10  6  9 11  5
        0 14  7 11 10  4 13  1  5  8 12  6  9  3  2 15
       13  8 10  1  3 15  4  2 11  6  7 12  0  5 14  9"

                # s3
      "10  0  9 14  6  3 15  5  1 13 12  7 11  4  2  8
       13  7  0  9  3  4  6 10  2  8  5 14 12 11 15  1
       13  6  4  9  8 15  3  0 11  1  2 12  5 10 14  7
        1 10 13  0  6  9  8  7  4 15 14  3 11  5  2 12"

                # s4
      " 7 13 14  3  0  6  9 10  1  2  8  5 11 12  4 15
       13  8 11  5  6 15  0  3  4  7  2 12  1 10 14  9
       10  6  9  0 12 11  7 13 15  1  3 14  5  2  8  4
        3 15  0  6 10  1 13  8  9  4  5 11 12  7  2 14"

                # s5
      " 2 12  4  1  7 10 11  6  8  5  3 15 13  0 14  9
       14 11  2 12  4  7 13  1  5  0 15 10  3  9  8  6
        4  2  1 11 10 13  7  8 15  9 12  5  6  3  0 14
       11  8 12  7  1 14  2 13  6 15  0  9 10  4  5  3"

                # s6
      "12  1 10 15  9  2  6  8  0 13  3  4 14  7  5 11
       10 15  4  2  7 12  9  5  6  1 13 14  0 11  3  8
        9 14 15  5  2  8 12  3  7  0  4 10  1 13 11  6
        4  3  2 12  9  5 15 10 11 14  1  7  6  0  8 13"

                # s7
      " 4 11  2 14 15  0  8 13  3 12  9  7  5 10  6  1
       13  0 11  7  4  9  1 10 14  3  5 12  2 15  8  6
        1  4 11 13 12  3  7 14 10 15  6  8  0  5  9  2
        6 11 13  8  1  4 10  7  9  5  0 15 14  2  3 12"

                # s8
      "13  2  8  4  6 15 11  1 10  9  3 14  5  0 12  7
        1 15 13  8 10  3  7  4 12  5  6 11  0 14  9  2
        7 11  4  1  9 12 14  2  0  6 10 13 15  3  5  8
        2  1 14  7  4 10  8 13 15 12  9  0  3  5  6 11"

# Clean each box into an array.
]).map((box) -> box.to_vector())


## Functions ##

### Substitution functions ###

# Given s-box number `n` (0-indexed), row `r`, nad column `c`, returns the
# binary string of the value at that position of the specified s-box.
get_s_box = (n, r, c) -> s_boxes[n][16*r + c].toString(2)

# Looks up S box value for 6-digit binary array `b`.
lookup_s_box = (n, b) ->

  # Get the row in the s-box.
  i = parseInt([b[0], b[5]].join(''), 2)

  # Get the column in the s-box.
  j = parseInt([b[1], b[2], b[3], b[4]].join(''), 2)

  return get_s_box(n, i, j).pad(4).to_vector('')


### Feistel function ###

# Given the right half of a round `r` and the next subkey `k`, compute the
# Fiestel function (which will be xor'ed with `r`'s matching left half to
# generate the next right half).
feistel = (r, k) ->

  # Expansion (32 bits --> 48 bits).
  e = r.perm_e()

  # Key mixing.
  x = e.xor(k)

  # Substitution (48 bits --> 32 bits).
  sixes = x.into_parts(8)
  ss = _.flatten(_.map(sixes, (six, iter) -> lookup_s_box(iter, six)))

  # Permutation (32 bits --> 32 bits).
  return ss.perm_p()


### Subkey generation ###

# Creates 16 different subkeys given the one main key `k`.
subkeys = (k) ->

  # Apply PC-1 to the key.
  # Because PC-1 is 64-bit -> 56-bit and we've done no obfuscating
  # transformations yet, this means the effective key-length is 56-bits.
  k_prime = k.perm_pc1()
  log "k': #{k_prime.print(4)}" # FIXME

  # We generate the subkeys in parallel halves.
  [c, d] = [[], []]

  # We treat the PC1ed key as the 0th subkey for convenience.
  c.push k_prime.slice(0, 28)
  d.push k_prime.slice(28)

  # We will generate the half-subkeys by left-shifting the previous half-subkey
  # by the amount dictated by this shedule (i.e., the 1st is a left-shift of the
  # 0th by 1, the 2nd a left-shift of the 1st by 1, the 3rd a left-shift of the
  # 2nd by 2, etc.)
  shift_schedule = "1122222212222221".to_int_a('')
  _.each(shift_schedule, (n) ->
    c.push c.peek().shift_left(n)
    d.push d.peek().shift_left(n)
  )
  log "shift schedule: #{shift_schedule.print()}" # FIXME
  _.each(c, (ci, i) -> log "c#{i}: #{ci.print(4)}") # FIXME
  _.each(d, (di, i) -> log "d#{i}: #{di.print(4)}") # FIXME

  # We create the 16 final subkeys by putting the half-keys together and
  # applying PC-2. By left-shifting each subkey, we only varied them a little,
  # but that difference is magnified by PC-2.
  ks = _.map(_.zip(c, d), (cd) -> cd[0].concat(cd[1]).perm_pc2())
  _.each(ks, (ki, i) -> log "k#{i}: #{ki.print(4)}") # FIXME

  # Because we treated the un-shifted PC1ed key as the 0th subkey and then
  # shifted 16 times, we ended up with 17 keys. We don't actually want to treat
  # `k[0]` as a key.
  return ks.slice(1)

### Rounds ###

# Performs the 16 rounds on the initial permutation using the 16 subkeys.
# Splits the initial permutation into halves and then creates subsequent rounds
# by:
#
#   - _L\_n = R\_{n-1}_
#   - _R\_n = L\_{n-1} + f(R\_{n-1}, K\_n)_
#
# Returns the results of the final round appended backwards (RL).
rounds = (ip, ks) ->

  # Initialize the halves with the initial permutation (64-bits) split in half.
  [l, r] = [[ip.slice(0, 32)], [ip.slice(32)]]

  _.times(16, (i) ->
    l.push r.peek()
    r.push l.peek().xor(feistel(r.peek(), ks[i]))
  )

  _.each(l, (li, i) -> log "l#{i}: #{li.print(4)}") # FIXME
  _.each(r, (ri, i) -> log "r#{i}: #{ri.print(4)}") # FIXME

  return r.peek().concat(l.peek())


## Algorithm ##


des = (k_hex, p_hex) ->

  log "k: #{k_hex}" # FIXME
  log "p: #{p_hex}" # FIXME

  # Hex --> binary.
  k = k_hex.to_bin_array()
  p = p_hex.to_bin_array()

  log "k: #{k.print(4)}" # FIXME
  log "p: #{p.print(4)}" # FIXME

  # Initial permutation (64 bits --> 64 bits).
  ip = p.perm_ip()
  log "ip: #{ip.print(4)}" # FIXME

  # Generate subkeys.
  ks = subkeys(k)

  # Perform rounds.
  rounded = rounds(ip, ks)

  # Final permutation (64 bits --> 64 bits).
  ip1 = rounded.perm_ip1()
  log "ip^{-1}: #{ip1.print(4)}" # FIXME

  # Binary -> hex.
  return ip1.to_hex()


# Export DES.
root.des = des

# Export stuff for testing.
root.get_s_box = get_s_box
root.lookup_s_box = lookup_s_box
root.feistel = feistel
root.subkeys = subkeys
root.rounds = rounds
