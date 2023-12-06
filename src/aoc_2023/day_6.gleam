import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/iterator

type Race {
  Race(time: Int, record: Int)
}

pub fn pt_1(input: String) {
  input
  |> parse()
  |> list.map(find_winning_strats)
  |> int.product()
}

pub fn pt_2(input: String) {
  todo
}

fn find_winning_strats(race: Race) -> Int {
  1
  |> iterator.range(race.time)
  |> iterator.filter(fn(speed) {
    let remaining = race.time - speed
    let distance = remaining * speed

    distance > race.record
  })
  |> iterator.length()
}

fn parse(input: String) -> List(Race) {
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
