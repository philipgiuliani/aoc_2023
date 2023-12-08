import gleam/dict.{type Dict}
import gleam/string
import gleam/bit_array
import gleam/list
import gleam/io
import gleam/iterator
import gleam/pair

type Instruction {
  L
  R
}

pub fn pt_1(input: String) {
  let #(instructions, mapping) = parse(input)

  instructions
  |> iterator.from_list()
  |> iterator.cycle()
  |> iterator.fold_until(#(0, "AAA"), fn(acc, instruction) {
    let assert #(count, last_state) = acc
    let assert Ok(next) = dict.get(mapping, last_state)

    let next = case instruction {
      L -> next.0
      R -> next.1
    }

    case next == "ZZZ" {
      True -> list.Stop(#(count + 1, next))
      False -> list.Continue(#(count + 1, next))
    }
  })
  |> pair.first()
}

pub fn pt_2(input: String) {
  todo
}

fn parse(input: String) -> #(List(Instruction), Dict(String, #(String, String))) {
  let assert Ok(#(instructions, mapping)) = string.split_once(input, "\n\n")

  let instructions =
    instructions
    |> string.split("")
    |> list.map(fn(i) {
      case i {
        "L" -> L
        _ -> R
      }
    })

  let mapping =
    mapping
    |> string.split("\n")
    |> list.fold(dict.new(), fn(acc, line) {
      let assert <<
        key:bytes-size(3),
        " = (":utf8,
        left:bytes-size(3),
        ", ":utf8,
        right:bytes-size(3),
        ")":utf8,
      >> = bit_array.from_string(line)

      let assert Ok(key) = bit_array.to_string(key)
      let assert Ok(left) = bit_array.to_string(left)
      let assert Ok(right) = bit_array.to_string(right)

      dict.insert(acc, key, #(left, right))
    })

  #(instructions, mapping)
}
