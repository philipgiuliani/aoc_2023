import gleam/string
import gleam/list
import gleam/int
import gleam/result
import gleam/dict
import gleam/option.{None, Some}

pub opaque type Game {
  Game(id: Int, r: Int, g: Int, b: Int)
}

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_game)
  |> list.filter(fn(game) { game.r <= 12 && game.g <= 13 && game.b <= 14 })
  |> list.map(fn(game) { game.id })
  |> int.sum()
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_game)
  |> list.map(fn(game) { game.r * game.g * game.b })
  |> int.sum()
}

fn parse_game(line: String) -> Game {
  let assert Ok(#("Game " <> game_id, subsets)) = string.split_once(line, ": ")
  let assert Ok(game_id) = int.parse(game_id)

  let colors =
    subsets
    |> string.split("; ")
    |> list.flat_map(string.split(_, ", "))
    |> list.fold(
      dict.new(),
      fn(acc, el) {
        let assert [count, color] = string.split(el, " ")
        let assert Ok(count) = int.parse(count)

        dict.update(
          acc,
          color,
          fn(current) {
            case current {
              Some(cur) -> int.max(cur, count)
              None -> count
            }
          },
        )
      },
    )

  Game(
    id: game_id,
    r: result.unwrap(dict.get(colors, "red"), 0),
    g: result.unwrap(dict.get(colors, "green"), 0),
    b: result.unwrap(dict.get(colors, "blue"), 0),
  )
}
