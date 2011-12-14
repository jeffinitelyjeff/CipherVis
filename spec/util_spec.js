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
    describe("to_int_a", function() {
      it("should split into integer arrays", function() {
        expect("11111".to_int_a()).toEqual([1, 1, 1, 1, 1]);
        return expect("4093432".to_int_a()).toEqual([4, 0, 9, 3, 4, 3, 2]);
      });
      return it("shouldn't split into string arrays", function() {
        expect("11111".to_int_a()).not.toEqual(["1", "1", "1", "1", "1"]);
        return expect("4093432".to_int_a()).not.toEqual(["4", "0", "9", "3", "4", "3", "2"]);
      });
    });
    describe("reverse", function() {
      return it("should reverse stuff", function() {
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
    describe("is_hex", function() {
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
    describe("is_bin", function() {
      it("should say yes to all bin", function() {
        expect("010101010101".is_bin()).toBeTruthy();
        expect("0000000".is_bin()).toBeTruthy();
        return expect("111111".is_bin()).toBeTruthy();
      });
      it("should say no to some non-bin", function() {
        expect("0110331".is_bin()).toBeFalsy();
        expect("011010101h".is_bin()).toBeFalsy();
        return expect("a0101010".is_bin()).toBeFalsy();
      });
      return it("should say no to all non-bin", function() {
        expect("58548958543".is_bin()).toBeFalsy();
        return expect("thuneouehtaseu".is_bin()).toBeFalsy();
      });
    });
    describe("to_bin", function() {
      it("should convert hex digits", function() {
        expect("0".to_bin()).toEqual("0000");
        expect("1".to_bin()).toEqual("0001");
        expect("2".to_bin()).toEqual("0010");
        expect("3".to_bin()).toEqual("0011");
        expect("4".to_bin()).toEqual("0100");
        expect("5".to_bin()).toEqual("0101");
        expect("6".to_bin()).toEqual("0110");
        expect("7".to_bin()).toEqual("0111");
        expect("8".to_bin()).toEqual("1000");
        expect("9".to_bin()).toEqual("1001");
        expect("A".to_bin()).toEqual("1010");
        expect("B".to_bin()).toEqual("1011");
        expect("C".to_bin()).toEqual("1100");
        expect("D".to_bin()).toEqual("1101");
        expect("E".to_bin()).toEqual("1110");
        return expect("F".to_bin()).toEqual("1111");
      });
      return it("should convert hex strings", function() {
        expect("66".to_bin()).toEqual("01100110");
        expect("8A".to_bin()).toEqual("10001010");
        return expect("45BD".to_bin()).toEqual("0100010110111101");
      });
    });
    describe("to_bin_array", function() {
      it("should convert hex digits", function() {
        expect("0".to_bin_array()).toEqual("0000".to_int_a());
        expect("1".to_bin_array()).toEqual("0001".to_int_a());
        expect("2".to_bin_array()).toEqual("0010".to_int_a());
        expect("3".to_bin_array()).toEqual("0011".to_int_a());
        expect("4".to_bin_array()).toEqual("0100".to_int_a());
        expect("5".to_bin_array()).toEqual("0101".to_int_a());
        expect("6".to_bin_array()).toEqual("0110".to_int_a());
        expect("7".to_bin_array()).toEqual("0111".to_int_a());
        expect("8".to_bin_array()).toEqual("1000".to_int_a());
        expect("9".to_bin_array()).toEqual("1001".to_int_a());
        expect("A".to_bin_array()).toEqual("1010".to_int_a());
        expect("B".to_bin_array()).toEqual("1011".to_int_a());
        expect("C".to_bin_array()).toEqual("1100".to_int_a());
        expect("D".to_bin_array()).toEqual("1101".to_int_a());
        expect("E".to_bin_array()).toEqual("1110".to_int_a());
        return expect("F".to_bin_array()).toEqual("1111".to_int_a());
      });
      return it("should convert hex strings", function() {
        expect("66".to_bin_array()).toEqual("01100110".to_int_a());
        expect("8A".to_bin_array()).toEqual("10001010".to_int_a());
        return expect("45BD".to_bin_array()).toEqual("0100010110111101".to_int_a());
      });
    });
    describe("to_vector", function() {
      return it("should split space-padded stuff", function() {
        expect("  2    43  1  4".to_vector()).toEqual([2, 43, 1, 4]);
        expect("2 4 5 9".to_vector()).toEqual([2, 4, 5, 9]);
        expect("2       5 ".to_vector()).toEqual([2, 5]);
        return expect("   2".to_vector()).toEqual([2]);
      });
    });
    describe("repeat", function() {
      it("should repeat stuff", function() {
        expect("a".repeat(5)).toEqual("aaaaa");
        expect("BD".repeat(3)).toEqual("BDBDBD");
        expect("".repeat(10)).toEqual("");
        return expect("31415".repeat(1)).toEqual("31415");
      });
      it("should work with 0 to make empty string", function() {
        return expect("4340[4932423".repeat(0)).toEqual("");
      });
      return it("should work with empty param", function() {
        return expect("31415".repeat()).toEqual("31415".repeat(1));
      });
    });
    return describe("pad", function() {
      it("should work for <= 4", function() {
        expect("".pad(4)).toEqual("0000");
        expect("A".pad(4)).toEqual("000A");
        expect("BD".pad(4)).toEqual("00BD");
        expect("CEF".pad(4)).toEqual("0CEF");
        return expect("GHJI".pad(4)).toEqual("GHJI");
      });
      it("should work when less than length", function() {
        expect("40323".pad(3)).toEqual("40323");
        expect("AB42".pad(0)).toEqual("AB42");
        return expect("423h".pad(1)).toEqual("423h");
      });
      return it("should work with other characters", function() {
        expect("".pad(4, 1)).toEqual("1111");
        expect("A".pad(4, 1)).toEqual("111A");
        expect("BD".pad(4, 1)).toEqual("11BD");
        expect("CEF".pad(4, 1)).toEqual("1CEF");
        return expect("GHJI".pad(4, 1)).toEqual("GHJI");
      });
    });
  });

  describe("Array utilities", function() {
    describe("is_bin", function() {
      it("should accept bin arrays", function() {
        expect([1, 1, 1, 1, 1, 1].is_bin()).toBeTruthy();
        expect([0, 0, 0, 0, 0, 0].is_bin()).toBeTruthy();
        return expect([1, 0, 1, 0, 0, 1].is_bin()).toBeTruthy();
      });
      it("should reject non-bin arrays", function() {
        expect([1, 1, 1, 1, 1, 2].is_bin()).toBeFalsy();
        expect([1, 2, 1, 0, 1, 2].is_bin()).toBeFalsy();
        expect([0, 0, 0, 0, 0, 4].is_bin()).toBeFalsy();
        return expect([-1, 3, 8, 6, 0, 4].is_bin()).toBeFalsy();
      });
      return it("should reject non-int arrays", function() {
        expect(["yo", "b", "c"].is_bin()).toBeFalsy();
        expect([
          {
            a: 5,
            c: 10
          }, {
            e: 5
          }
        ].is_bin()).toBeFalsy();
        return expect([
          "hi", "there", function(x) {
            return x;
          }
        ].is_bin()).toBeFalsy();
      });
    });
    describe("to_int", function() {
      it("should clean up positive int arrays", function() {
        expect(["1", "2", "3"].to_int()).toEqual([1, 2, 3]);
        expect(["0", "0", "0", "0"].to_int()).toEqual([0, 0, 0, 0]);
        return expect(["5", "10", "1000", "0"].to_int()).toEqual([5, 10, 1000, 0]);
      });
      it("should clean up neg int arrays", function() {
        return expect(["-4", "-3"].to_int()).toEqual([-4, -3]);
      });
      return it("should work with mixed arrays", function() {
        return expect(["1", 5, "6", -5, "-10"].to_int()).toEqual([1, 5, 6, -5, -10]);
      });
    });
    describe("to_hex", function() {
      it("should work with hex digits", function() {
        expect("0".to_ba().to_hex()).toEqual("0");
        expect("1".to_ba().to_hex()).toEqual("1");
        expect("2".to_ba().to_hex()).toEqual("2");
        expect("3".to_ba().to_hex()).toEqual("3");
        expect("4".to_ba().to_hex()).toEqual("4");
        expect("5".to_ba().to_hex()).toEqual("5");
        expect("6".to_ba().to_hex()).toEqual("6");
        expect("7".to_ba().to_hex()).toEqual("7");
        expect("8".to_ba().to_hex()).toEqual("8");
        expect("9".to_ba().to_hex()).toEqual("9");
        expect("A".to_ba().to_hex()).toEqual("A");
        expect("B".to_ba().to_hex()).toEqual("B");
        expect("C".to_ba().to_hex()).toEqual("C");
        expect("D".to_ba().to_hex()).toEqual("D");
        expect("E".to_ba().to_hex()).toEqual("E");
        return expect("F".to_ba().to_hex()).toEqual("F");
      });
      return it("should work with multiple digits", function() {
        expect("AB032".to_ba().to_hex()).toEqual("AB032");
        return expect("AF90DD".to_ba().to_hex()).toEqual("AF90DD");
      });
    });
    return describe("xor", function() {
      it("should xor digits properly", function() {
        expect([0].xor([0])).toEqual([0]);
        expect([0].xor([1])).toEqual([1]);
        expect([1].xor([0])).toEqual([1]);
        return expect([1].xor([1])).toEqual([0]);
      });
      it("should xor arrays properly", function() {
        expect([0, 0, 0, 0].xor([1, 1, 1, 1])).toEqual([1, 1, 1, 1]);
        expect([0, 0, 0, 0].xor([0, 0, 0, 0])).toEqual([0, 0, 0, 0]);
        expect([1, 1, 1, 1].xor([1, 1, 1, 1])).toEqual([0, 0, 0, 0]);
        expect([1, 1, 1, 1].xor([0, 0, 0, 0])).toEqual([1, 1, 1, 1]);
        expect([1, 0, 0, 1, 1].xor([1, 0, 1, 1, 1])).toEqual([0, 0, 1, 0, 0]);
        return expect([1, 1, 1, 1, 1, 0, 0].xor([0, 0, 1, 1, 1, 0, 1])).toEqual([1, 1, 0, 0, 0, 0, 1]);
      });
      return it("should throw error with non-bin first operand", function() {
        return expect(function() {
          return [2].xor([0]);
        }).toThrow(Error);
      });
    });
  });

}).call(this);
