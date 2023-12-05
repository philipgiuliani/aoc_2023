import gleam/list
import gleam/string
import gleam/int
import gleam/dict.{type Dict}

type Data {
  Data(
    seeds: List(Int),
    seed_to_soil: Dict(Int, Int),
    soil_to_fertilizer: Dict(Int, Int),
    fertilizer_to_water: Dict(Int, Int),
    water_to_light: Dict(Int, Int),
    light_to_temperature: Dict(Int, Int),
    temperature_to_humidity: Dict(Int, Int),
    humidity_to_location: Dict(Int, Int),
  )
}

fn empty_data() -> Data {
  Data(
    seeds: [],
    seed_to_soil: dict.new(),
    soil_to_fertilizer: dict.new(),
    fertilizer_to_water: dict.new(),
    water_to_light: dict.new(),
    light_to_temperature: dict.new(),
    temperature_to_humidity: dict.new(),
    humidity_to_location: dict.new(),
  )
}

pub fn pt_1(input: String) {
  let data = parse_input(input)

  use acc, seed <- list.fold(data.seeds, 9_999_999_999)

  seed
  |> find_destination(data.seed_to_soil)
  |> find_destination(data.soil_to_fertilizer)
  |> find_destination(data.fertilizer_to_water)
  |> find_destination(data.water_to_light)
  |> find_destination(data.light_to_temperature)
  |> find_destination(data.temperature_to_humidity)
  |> find_destination(data.humidity_to_location)
  |> int.min(acc)
}

pub fn pt_2(input: String) {
  todo
}

fn find_destination(source: Int, dict: Dict(Int, Int)) -> Int {
  case dict.get(dict, source) {
    Ok(dest) -> dest
    Error(Nil) -> source
  }
}

fn parse_input(input: String) -> Data {
  let blocks = string.split(input, "\n\n")
  use acc, block <- list.fold(blocks, empty_data())

  case block {
    "seeds: " <> data -> {
      let seeds =
        data
        |> string.split(" ")
        |> list.filter_map(int.parse)

      Data(..acc, seeds: seeds)
    }
    "seed-to-soil map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, seed_to_soil: data)
    }
    "soil-to-fertilizer map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, soil_to_fertilizer: data)
    }
    "fertilizer-to-water map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, fertilizer_to_water: data)
    }
    "water-to-light map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, water_to_light: data)
    }
    "light-to-temperature map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, light_to_temperature: data)
    }
    "temperature-to-humidity map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, temperature_to_humidity: data)
    }
    "humidity-to-location map:\n" <> data -> {
      let data = parse_dict(data)
      Data(..acc, humidity_to_location: data)
    }
    _ -> panic
  }
}

fn parse_dict(input: String) -> Dict(Int, Int) {
  let lines = string.split(input, "\n")
  use acc, line <- list.fold(lines, dict.new())

  let [from, to, count] =
    line
    |> string.split(" ")
    |> list.filter_map(int.parse)

  from
  |> list.range(from + count - 1)
  |> list.index_fold(
    acc,
    fn(acc, el, index) { dict.insert(acc, to + index, el) },
  )
}
