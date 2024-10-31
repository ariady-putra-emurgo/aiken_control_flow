use aiken/builtin

pub type Datum {
  Constr0
  Constr1(Int)
  Constr2 { field_1: ByteArray, field_2: Bool }
}

pub fn is_valid(datum: Data) -> Bool {
  // Soft-casting: `if *expr* is *pattern*`
  // See: https://aiken-lang.org/language-tour/control-flow#soft-casting-with-ifis
  if datum is Constr0: Datum {
    True
  } else if datum is Constr1(i): Datum {
    i == 1
  } else if datum is Constr2 { field_2, .. }: Datum {
    field_2
  } else if datum is 1: Int {
    True
  } else if datum is i: Int {
    i == 1
  } else if datum is "1": ByteArray {
    True
  } else if datum is b: ByteArray {
    b == #"01"
  } else if datum is []: List<Bool> {
    True
  } else if datum is ls: List<(Int, List<ByteArray>)> {
    ls == [(0, [#"01"])]
  } else {
    False
  }
}

test if_is() {
  // This is type-casting. In this case, we're casting from some type into `Data`
  // Upcasting: https://aiken-lang.org/language-tour/custom-types#upcasting
  let datum_1: Data = Constr0
  let datum_2: Data = Constr1(1)
  let datum_3: Data = Constr2("", True)
  let datum_4: Data = 1
  let datum_5: Data = 2
  let datum_6: Data = "1"
  let datum_7: Data = #[0x01]
  let datum_8: Data = []
  let datum_9: Data = [(0, [#"01"])]

  and {
    is_valid(datum_1),
    is_valid(datum_2),
    is_valid(datum_3),
    is_valid(datum_4),
    !is_valid(datum_5),
    is_valid(datum_6),
    is_valid(datum_7),
    is_valid(datum_8),
    is_valid(datum_9),
  }
}

test choose_data() {
  let datum_1: Data = Constr0
  let datum_2: Data = Constr1(1)
  let datum_3: Data = Constr2("", True)
  let datum_4: Data = 1
  let datum_5: Data = 2
  let datum_6: Data = "1"
  let datum_7: Data = #[0x01]
  let datum_8: Data = []
  let datum_9: Data = [(0, [#"01"])]

  trace @"datum_1": what_is(datum_1), datum_1
  trace @"datum_2": what_is(datum_2), datum_2
  trace @"datum_3": what_is(datum_3), datum_3
  trace @"datum_4": what_is(datum_4), datum_4
  trace @"datum_5": what_is(datum_5), datum_5
  trace @"datum_6": what_is(datum_6), datum_6
  trace @"datum_7": what_is(datum_7), datum_7
  trace @"datum_8": what_is(datum_8), datum_8
  trace @"datum_9": what_is(datum_9), datum_9
  trace @"datum_X": what_is([Pair(0, 1)])

  and {
    is_valid_(datum_1),
    is_valid_(datum_2),
    is_valid_(datum_3),
    is_valid_(datum_4),
    !is_valid_(datum_5),
    is_valid_(datum_6),
    is_valid_(datum_7),
    is_valid_(datum_8),
    is_valid_(datum_9),
  }
}

fn what_is(data: Data) -> String {
  builtin.choose_data(data, @"constr", @"map", @"list", @"int", @"bytearray")
}

fn constr_data_to_datum(constr: Data) -> Datum {
  let Pair(i, ds) = builtin.un_constr_data(constr)
  when i is {
    0 -> Constr0
    1 -> {
      expect [d] = ds
      expect i: Int = d
      Constr1(i)
    }
    2 -> {
      expect [d1, d2] = ds
      expect field_1: ByteArray = d1
      expect field_2: Bool = d2
      Constr2(field_1, field_2)
    }
    _ -> fail
  }
}

fn when_constr(cd: Data) -> Bool {
  when constr_data_to_datum(cd) is {
    Constr0 -> True
    Constr1(i) -> i == 1
    Constr2 { field_2, .. } -> field_2
  }
}

fn when_map(_) {
  todo @"Define `fn when_map`"
}

fn when_list(ld: Data) -> Bool {
  when builtin.un_list_data(ld) is {
    [] -> True
    [tuple] -> {
      expect (i, bs): (Int, List<ByteArray>) = tuple
      i == 0 && bs == [#"01"]
    }
    _ -> False
  }
}

fn when_int(id: Data) -> Bool {
  builtin.un_i_data(id) == 1
}

fn when_bytearray(bd: Data) -> Bool {
  when builtin.un_b_data(bd) is {
    "1" | #"01" -> True
    _ -> False
  }
}

pub fn is_valid_(datum: Data) -> Bool {
  builtin.choose_data(
    datum,
    when_constr(datum),
    when_map(datum),
    when_list(datum),
    when_int(datum),
    when_bytearray(datum),
  )
}
