import gleam/string
import gleam/list
import gleam/int
import gleam/iterator

type Race {
  Race(time: Int, record: Int)
}

pub fn pt_1(input: String) {
  input
  |> parse_pt1()
  |> list.map(find_winning_strats)
  |> int.product()
}

pub fn pt_2(input: String) {
  input
  |> parse_pt2()
  |> find_winning_strats()
}

fn find_winning_strats(race: Race) -> Int {
  1
  |> iterator.range(race.time)
  |> iterator.fold_until(0, fn(acc, speed) {
    let remaining = race.time - speed
    let distance = remaining * speed

    case distance > race.record {
      True -> list.Continue(acc + 1)
      False -> {
        case acc {
          0 -> list.Continue(acc)
          _ -> list.Stop(acc)
        }
      }
    }
  })
}

fn parse_pt1(input: String) -> List(Race) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert Ok(#(_, data)) = string.split_once(line, ":")

    data
    |> string.split(" ")
    |> list.filter_map(int.parse)
  })
  |> list.transpose()
  |> list.map(fn(data) {
    let assert [time, record] = data
    Race(time: time, record: record)
  })
}

fn parse_pt2(input: String) -> Race {
  let assert Ok([time, record]) =
    input
    |> string.split("\n")
    |> list.try_map(fn(line) {
      let assert Ok(#(_, data)) = string.split_once(line, ":")

      data
      |> string.replace(" ", "")
      |> int.parse()
    })

  Race(time: time, record: record)
}
