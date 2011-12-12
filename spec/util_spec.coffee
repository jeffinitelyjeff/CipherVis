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

    it "sholud reverse stuff", ->
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
