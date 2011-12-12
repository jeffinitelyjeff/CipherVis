(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  _.each(root.arr, function(f, name) {
    return Array.prototype[name](f);
  });

  describe("Misc. utilities", function() {
    var is_array, is_num, is_string;
    is_string = root.utils.is_string;
    is_array = root.utils.is_array;
    is_num = root.utils.is_num;
    describe("is_string", function() {
      it("should detect strings", function() {
        expect(is_string("test")).toBeTruthy();
        return expect(is_string("")).toBeTruthy();
      });
      return it("should reject non-strings", function() {
        expect(is_string([1, 2, 3, 4])).toBeFalsy();
        expect(is_string({
          a: 5,
          c: 0
        })).toBeFalsy();
        expect(is_string(function() {
          return 5;
        })).toBeFalsy();
        return expect(is_string(5)).toBeFalsy();
      });
    });
    describe("is_array", function() {
      it("should detect arrays", function() {
        expect(is_array([1, 2, 3, 4])).toBeTruthy();
        expect(is_array([])).toBeTruthy();
        return expect(is_array([void 0, void 0])).toBeTruthy();
      });
      return it("should reject non-arrays", function() {
        expect(is_array("test")).toBeFalsy();
        expect(is_array({
          a: 5
        })).toBeFalsy();
        return expect(is_array(5)).toBeFalsy();
      });
    });
    return describe("is_num", function() {
      it("should detect numbers", function() {
        expect(is_num(5)).toBeTruthy();
        expect(is_num(5.0)).toBeTruthy();
        return expect(is_num(-1)).toBeTruthy();
      });
      return it("should reject non-numbers", function() {
        expect(is_num([1, 2, 3, 5])).toBeFalsy();
        expect(is_num("tesT")).toBeFalsy();
        return expect(is_num({
          1: 5
        })).toBeFalsy();
      });
    });
  });

  describe("String utilities", function() {
    _.each(root.str, function(f, name) {
      return String.prototype[name] = f;
    });
    describe("to_a", function() {
      it("should split into integer arrays", function() {
        expect("11111".to_a()).toEqual([1, 1, 1, 1, 1]);
        return expect("4093432".to_a()).toEqual([4, 0, 9, 3, 4, 3, 2]);
      });
      return it("shouldn't split into string arrays", function() {
        expect("11111".to_a()).not.toEqual(["1", "1", "1", "1", "1"]);
        return expect("4093432".to_a()).not.toEqual(["4", "0", "9", "3", "4", "3", "2"]);
      });
    });
    describe("reverse", function() {
      return it("sholud reverse stuff", function() {
        expect("unehau".reverse()).toEqual("uahenu");
        expect("3,a31.,3".reverse()).toEqual("3,.13a,3");
        return expect(" 43t2nh 223n".reverse()).toEqual("n322 hn2t34 ");
      });
    });
    describe("caps", function() {
      it("should cap the first letter", function() {
        expect("hello".caps()).toEqual("Hello");
        return expect("test there".caps()).toEqual("Test there");
      });
      return it("shouldn't cap the rest", function() {
        expect("Hello".caps()).toEqual("Hello");
        return expect("Test there".caps()).toEqual("Test there");
      });
    });
    describe("is_upper", function() {
      it("should say yes if all upper", function() {
        return expect("UNHENUOHNATHNEO".is_upper()).toBeTruthy();
      });
      it("should say no if all lower", function() {
        return expect("enthaunt".is_upper()).toBeFalsy();
      });
      return it("should say no if ambiguous", function() {
        return expect("h h UNTHU NEUh".is_upper()).toBeFalsy();
      });
    });
    describe("is_lower", function() {
      it("should say yes if all lower", function() {
        return expect("unehtau".is_lower()).toBeTruthy();
      });
      it("should say no if all upper", function() {
        return expect("TNEHUOHTN".is_lower()).toBeFalsy();
      });
      return it("should say no if ambiguous", function() {
        return expect("unetoh NATH".is_lower()).toBeFalsy();
      });
    });
    return describe("is_hex", function() {
      it("should say yes to all hex", function() {
        expect("0123456789ABCDEF".is_hex()).toBeTruthy();
        expect("0123456789abcdef".is_hex()).toBeTruthy();
        expect("4932ABE43BDF".is_hex()).toBeTruthy();
        return expect("4932abe43bdf".is_hex()).toBeTruthy();
      });
      it("should say no to some non-hex", function() {
        expect("ABCDEFGHIJKLM".is_hex()).toBeFalsy();
        expect("abcdefghijklm".is_hex()).toBeFalsy();
        expect("4234TNHUET".is_hex()).toBeFalsy();
        expect("4234tnhuet".is_hex()).toBeFalsy();
        expect("4A.',.'".is_hex()).toBeFalsy();
        return expect("4a.',.'".is_hex()).toBeFalsy();
      });
      return it("should say no to no hex", function() {
        expect(",'.p.p.,p.p.'p.qqjuk;".is_hex()).toBeFalsy();
        return expect("zzzzzuuuuqqqqq".is_hex()).toBeFalsy();
      });
    });
  });

}).call(this);
