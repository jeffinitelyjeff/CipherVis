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
  ]).map( (s) -> s.split(' ').join('').to_int_a())

  it "should work with this example", ->

    s = "00010011 00110100 01010111 01111001 10011011 10111100 11011111 11110001"
    k = s.split(' ').join('').to_int_a()

    expect(root.subkeys(k)).toEqual expected_ks

  it "shouldn't always pass tests; sanity check", ->

    # These are mutations of the original key
    s1 = "00010111 00110100 01010111 01111001 10011011 10111100 11011111 11110001"
    s2 = "00010111 00110100 01010111 01111001 10011011 10111100 11010011 11110001"
    s3 = "00110111 00110100 01010011 01111001 10011011 10111100 11011111 11110001"
    k1 = s1.split(' ').join('').to_int_a()
    k2 = s2.split(' ').join('').to_int_a()
    k3 = s3.split(' ').join('').to_int_a()

    expect(root.subkeys(k1)).not.toEqual expected_ks
    expect(root.subkeys(k2)).not.toEqual expected_ks
    expect(root.subkeys(k3)).not.toEqual expected_ks



