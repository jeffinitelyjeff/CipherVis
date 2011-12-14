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
