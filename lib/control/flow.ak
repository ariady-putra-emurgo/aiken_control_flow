/// See: https://aiken-lang.org/language-tour/control-flow#if-else
test if_else() {
  let a: Int =
    if True {
      1
    } else {
      0
    }

  let b =
    if a == 1 {
      "Yes"
    } else {
      "No"
    }

  let token = ("NFT", 1)
  let assets = []

  let c =
    if token == ("NFT", 1) {
      [token, ..assets]
    } else if token == ("FT", 20) {
      [("FT", 10), ("FT", 10), ..assets]
    } else {
      assets
    }

  let d =
    if token == ("NFT", 1) {
      [token, ..assets]
    } else if token == ("FT", 1) {
      [("FT", -1), ..assets]
    } else if token == ("FT", 20) {
      [("FT", 10), ("FT", 10), ..assets]
    } else {
      assets
    }

  and {
    a == 1,
    b == "Yes",
    c == [("NFT", 1)],
    d == c,
  }
}

/// See: https://aiken-lang.org/language-tour/custom-types#pattern-matching
test when_is() {
  // Pattern-matching: `when *expr* is`
  //
  // A wildcard is like a fallback pattern.
  // See: https://aiken-lang.org/language-tour/custom-types#wildcard
  let a = 1
  let b: Bool =
    when a is {
      0 -> False
      _ -> True
    }
  expect b

  // Can be used to transform from 1 data-type into another,
  // but this is NOT type-casting.
  //
  // Eg. from ByteArray to Option:
  let c = "y"
  let d: Option<ByteArray> =
    when c is {
      "" -> None
      c -> Some(c)
    }
  expect Some("y") = d
  expect Some(_) = d

  // The `when-is` block forces us to exhaustively handle every constructor in the type definition.
  //
  // You can use | (pipe) to handle multiple patterns at once.
  // See: https://aiken-lang.org/language-tour/custom-types#alternative-patterns
  let token = ("NFT", 1)
  let describe_token =
    when token is {
      ("NFT", 1) -> "AssetName: NFT; Qty: 1"

      ("NFT", q) | ("FT", q) ->
        if q == 1 {
          "AssetName: either NFT or FT; Qty: 1"
        } else {
          "AssetName: either NFT or FT; Qty: q"
        }

      (asset, 1) | (asset, 20) ->
        when asset is {
          "" -> "Empty AssetName; Qty: either 1 or 20"
          _ -> "Has AssetName; Qty: either 1 or 20"
        }

      (_, _) -> "Any AssetName; Any Qty"
    }
  expect "AssetName: NFT; Qty: 1" = describe_token

  // We can match against a complex pattern:
  let assets =
    [
      ("PolicyId1", [("AssetName", 20)]),
      ("PolicyId2", [("AssetName1", 300), ("AssetName2", 4_000)]),
      ("PolicyId3", []),
    ]
  let is_empty_or_contains_policyid2 =
    when assets is {
      [] -> True
      [_head, (p, [_, (a, q), ..] as tokens), ..] -> and {
          tokens == [("AssetName1", 300), ("AssetName2", 4000)],
          p == "PolicyId2",
          a == "AssetName2",
          q >= 4_000,
        }
      _ -> False
    }
  expect is_empty_or_contains_policyid2
}
