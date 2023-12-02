import gleam/string
import gleam/list
import gleam/int
import gleam/result
import gleam/dict
import gleam/option.{None, Some}

type Subset {
  Subset(r: Int, g: Int, b: Int)
}

pub opaque type Game {
  Game(id: Int, subsets: List(Subset))
}

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_game)
  |> list.filter(fn(game) {
    list.all(
      game.subsets,
      fn(subset) { subset.r <= 12 && subset.g <= 13 && subset.b <= 14 },
    )
  })
  |> list.map(fn(game) { game.id })
  |> int.sum()
}

pub fn pt_2(input: String) {
  todo
}

fn parse_game(line: String) -> Game {
  let assert Ok(#("Game " <> game_id, subsets)) = string.split_once(line, ": ")
  let assert Ok(game_id) = int.parse(game_id)

  let subsets =
    subsets
    |> string.split("; ")
    |> list.map(fn(subset) {
      let colors =
        subset
        |> string.split(", ")
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
                  Some(cur) -> cur + count
                  None -> count
                }
              },
            )
          },
        )

      Subset(
        r: result.unwrap(dict.get(colors, "red"), 0),
        g: result.unwrap(dict.get(colors, "green"), 0),
        b: result.unwrap(dict.get(colors, "blue"), 0),
      )
    })

  Game(id: game_id, subsets: subsets)
}
