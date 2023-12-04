import gleam/list
import gleam/string
import gleam/int
import gleam/set
import gleam/float
import gleam/pair

type Game {
  Game(id: Int, winning_numbers: List(Int), my_numbers: List(Int))
}

pub fn pt_1(input: String) {
  input
  |> parse()
  |> list.map(fn(game) {
    game
    |> count_matches()
    |> calc_score()
  })
  |> int.sum()
}

pub fn pt_2(input: String) {
  input
  |> parse()
  |> list.fold(
    #([], 0),
    fn(acc, game) {
      let #(counts, total_cards) = acc
      let #(count, rest) = case counts {
        [count, ..rest] -> #(count + 1, rest)
        [] -> #(1, [])
      }

      let matches = count_matches(game)

      let new_counts =
        [rest, list.repeat(count, times: matches)]
        |> list.transpose()
        |> list.map(int.sum)

      #(new_counts, count + total_cards)
    },
  )
  |> pair.second()
}

fn calc_score(matches: Int) -> Int {
  let assert Ok(val) = int.power(2, int.to_float(matches - 1))
  float.truncate(val)
}

fn count_matches(game: Game) -> Int {
  set.intersection(
    set.from_list(game.winning_numbers),
    set.from_list(game.my_numbers),
  )
  |> set.size()
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
