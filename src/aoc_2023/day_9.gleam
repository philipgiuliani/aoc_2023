import gleam/string
import gleam/list
import gleam/int

pub fn pt_1(input: String) {
  input
  |> parse()
  |> list.map(list.reverse)
  |> solve()
}

pub fn pt_2(input: String) {
  input
  |> parse()
  |> solve()
}

fn solve(sequences: List(List(Int))) -> Int {
  sequences
  |> list.map(fn(sequence) {
    [sequence]
    |> build_tree()
    |> find_next_sequence()
  })
  |> int.sum()
}

fn parse(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter_map(int.parse)
  })
}

fn build_tree(items: List(List(Int))) -> List(List(Int)) {
  let assert [head, ..] = items
  let #(only_zeros, next) =
    head
    |> list.window_by_2()
    |> list.map_fold(True, fn(acc, el) {
      let value = el.0 - el.1
      #(acc && value == 0, value)
    })

  case only_zeros {
    True -> [next, ..items]
    False -> build_tree([next, ..items])
  }
}

fn find_next_sequence(items: List(List(Int))) -> Int {
  list.fold(items, 0, fn(acc, sequence) {
    let assert Ok(cur) = list.first(sequence)
    acc + cur
  })
}
