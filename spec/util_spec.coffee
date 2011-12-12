root = exports ? this

_.each(root.arr, (f, name) -> Array.prototype[name] f)

describe "Misc. utilities", ->

  is_string = root.utils.is_string
  is_array = root.utils.is_array
  is_num = root.utils.is_num

  describe "is_string", ->

    it "should detect strings", ->
      expect(is_string "test").toBeTruthy()
      expect(is_string "").toBeTruthy()

    it "should reject non-strings", ->
      expect(is_string [1,2,3,4]).toBeFalsy()
      expect(is_string {a:5, c:0}).toBeFalsy()
      expect(is_string () -> 5).toBeFalsy()
      expect(is_string 5).toBeFalsy()

  describe "is_array", ->

    it "should detect arrays", ->
      expect(is_array [1,2,3,4]).toBeTruthy()
      expect(is_array []).toBeTruthy()
      expect(is_array [undefined, undefined]).toBeTruthy()

    it "should reject non-arrays", ->
      expect(is_array "test").toBeFalsy()
      expect(is_array {a:5}).toBeFalsy()
      expect(is_array 5).toBeFalsy()

  describe "is_num", ->

    it "should detect numbers", ->
      expect(is_num 5).toBeTruthy()
      expect(is_num 5.0).toBeTruthy()
      expect(is_num -1).toBeTruthy()

    it "should reject non-numbers", ->
      expect(is_num [1,2,3,5]).toBeFalsy()
      expect(is_num "tesT").toBeFalsy()
      expect(is_num {1:5}).toBeFalsy()

describe "String utilities", ->

  _.each(root.str, (f, name) -> String.prototype[name] = f)

  describe "to_a", ->

    it "should split into integer arrays", ->
      expect("11111".to_a()).toEqual([1,1,1,1,1])
      expect("4093432".to_a()).toEqual([4,0,9,3,4,3,2])

    it "shouldn't split into string arrays", ->
      expect("11111".to_a()).not.toEqual(["1","1","1","1","1"])
      expect("4093432".to_a()).not.toEqual(["4","0","9","3","4","3","2"])

  describe "reverse", ->

    it "should reverse stuff", ->
      expect("unehau".reverse()).toEqual("uahenu")
      expect("3,a31.,3".reverse()).toEqual("3,.13a,3")
      expect(" 43t2nh 223n".reverse()).toEqual("n322 hn2t34 ")

  describe "caps", ->

    it "should cap the first letter", ->
      expect("hello".caps()).toEqual "Hello"
      expect("test there".caps()).toEqual "Test there"

    it "shouldn't cap the rest", ->
      expect("Hello".caps()).toEqual "Hello"
      expect("Test there".caps()).toEqual "Test there"

  describe "is_upper", ->

    it "should say yes if all upper", ->
      expect("UNHENUOHNATHNEO".is_upper()).toBeTruthy()

    it "should say no if all lower", ->
      expect("enthaunt".is_upper()).toBeFalsy()

    it "should say no if ambiguous", ->
      expect("h h UNTHU NEUh".is_upper()).toBeFalsy()

  describe "is_lower", ->

    it "should say yes if all lower", ->
      expect("unehtau".is_lower()).toBeTruthy()

    it "should say no if all upper", ->
      expect("TNEHUOHTN".is_lower()).toBeFalsy()

    it "should say no if ambiguous", ->
      expect("unetoh NATH".is_lower()).toBeFalsy()

  describe "is_hex", ->

    it "should say yes to all hex", ->
      expect("0123456789ABCDEF".is_hex()).toBeTruthy()
      expect("0123456789abcdef".is_hex()).toBeTruthy()
      expect("4932ABE43BDF".is_hex()).toBeTruthy()
      expect("4932abe43bdf".is_hex()).toBeTruthy()

    it "should say no to some non-hex", ->
      expect("ABCDEFGHIJKLM".is_hex()).toBeFalsy()
      expect("abcdefghijklm".is_hex()).toBeFalsy()
      expect("4234TNHUET".is_hex()).toBeFalsy()
      expect("4234tnhuet".is_hex()).toBeFalsy()
      expect("4A.',.'".is_hex()).toBeFalsy()
      expect("4a.',.'".is_hex()).toBeFalsy()

    it "should say no to no hex", ->
      expect(",'.p.p.,p.p.'p.qqjuk;".is_hex()).toBeFalsy()
      expect("zzzzzuuuuqqqqq".is_hex()).toBeFalsy()

  describe "is_bin", ->

    it "should say yes to all bin", ->
      expect("010101010101".is_bin()).toBeTruthy()
      expect("0000000".is_bin()).toBeTruthy()
      expect("111111".is_bin()).toBeTruthy()

    it "should say no to some non-bin", ->
      expect("0110331".is_bin()).toBeFalsy()
      expect("011010101h".is_bin()).toBeFalsy()
      expect("a0101010".is_bin()).toBeFalsy()

    it "should say no to all non-bin", ->
      expect("58548958543".is_bin()).toBeFalsy()
      expect("thuneouehtaseu".is_bin()).toBeFalsy()

  describe "to_bin", ->

    it "should convert hex digits", ->
      expect("0".to_bin()).toEqual "0000"
      expect("1".to_bin()).toEqual "0001"
      expect("2".to_bin()).toEqual "0010"
      expect("3".to_bin()).toEqual "0011"
      expect("4".to_bin()).toEqual "0100"
      expect("5".to_bin()).toEqual "0101"
      expect("6".to_bin()).toEqual "0110"
      expect("7".to_bin()).toEqual "0111"
      expect("8".to_bin()).toEqual "1000"
      expect("9".to_bin()).toEqual "1001"
      expect("A".to_bin()).toEqual "1010"
      expect("B".to_bin()).toEqual "1011"
      expect("C".to_bin()).toEqual "1100"
      expect("D".to_bin()).toEqual "1101"
      expect("E".to_bin()).toEqual "1110"
      expect("F".to_bin()).toEqual "1111"

    it "should convert hex strings", ->
      expect("66".to_bin()).toEqual "01100110"
      expect("8A".to_bin()).toEqual "10001010"
      expect("45BD".to_bin()).toEqual "0100010110111101"

  describe "to_bin_array", ->

    it "should convert hex digits", ->
      expect("0".to_bin_array()).toEqual "0000".to_a()
      expect("1".to_bin_array()).toEqual "0001".to_a()
      expect("2".to_bin_array()).toEqual "0010".to_a()
      expect("3".to_bin_array()).toEqual "0011".to_a()
      expect("4".to_bin_array()).toEqual "0100".to_a()
      expect("5".to_bin_array()).toEqual "0101".to_a()
      expect("6".to_bin_array()).toEqual "0110".to_a()
      expect("7".to_bin_array()).toEqual "0111".to_a()
      expect("8".to_bin_array()).toEqual "1000".to_a()
      expect("9".to_bin_array()).toEqual "1001".to_a()
      expect("A".to_bin_array()).toEqual "1010".to_a()
      expect("B".to_bin_array()).toEqual "1011".to_a()
      expect("C".to_bin_array()).toEqual "1100".to_a()
      expect("D".to_bin_array()).toEqual "1101".to_a()
      expect("E".to_bin_array()).toEqual "1110".to_a()
      expect("F".to_bin_array()).toEqual "1111".to_a()

    it "should convert hex strings", ->
      expect("66".to_bin_array()).toEqual "01100110".to_a()
      expect("8A".to_bin_array()).toEqual "10001010".to_a()
      expect("45BD".to_bin_array()).toEqual "0100010110111101".to_a()

  describe "to_vector", ->

    it "should split space-padded stuff", ->
      expect("  2    43  1  4".to_vector()).toEqual [2, 43, 1, 4]
      expect("2 4 5 9".to_vector()).toEqual [2, 4, 5, 9]
      expect("2       5 ".to_vector()).toEqual [2, 5]
      expect("   2".to_vector()).toEqual [2]

  describe "repeat", ->

    it "should repeat stuff", ->
      expect("a".repeat(5)).toEqual "aaaaa"
      expect("BD".repeat(3)).toEqual "BDBDBD"
      expect("".repeat(10)).toEqual ""
      expect("31415".repeat(1)).toEqual "31415"

    it "should work with 0 to make empty string", ->
      expect("4340[4932423".repeat(0)).toEqual ""

    it "should work with empty param", ->
      expect("31415".repeat()).toEqual "31415".repeat(1)

  describe "pad", ->

    it "should work for <= 4", ->
      expect("".pad(4)).toEqual "0000"
      expect("A".pad(4)).toEqual "000A"
      expect("BD".pad(4)).toEqual "00BD"
      expect("CEF".pad(4)).toEqual "0CEF"
      expect("GHJI".pad(4)).toEqual "GHJI"

    it "should work when less than length", ->
      expect("40323".pad(3)).toEqual "40323"
      expect("AB42".pad(0)).toEqual "AB42"
      expect("423h".pad(1)).toEqual "423h"

    it "should work with other characters", ->
      expect("".pad(4, 1)).toEqual "1111"
      expect("A".pad(4, 1)).toEqual "111A"
      expect("BD".pad(4, 1)).toEqual "11BD"
      expect("CEF".pad(4, 1)).toEqual "1CEF"
      expect("GHJI".pad(4, 1)).toEqual "GHJI"


