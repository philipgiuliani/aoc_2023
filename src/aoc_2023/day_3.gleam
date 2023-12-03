import gleam/string
import gleam/int
import gleam/result
import gleam/list
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
  |> list.map(fn(p) { int.undigits(p.number, 10) })
  |> result.values()
  |> int.sum()
}

pub fn pt_2(input: String) {
  input
  |> parse()
  |> list.filter(fn(p) { list.length(p.number) == 2 && p.char == "*" })
  |> list.map(fn(p) {
    let assert [a, b] = p.number
    a * b
  })
  |> int.sum()
}

type Part {
  Part(number: List(Int), char: String)
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
) -> List(Part) {
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
  let assert Ok(number) = int.parse(number)

  let wip = case state.wip {
    None -> Some(#(index, [number]))
    Some(wip) -> Some(#(wip.0, [number, ..wip.1]))
  }

  State(..state, wip: wip)
}

fn keep_wip(state: State, char: String) {
  let assert Some(#(_, number)) = state.wip
  let number = list.reverse(number)

  State(wip: None, found: [Part(number, char), ..state.found])
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
        0 -> list.length(value) + 1
        _ -> list.length(value) + 2
      }

      let char =
        find_special(prev_line, drop, keep)
        |> option.lazy_or(fn() { find_special(current_line, drop, keep) })
        |> option.lazy_or(fn() { find_special(next_line, drop, keep) })

      case char {
        Some(char) -> keep_wip(state, char)
        None -> drop_wip(state)
      }
    }
  }
}

fn find_special(line, start, length) -> Option(String) {
  case line {
    Ok(line) ->
      line
      |> list.drop(start)
      |> list.take(length)
      |> list.find(fn(c) { classify_token(c) == Special })
      |> option.from_result()

    Error(Nil) -> None
  }
}
