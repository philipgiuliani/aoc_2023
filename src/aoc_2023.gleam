import gleam/io

pub fn main() {
  io.println("Hello from aoc_2023!")
}

@external(erlang, "timer", "tc")
pub fn benchmark(callback: fn() -> a) -> #(Int, a)
