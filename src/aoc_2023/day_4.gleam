import gleam/list
import gleam/string
import gleam/int
import gleam/set
import gleam/float

type Game {
  Game(id: Int, winning_numbers: List(Int), my_numbers: List(Int))
}

pub fn pt_1(input: String) {
  input
  |> parse()
  |> list.map(fn(game) {
    let numbers =
      set.intersection(
        set.from_list(game.winning_numbers),
        set.from_list(game.my_numbers),
      )

    let assert Ok(val) = int.power(2, int.to_float(set.size(numbers) - 1))
    float.truncate(val)
  })
  |> int.sum()
}

pub fn pt_2(input: String) {
  todo
}

fn parse(input: String) -> List(Game) {
  input
  |> string.split("\n")
  |> list.map(fn(input) {
    let assert Ok(#("Card " <> id, values)) = string.split_once(input, ": ")
    let assert Ok(id) = int.parse(string.trim(id))
    let assert Ok(#(winning_numbers, my_numbers)) =
      string.split_once(values, " | ")

    Game(
      id: id,
      winning_numbers: parse_numbers(winning_numbers),
      my_numbers: parse_numbers(my_numbers),
    )
  })
}

fn parse_numbers(input: String) -> List(Int) {
  input
  |> string.split(" ")
  |> list.map(string.trim)
  |> list.filter_map(int.parse)
}
