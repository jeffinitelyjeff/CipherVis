root = exports ? this

_.each(root.str, (f, name) -> String.prototype[name] = f)
_.each(root.arr, (f, name) -> Array.prototype[name] = f)

String.prototype.clean = () -> this.split(' ').join('').to_int_a()

describe "Permutations", ->

  describe "PC1", ->

    it "should work with this example", ->

      # Example from http://orlingrabbe.com/des.htm

      a = "00010011 00110100 01010111 01111001 10011011 10111100 11011111 11110001".clean()
      b = "1111000 0110011 0010101 0101111 0101010 1011001 1001111 0001111".clean()

      expect(a.perm_pc1()).toEqual b

  describe "PC2", ->

    # Examples from http://orlingrabbe.com/des.htm

    it "should work with this example", ->

      a = "1110000 1100110 0101010 1011111 1010101 0110011 0011110 0011110".clean()
      b = "000110 110000 001011 101111 111111 000111 000001 110010".clean()
      expect(a.perm_pc2()).toEqual b

    it "should work with this example", ->

      a = "11000011001100101010101111110101010110011001111000111101".clean()
      b = "011110 011010 111011 011001 110110 111100 100111 100101".clean()
      expect(a.perm_pc2()).toEqual b

    it "should work with this example", ->

      a = "00001100110010101010111111110101011001100111100011110101".clean()
      b = "010101 011111 110010 001010 010000 101100 111110 011001".clean()
      expect(a.perm_pc2()).toEqual b

    it "should work with this example", ->

      a = "00110011001010101011111111000101100110011110001111010101".clean()
      b = "011100 101010 110111 010110 110110 110011 010100 011101".clean()
      expect(a.perm_pc2()).toEqual b

  describe "IP", ->

    it "should work with this example", ->

      # Example from http://orlingrabbe.com/des.htm

      a = "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111".clean()
      b = "1100 1100 0000 0000 1100 1100 1111 1111 1111 0000 1010 1010 1111 0000 1010 1010".clean()
      expect(a.perm_ip()).toEqual b

  describe "E", ->

    it "should work with this example", ->

      # Example from http://orlingrabbe.com/des.htm

      a = "1111 0000 1010 1010 1111 0000 1010 1010".clean()
      b = "011110 100001 010101 010101 011110 100001 010101 010101".clean()
      expect(a.perm_e()).toEqual b

    it "should work with these other examples", ->

      # Example from http://people.eku.edu/styere/Encrypt/JS-DES.html

      a1 = "11111111 10011010 11111111 11111111".clean()
      b1 = "111111 111111 110011 110101 011111 111111 111111 111111".clean()
      expect(a1.perm_e()).toEqual b1

      a2 = "01110010 00001011 11010101 01111001".clean()
      b2 = "101110 100100 000001 010111 111010 101010 101111 110010".clean()
      expect(a2.perm_e()).toEqual b2

      a3 = "10110110 01111011 11001000 11101110".clean()
      b3 = "010110 101100 001111 110111 111001 010001 011101 011101".clean()
      expect(a3.perm_e()).toEqual b3


  describe "P", ->

    it "should work with this example", ->

      # Example from http://orlingrabbe.com/des.htm

      a = "0101 1100 1000 0010 1011 0101 1001 0111".clean()
      b = "0010 0011 0100 1010 1010 1001 1011 1011".clean()
      expect(a.perm_p()).toEqual b

  describe "IPINV", ->

    it "should work with this example", ->

      # Example from http://orlingrabbe.com/des.htm

      a = "00001010 01001100 11011001 10010101 01000011 01000010 00110010 00110100".clean()
      b = "10000101 11101000 00010011 01010100 00001111 00001010 10110100 00000101".clean()
      expect(a.perm_ipinv()).toEqual b


describe "Subkey Generation", ->

  it "should work with this example", ->

    # Example from http://orlingrabbe.com/des.htm

    expected_ks = _([
      "000110 110000 001011 101111 111111 000111 000001 110010",
      "011110 011010 111011 011001 110110 111100 100111 100101",
      "010101 011111 110010 001010 010000 101100 111110 011001",
      "011100 101010 110111 010110 110110 110011 010100 011101",
      "011111 001110 110000 000111 111010 110101 001110 101000",
      "011000 111010 010100 111110 010100 000111 101100 101111",
      "111011 001000 010010 110111 111101 100001 100010 111100",
      "111101 111000 101000 111010 110000 010011 101111 111011",
      "111000 001101 101111 101011 111011 011110 011110 000001",
      "101100 011111 001101 000111 101110 100100 011001 001111",
      "001000 010101 111111 010011 110111 101101 001110 000110",
      "011101 010111 000111 110101 100101 000110 011111 101001",
      "100101 111100 010111 010001 111110 101011 101001 000001",
      "010111 110100 001110 110111 111100 101110 011100 111010",
      "101111 111001 000110 001101 001111 010011 111100 001010",
      "110010 110011 110110 001011 000011 100001 011111 110101"
    ]).map((s) -> s.clean())

    k = "00010011 00110100 01010111 01111001 10011011 10111100 11011111 11110001".clean()

    expect(root.subkeys(k)).toEqual expected_ks

  it "should work with this other example", ->

    k = "3b3898371520f75e".to_ba()

    ks = _([
      "010111 000000 100001 001100 010101 011000 111101 001111",
      "010100 010010 110111 110000 011001 001001 011111 001100",
      "110101 001110 010010 000101 110110 001011 010011 101111",
      "010100 111000 011100 000110 011011 101101 111010 101001",
      "011010 001001 000010 100111 000110 100111 110101 111011",
      "101100 011000 000001 101110 101011 111101 100100 110000",
      "101000 000100 001010 110010 110000 010110 111101 110010",
      "101101 000001 101100 110100 111111 011000 101000 011100",
      "001000 101101 110101 000010 100100 111000 011001 111100",
      "011010 000110 000101 010111 110110 011011 111110 000100",
      "001001 011100 010100 011001 001110 000110 011010 111101",
      "010001 110000 000110 110011 011110 110111 100010 000111",
      "101111 111000 100010 010001 101001 100110 000110 111011",
      "000111 110010 001010 001010 101001 110011 101101 000111",
      "001110 100001 010010 011100 111101 101000 001111 110010",
      "000100 010111 110010 000001 110101 111110 000101 001110"
    ]).map((s) -> s.clean())

    expect(root.subkeys(k)).toEqual ks

describe "Rounds", ->

  describe "Feistel Function", ->

    describe "S-Box Lookup", ->

      it "should work for this example", ->

        # Example from http://orlingrabbe.com/des.htm

        as = "011000 010001 011110 111010 100001 100110 010100 100111"
        as = _.map(as.split(' '), (a) -> a.to_int_a())

        bs = "0101 1100 1000 0010 1011 0101 1001 0111"
        bs = _.map(bs.split(' '), (b) -> b.to_int_a())

        expect(lookup_s_box(0, as[0])).toEqual bs[0]
        expect(lookup_s_box(1, as[1])).toEqual bs[1]
        expect(lookup_s_box(2, as[2])).toEqual bs[2]
        expect(lookup_s_box(3, as[3])).toEqual bs[3]
        expect(lookup_s_box(4, as[4])).toEqual bs[4]
        expect(lookup_s_box(5, as[5])).toEqual bs[5]
        expect(lookup_s_box(6, as[6])).toEqual bs[6]
        expect(lookup_s_box(7, as[7])).toEqual bs[7]

      describe "another example", ->

        # Example from http://people.eku.edu/styere/Encrypt/JS-DES.html

        bs = _.map("111010 110110 110110 100111 100011 100011 110000 111110".split(' '), (s) -> s.to_int_a())
        ss = _.map("1010 0110 1100 0110 1000 0011 1010 1000".split(' '), (s) -> s.to_int_a())

        box = root.lookup_s_box

        it "should get the 1st sbox", -> expect(box(0, bs[0])).toEqual ss[0]
        it "should get the 2nd sbox", -> expect(box(1, bs[1])).toEqual ss[1]
        it "should get the 3rd sbox", -> expect(box(2, bs[2])).toEqual ss[2]
        it "should get the 4th sbox", -> expect(box(3, bs[3])).toEqual ss[3]
        it "should get the 5th sbox", -> expect(box(4, bs[4])).toEqual ss[4]
        it "should get the 6th sbox", -> expect(box(5, bs[5])).toEqual ss[5]

      describe "another example", ->

        # Example from http://people.eku.edu/styere/Encrypt/JS-DES.html
        #
        bs = _.map("100011 100010 011101 110010 001111 011010 001110 110010".split(' '), (s) -> s.to_int_a())
        ss = _.map("1100 1110 1111 0001 0001 0111 1101 0110".split(' '), (s) -> s.to_int_a())

        box = root.lookup_s_box

        it "should get the 1st sbox", -> expect(box(0, bs[0])).toEqual ss[0]
        it "should get the 2nd sbox", -> expect(box(1, bs[1])).toEqual ss[1]
        it "should get the 3rd sbox", -> expect(box(2, bs[2])).toEqual ss[2]
        it "should get the 4th sbox", -> expect(box(3, bs[3])).toEqual ss[3]
        it "should get the 5th sbox", -> expect(box(4, bs[4])).toEqual ss[4]
        it "should get the 6th sbox", -> expect(box(5, bs[5])).toEqual ss[5]


    it "should work for this example", ->

      # Example from http://orlingrabbe.com/des.htm

      r0 = "1111 0000 1010 1010 1111 0000 1010 1010".clean()
      k1 = "000110 110000 001011 101111 111111 000111 000001 110010".clean()
      f = "0010 0011 0100 1010 1010 1001 1011 1011".clean()

      expect(feistel(r0, k1)).toEqual f

  it "should do the first round correctly for this example", ->

    # Example from http://orlingrabbe.com/des.htm

    l0 = "1100 1100 0000 0000 1100 1100 1111 1111".clean()
    r0 = "1111 0000 1010 1010 1111 0000 1010 1010".clean()
    k1 = "000110 110000 001011 101111 111111 000111 000001 110010".clean()

    r1 = "1110 1111 0100 1010 0110 0101 0100 0100".clean()

    expect(l0.xor(feistel(r0, k1))).toEqual r1

  it "should do the first round correctly for this other example", ->

    # Example from http://people.eku.edu/styere/Encrypt/JS-DES.html

    l0 = "11001100 00000000 11001100 11111111".clean()
    r0 = "11110000 10101010 11110000 10101010".clean()
    k1 = "010111 000000 100001 001100 010101 011000 111101 001111".clean()

    r1 = "01101100 10111100 00001110 01100010".clean()

    expect(l0.xor(feistel(r0, k1))).toEqual r1

  it "should do the second round correctly for this example", ->

    # Example from http://people.eku.edu/styere/Encrypt/JS-DES.html

    l1 = "11110000 10101010 11110000 10101010".clean()
    r1 = "01101100 10111100 00001110 01100010".clean()
    k2 = "010100 010010 110111 110000 011001 001001 011111 001100".clean()

    r2 = "10000111 00101101 11010101 10000000".clean()


  it "should work for this example", ->

    # Example from http://orlingrabbe.com/des.htm

    ip = "11001100 00000000 11001100 11111111 11110000 10101010 11110000 10101010".clean()
    k = "00111011 00111000 10011000 00110111 00010101 00100000 11110111 01011110".clean()
    ks = root.subkeys(k)

    lr16 = "00111000 11111110 11111000 00001110 00100101 01111111 01110111 00011001".clean()

    expect(rounds(ip, ks)).toEqual lr16

describe "Intermediary Results", ->

  describe "test example 1", ->

    # Testing against data from http://people.eku.edu/styere/Encrypt/JS-DES.html

    plain = "CABBCAAAABCBCABB"
    key = "3B3898371520F75E"
    r = des(key, plain)

    it "should get the right input", ->
      expect(r.p_hex).toEqual plain
      expect(r.k_hex).toEqual key

    it "should get the right bin input", ->
      p = "11001010 10111011 11001010 10101010 10101011 11001011 11001010 10111011".clean()
      k = "00111011 00111000 10011000 00110111 00010101 00100000 11110111 01011110".clean()
      expect(r.p).toEqual p
      expect(r.k).toEqual k

    it "should get the initial permutation right", ->
      ip = "01100101 10000010 00000000 10110010 11111111 10011010 11111111 11111111".clean()
      expect(r.ip).toEqual ip

    it "should get the shifted subkeys right", ->
      cd = _.map([
        "0100010 0110000 0001101 0111101 1100100 1110110 0010000 1111111",
        "1000100 1100000 0011010 1111010 1001001 1101100 0100001 1111111",
        "0001001 1000000 0110101 1110101 0010011 1011000 1000011 1111111",
        "0100110 0000001 1010111 1010100 1001110 1100010 0001111 1111100",
        "0011000 0000110 1011110 1010001 0111011 0001000 0111111 1110010",
        "1100000 0011010 1111010 1000100 1101100 0100001 1111111 1001001",
        "0000000 1101011 1101010 0010011 0110001 0000111 1111110 0100111",
        "0000011 0101111 0101000 1001100 1000100 0011111 1111001 0011101",
        "0001101 0111101 0100010 0110000 0010000 1111111 1100100 1110110",
        "0011010 1111010 1000100 1100000 0100001 1111111 1001001 1101100",
        "1101011 1101010 0010011 0000000 0000111 1111110 0100111 0110001",
        "0101111 0101000 1001100 0000011 0011111 1111001 0011101 1000100",
        "0111101 0100010 0110000 0001101 1111111 1100100 1110110 0010000",
        "1110101 0001001 1000000 0110101 1111111 0010011 1011000 1000011",
        "1010100 0100110 0000001 1010111 1111100 1001110 1100010 0001111",
        "1010001 0011000 0000110 1011110 1110010 0111011 0001000 0111111",
        "0100010 0110000 0001101 0111101 1100100 1110110 0010000 1111111"
      ], (s) -> s.clean())
      expect(r.cd.length).toEqual cd.length
      _.times(cd.length, (i) -> expect(r.cd[i]).toEqual cd[i])

    it "should get the real subkeys right", ->
      ks = _.map([
        "010111 000000 100001 001100 010101 011000 111101 001111",
        "010100 010010 110111 110000 011001 001001 011111 001100",
        "110101 001110 010010 000101 110110 001011 010011 101111",
        "010100 111000 011100 000110 011011 101101 111010 101001",
        "011010 001001 000010 100111 000110 100111 110101 111011",
        "101100 011000 000001 101110 101011 111101 100100 110000",
        "101000 000100 001010 110010 110000 010110 111101 110010",
        "101101 000001 101100 110100 111111 011000 101000 011100",
        "001000 101101 110101 000010 100100 111000 011001 111100",
        "011010 000110 000101 010111 110110 011011 111110 000100",
        "001001 011100 010100 011001 001110 000110 011010 111101",
        "010001 110000 000110 110011 011110 110111 100010 000111",
        "101111 111000 100010 010001 101001 100110 000110 111011",
        "000111 110010 001010 001010 101001 110011 101101 000111",
        "001110 100001 010010 011100 111101 101000 001111 110010",
        "000100 010111 110010 000001 110101 111110 000101 001110"
      ], (s) -> s.clean())
      expect(r.ks.length).toEqual ks.length
      _.times(ks.length, (i) -> expect(r.ks[i]).toEqual ks[i])

    describe "first round", ->
      e = "111111 111111 110011 110101 011111 111111 111111 111111".clean()
      k = "010111 000000 100001 001100 010101 011000 111101 001111".clean()
      xor = "101000 111111 010010 111001 001010 100111 000010 110000".clean()
      sbox = "1101 1001 1101 1100 1010 1100 1011 0000".clean()
      p = "00010111 10001001 11010101 11001011".clean()
      left = "11111111 10011010 11111111 11111111".clean()
      right = "01110010 00001011 11010101 01111001".clean()

      it "should get e right",     -> expect(r.es[0]).toEqual e
      it "should get k right",     -> expect(r.ks[0]).toEqual k
      it "should get mix right",   -> expect(r.mixes[0]).toEqual xor
      it "should get sbox right",  -> expect(r.sboxes[0]).toEqual sbox
      it "should get p right",     -> expect(r.ps[0]).toEqual p
      it "should get left right",  -> expect(r.l[1]).toEqual left
      it "should get right right", -> expect(r.r[1]).toEqual right

    describe "second round", ->
      e = "101110 100100 000001 010111 111010 101010 101111 110010".clean()
      k = "010100 010010 110111 110000 011001 001001 011111 001100".clean()
      xor = "111010 110110 110110 100111 100011 100011 110000 111110".clean()
      sbox = "1010 0110 1100 0110 1000 0011 1010 1000".clean()
      p = "01001001 11100001 00110111 00010001".clean()
      left = "01110010 00001011 11010101 01111001".clean()
      right = "10110110 01111011 11001000 11101110".clean()

      it "should get e right",     -> expect(r.es[1]).toEqual e
      it "should get k right",     -> expect(r.ks[1]).toEqual k
      it "should get mix right",   -> expect(r.mixes[1]).toEqual xor
      it "should get sbox right",  -> expect(r.sboxes[1]).toEqual sbox
      it "should get p right",     -> expect(r.ps[1]).toEqual p
      it "should get left right",  -> expect(r.l[2]).toEqual left
      it "should get right right", -> expect(r.r[2]).toEqual right

    describe "third round", ->
      e = "010110 101100 001111 110111 111001 010001 011101 011101".clean()
      k = "110101 001110 010010 000101 110110 001011 010011 101111".clean()
      xor = "100011 100010 011101 110010 001111 011010 001110 110010".clean()
      sbox = "1100 1110 1111 0001 0001 0111 1101 0110".clean()
      p = "11100110 10111011 10100001 00111101".clean()
      left = "10110110 01111011 11001000 11101110".clean()
      right = "10010100 10110000 01110100 01000100".clean()

      it "should get e right",     -> expect(r.es[2]).toEqual e
      it "should get k right",     -> expect(r.ks[2]).toEqual k
      it "should get mix right",   -> expect(r.mixes[2]).toEqual xor
      it "should get sbox right",  -> expect(r.sboxes[2]).toEqual sbox
      it "should get p right",     -> expect(r.ps[2]).toEqual p
      it "should get left right",  -> expect(r.l[3]).toEqual left
      it "should get right right", -> expect(r.r[3]).toEqual right

    it "should get the e permutations right", ->
      es = _.map([
        "111111 111111 110011 110101 011111 111111 111111 111111",
        "101110 100100 000001 010111 111010 101010 101111 110010",
        "010110 101100 001111 110111 111001 010001 011101 011101",
        "010010 101001 010110 100000 001110 101000 001000 001001",
        "110010 100010 101100 001011 111000 001000 001010 100011",
        "101000 001010 101001 011001 010101 011001 011110 101110",
        "101000 000101 010010 100110 100101 011011 110101 010110",
        "000110 100101 011011 110000 001001 010110 100010 100100",
        "100111 111100 001010 101010 101110 101011 111011 111010",
        "000110 100111 111000 000011 111111 110001 011100 000000",
        "100100 001100 001001 010010 100110 101011 110001 010010",
        "010101 011101 010111 110001 010000 000010 100001 011101",
        "110100 001101 011001 011011 110000 001010 101011 111111",
        "111010 100101 011111 110010 101010 101011 110010 101011",
        "101011 110111 111110 101100 000010 100111 111110 101110",
        "001111 111000 000110 100010 100100 001010 101101 010000"
      ], (s) -> s.clean())
      expect(r.es.length).toEqual es.length
      _.times(es.length, (i) -> expect(r.es[i]).toEqual es[i])

    it "should get the subkey mixes right", ->
      mixes = _.map([
        "101000 111111 010010 111001 001010 100111 000010 110000",
        "111010 110110 110110 100111 100011 100011 110000 111110",
        "100011 100010 011101 110010 001111 011010 001110 110010",
        "000110 010001 001010 100110 010101 000101 110010 100000",
        "101000 101011 101110 101100 111110 101111 111111 011000",
        "000100 010010 101000 110111 111110 100100 111010 011110",
        "000000 000001 011000 010100 010101 001101 001000 100100",
        "101011 100100 110111 000100 110110 001110 001010 111000",
        "101111 010001 111111 101000 001010 010011 100010 000110",
        "011100 100001 111101 010100 001001 101010 100010 000100",
        "101101 010000 011101 001011 101000 101101 101011 101111",
        "000100 101101 010001 000010 001110 110101 000011 011010",
        "011011 110101 111011 001010 011001 101100 101101 000100",
        "111101 010111 010101 111000 000011 011000 011111 101100",
        "100101 010110 101100 110000 111111 001111 110001 011100",
        "001011 101111 110100 100011 010001 110100 101000 011110"
      ], (s) -> s.clean())
      expect(r.mixes.length).toEqual mixes.length
      _.times(mixes.length, (i) -> expect(r.mixes[i]).toEqual mixes[i])

    it "should get the sbox lookups right", ->
      sboxes = _.map([
        "1101 1001 1101 1100 1010 1100 1011 0000",
        "1010 0110 1100 0110 1000 0011 1010 1000",
        "1100 1110 1111 0001 0001 0111 1101 0110",
        "0001 1100 0011 0000 1111 0100 1111 0111",
        "1101 1111 0000 0111 1110 1010 1100 0101",
        "1101 0111 1000 1011 1110 1111 0101 0111",
        "1110 0011 1011 1000 1111 1001 1111 0100",
        "1001 0111 0011 1110 0101 1000 0000 1111",
        "0111 1100 1100 1100 1010 0001 0100 0100",
        "0000 1101 0010 1000 0100 1000 0100 1000",
        "0001 1001 1111 1111 1010 1111 0100 1101",
        "1101 0100 0010 1101 0110 0001 0000 0000",
        "0101 0111 0101 0110 0011 1100 1010 1000",
        "0110 1010 0101 0101 1011 1110 0110 1110",
        "1000 1101 0011 1111 0011 0101 1001 1100",
        "0010 0010 0010 1111 0101 0100 1100 0111"
      ], (s) -> s.clean())
      expect(r.sboxes.length).toEqual sboxes.length
      _.times(sboxes.length, (i) -> expect(r.sboxes[i]).toEqual sboxes[i])

    it "should get the p permutations right", ->
      ps = _.map([
        "00010111 10001001 11010101 11001011",
        "01001001 11100001 00110111 00010001",
        "11100110 10111011 10100001 00111101",
        "00100111 00011110 00001100 10111111",
        "11010001 11111100 11011000 10110011",
        "11010011 11110110 11101001 11111010",
        "01110111 10010100 11100111 11100101",
        "01111100 11000110 01011000 01110110",
        "00000001 00011001 10110011 11110010",
        "00011000 00011100 01000000 01010100",
        "10011101 01111001 01111001 11101110",
        "10000000 10000100 10110000 11010110",
        "01111100 01000001 11010100 10011011",
        "11111101 00111011 10010110 10101000",
        "10101110 11001000 01110000 11111101",
        "11100000 01010110 00011010 01101101"
      ], (s) -> s.clean())
      expect(r.ps.length).toEqual ps.length
      _.times(ps.length, (i) -> expect(r.ps[i]).toEqual ps[i])

    it "should get the left rounds right", ->
      lefts = _.map([
        "01100101 10000010 00000000 10110010",
        "11111111 10011010 11111111 11111111",
        "01110010 00001011 11010101 01111001",
        "10110110 01111011 11001000 11101110",
        "10010100 10110000 01110100 01000100",
        "10010001 01100101 11000100 01010001",
        "01000101 01001100 10101100 11110111",
        "01000010 10010011 00101101 10101011",
        "00110010 11011000 01001011 00010010",
        "00111110 01010101 01110101 11011101",
        "00110011 11000001 11111000 11100000",
        "00100110 01001001 00110101 10001001",
        "10101110 10111000 10000001 00001110",
        "10100110 11001101 10000101 01011111",
        "11010010 11111001 01010101 10010101",
        "01011011 11110110 00010011 11110111",
        "01111100 00110001 00100101 01101000"
      ], (s) -> s.clean())
      expect(r.l.length).toEqual lefts.length
      _.times(lefts.length, (i) -> expect(r.l[i]).toEqual lefts[i])

    it "should get the right rounds right", ->
      rights = _.map([
        "11111111 10011010 11111111 11111111",
        "01110010 00001011 11010101 01111001",
        "10110110 01111011 11001000 11101110",
        "10010100 10110000 01110100 01000100",
        "10010001 01100101 11000100 01010001",
        "01000101 01001100 10101100 11110111",
        "01000010 10010011 00101101 10101011",
        "00110010 11011000 01001011 00010010",
        "00111110 01010101 01110101 11011101",
        "00110011 11000001 11111000 11100000",
        "00100110 01001001 00110101 10001001",
        "10101110 10111000 10000001 00001110",
        "10100110 11001101 10000101 01011111",
        "11010010 11111001 01010101 10010101",
        "01011011 11110110 00010011 11110111",
        "01111100 00110001 00100101 01101000",
        "10111011 10100000 00001001 10011010"
      ], (s) -> s.clean())
      expect(r.r.length).toEqual rights.length
      _.times(rights.length, (i) -> expect(r.r[i]).toEqual rights[i])

    it "should get the final round right", ->
      rounded = "10111011 10100000 00001001 10011010 01111100 00110001 00100101 01101000".clean()
      expect(r.rounded).toEqual rounded

    it "should get the final cipher binary right", ->
      c = "01101100 01000001 10001000 11000111 11100001 11111010 10000010 01010001".clean()
      expect(r.c).toEqual c

    it "should get the final cipher hex right", ->
      c_hex = "6C4188C7E1FA8251"
      expect(r.c_hex).toEqual c_hex





