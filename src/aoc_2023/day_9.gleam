import gleam/string
import gleam/list
import gleam/int
import gleam/io

pub fn pt_1(input: String) {
  input
  |> parse()
  |> list.map(fn(sequence) {
    [sequence]
    |> build_tree()
    |> find_next_sequence()
  })
  |> int.sum()
}

pub fn pt_2(input: String) {
  todo
}

fn parse(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter_map(int.parse)
    |> list.reverse()
  })
}

fn build_tree(items: List(List(Int))) -> List(List(Int)) {
  let assert [head, ..] = items
  let #(count, next) =
    head
    |> list.window_by_2()
    |> list.map_fold(0, fn(acc, el) {
      let value = el.0 - el.1
      #(acc + value, value)
    })

  case count == 0 {
    True -> [next, ..items]
    False -> build_tree([next, ..items])
  }
}

fn find_next_sequence(items: List(List(Int))) -> Int {
  io.debug(items)
  list.fold(items, 0, fn(acc, sequence) {
    let assert Ok(cur) = list.first(sequence)
    acc + cur
  })
}
