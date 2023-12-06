import gleam/string
import gleam/int
import gleam/list
import gleam/dict
import gleam/option.{type Option, None, Some}

type State {
  State(wip: Option(#(Int, List(Int))), found: List(Part))
}

fn parse(input: String) -> List(Part) {
  let lines =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  lines
  |> list.index_map(fn(index, line) {
    find_parts_in_line(
      index,
      line,
      list.at(lines, index - 1),
      list.at(lines, index + 1),
    )
  })
  |> list.flatten()
}

pub fn pt_1(input: String) {
  input
  |> parse()
  |> list.map(fn(p) { p.number })
  |> int.sum()
}

pub fn pt_2(input: String) {
  input
  |> parse()
  |> list.filter(fn(p) { p.char == "*" })
  |> list.group(fn(p) { p.char_coord })
  |> dict.to_list()
  |> list.filter_map(fn(item) {
    case item {
      #(_, [a, b]) -> Ok(a.number * b.number)
      _ -> Error(Nil)
    }
  })
  |> int.sum()
}

type Part {
  Part(number: Int, char: String, char_coord: #(Int, Int))
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
  line_index: Int,
  line: List(String),
  prev_line: Result(List(String), Nil),
  next_line: Result(List(String), Nil),
) -> List(Part) {
  let state =
    list.index_fold(line, State(wip: None, found: []), fn(state, char, index) {
      case classify_token(char) {
        Number -> add_number(state, index, char)
        Dot | Special ->
          maybe_find_part(state, line_index, prev_line, Ok(line), next_line)
      }
    })

  let state = maybe_find_part(state, line_index, prev_line, Ok(line), next_line)
  list.reverse(state.found)
}

fn add_number(state: State, index: Int, number: String) {
  let assert Ok(number) = int.parse(number)

  let wip = case state.wip {
    None -> Some(#(index, [number]))
    Some(wip) -> Some(#(wip.0, [number, ..wip.1]))
  }

  State(..state, wip: wip)
}

fn keep_wip(state: State, char: #(Int, Int, String)) {
  let assert Some(#(_, number)) = state.wip
  let assert Ok(number) =
    number
    |> list.reverse()
    |> int.undigits(10)

  State(wip: None, found: [
    Part(number: number, char_coord: #(char.0, char.1), char: char.2),
    ..state.found
  ])
}

fn drop_wip(state) {
  State(..state, wip: None)
}

fn maybe_find_part(
  state: State,
  line_index: Int,
  prev_line,
  current_line,
  next_line,
) {
  case state.wip {
    None -> state
    Some(#(start_index, value)) -> {
      let drop = start_index - 1
      let keep = case start_index {
        0 -> list.length(value) + 1
        _ -> list.length(value) + 2
      }

      let char =
        find_special(line_index - 1, prev_line, drop, keep)
        |> option.lazy_or(fn() {
          find_special(line_index, current_line, drop, keep)
        })
        |> option.lazy_or(fn() {
          find_special(line_index + 1, next_line, drop, keep)
        })

      case char {
        Some(char) -> keep_wip(state, char)
        None -> drop_wip(state)
      }
    }
  }
}

fn find_special(line_index, line, start, length) -> Option(#(Int, Int, String)) {
  case line {
    Ok(line) ->
      line
      |> list.drop(start)
      |> list.take(length)
      |> list.index_map(fn(i, x) { #(int.max(start, 0) + i, x) })
      |> list.filter_map(fn(x) {
        let assert #(i, c) = x

        case classify_token(c) {
          Special -> Ok(#(i, line_index, c))
          _ -> Error(Nil)
        }
      })
      |> list.first()
      |> option.from_result()

    Error(Nil) -> None
  }
}
