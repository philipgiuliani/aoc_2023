import gleam/string
import gleam/list
import gleam/int
import gleam/result

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(line_to_number)
  |> int.sum()
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.to_graphemes()
    |> line_to_numbers([])
    |> solve()
  })
  |> int.sum()
}

fn line_to_number(line: String) -> Int {
  line
  |> string.to_graphemes()
  |> list.map(int.parse)
  |> result.values()
  |> solve()
}

fn solve(numbers: List(Int)) -> Int {
  let assert Ok(result) =
    [list.first(numbers), list.last(numbers)]
    |> result.values()
    |> int.undigits(10)

  result
}

fn line_to_numbers(rest: List(String), numbers: List(Int)) -> List(Int) {
  let next =
    list.rest(rest)
    |> result.unwrap([])

  case rest {
    [] -> list.reverse(numbers)
    ["1", ..] -> line_to_numbers(next, [1, ..numbers])
    ["2", ..] -> line_to_numbers(next, [2, ..numbers])
    ["3", ..] -> line_to_numbers(next, [3, ..numbers])
    ["4", ..] -> line_to_numbers(next, [4, ..numbers])
    ["5", ..] -> line_to_numbers(next, [5, ..numbers])
    ["6", ..] -> line_to_numbers(next, [6, ..numbers])
    ["7", ..] -> line_to_numbers(next, [7, ..numbers])
    ["8", ..] -> line_to_numbers(next, [8, ..numbers])
    ["9", ..] -> line_to_numbers(next, [9, ..numbers])
    ["o", "n", "e", ..] -> line_to_numbers(next, [1, ..numbers])
    ["t", "w", "o", ..] -> line_to_numbers(next, [2, ..numbers])
    ["t", "h", "r", "e", "e", ..] -> line_to_numbers(next, [3, ..numbers])
    ["f", "o", "u", "r", ..] -> line_to_numbers(next, [4, ..numbers])
    ["f", "i", "v", "e", ..] -> line_to_numbers(next, [5, ..numbers])
    ["s", "i", "x", ..] -> line_to_numbers(next, [6, ..numbers])
    ["s", "e", "v", "e", "n", ..] -> line_to_numbers(next, [7, ..numbers])
    ["e", "i", "g", "h", "t", ..] -> line_to_numbers(next, [8, ..numbers])
    ["n", "i", "n", "e", ..] -> line_to_numbers(next, [9, ..numbers])
    [_, ..] -> line_to_numbers(next, numbers)
  }
}
