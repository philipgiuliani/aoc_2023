import gleam/string
import gleam/int
import gleam/result
import gleam/list
import gleam/io
import gleam/option.{type Option, None, Some}

type State {
  State(wip: Option(#(Int, String)), found: List(Int))
}

pub fn pt_1(input: String) {
  let lines =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  lines
  |> list.index_map(fn(index, line) {
    find_parts_in_line(
      line,
      list.at(lines, index - 1),
      list.at(lines, index + 1),
    )
  })
  |> list.flatten()
  |> int.sum()
}

pub fn pt_2(input: String) {
  todo
}

type Token {
  Number
  Dot
  Special
}

fn classify_token(char) {
  case char {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> Number

    "." -> Dot

    _ -> Special
  }
}

fn find_parts_in_line(
  line: List(String),
  prev_line: Result(List(String), Nil),
  next_line: Result(List(String), Nil),
) -> List(Int) {
  let state =
    list.index_fold(
      line,
      State(wip: None, found: []),
      fn(state, char, index) {
        case classify_token(char) {
          Number -> add_number(state, index, char)
          Dot | Special ->
            maybe_find_part(state, prev_line, Ok(line), next_line)
        }
      },
    )

  let state = maybe_find_part(state, prev_line, Ok(line), next_line)
  list.reverse(state.found)
}

fn add_number(state: State, index: Int, number: String) {
  let wip = case state.wip {
    None -> Some(#(index, number))
    Some(wip) -> Some(#(wip.0, wip.1 <> number))
  }

  State(..state, wip: wip)
}

fn keep_wip(state: State) {
  let assert Some(#(_, value)) = state.wip

  let assert Ok(number) =
    value
    |> string.split("")
    |> list.map(int.parse)
    |> result.values()
    |> int.undigits(10)

  State(wip: None, found: [number, ..state.found])
}

fn drop_wip(state) {
  State(..state, wip: None)
}

fn maybe_find_part(state: State, prev_line, current_line, next_line) {
  case state.wip {
    None -> state
    Some(#(start_index, value)) -> {
      let drop = start_index - 1
      let keep = case start_index {
        0 -> string.length(value) + 1
        _ -> string.length(value) + 2
      }

      case
        has_special(prev_line, drop, keep) || has_special(
          current_line,
          drop,
          keep,
        ) || has_special(next_line, drop, keep)
      {
        True -> keep_wip(state)
        False -> drop_wip(state)
      }
    }
  }
}

fn has_special(line, start, length) -> Bool {
  case line {
    Ok(line) ->
      line
      |> list.drop(start)
      |> list.take(length)
      |> list.any(fn(c) { classify_token(c) == Special })

    Error(Nil) -> False
  }
}
