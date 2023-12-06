import gleam/list
import gleam/string
import gleam/int

type Mapping {
  Mapping(source: Int, destination: Int, count: Int)
}

type Data {
  Data(
    seeds: List(Int),
    seed_to_soil: List(Mapping),
    soil_to_fertilizer: List(Mapping),
    fertilizer_to_water: List(Mapping),
    water_to_light: List(Mapping),
    light_to_temperature: List(Mapping),
    temperature_to_humidity: List(Mapping),
    humidity_to_location: List(Mapping),
  )
}

fn empty_data() -> Data {
  Data(
    seeds: [],
    seed_to_soil: [],
    soil_to_fertilizer: [],
    fertilizer_to_water: [],
    water_to_light: [],
    light_to_temperature: [],
    temperature_to_humidity: [],
    humidity_to_location: [],
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

pub fn pt_2(_input: String) {
  -1
}

fn find_destination(source: Int, mappings: List(Mapping)) -> Int {
  let mapping =
    list.find(
      mappings,
      fn(mapping) {
        source >= mapping.source && source < mapping.source + mapping.count
      },
    )

  case mapping {
    Ok(mapping) -> {
      let distance = source - mapping.source
      mapping.destination + distance
    }

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
      let data = parse_mappings(data)
      Data(..acc, seed_to_soil: data)
    }
    "soil-to-fertilizer map:\n" <> data -> {
      let data = parse_mappings(data)
      Data(..acc, soil_to_fertilizer: data)
    }
    "fertilizer-to-water map:\n" <> data -> {
      let data = parse_mappings(data)
      Data(..acc, fertilizer_to_water: data)
    }
    "water-to-light map:\n" <> data -> {
      let data = parse_mappings(data)
      Data(..acc, water_to_light: data)
    }
    "light-to-temperature map:\n" <> data -> {
      let data = parse_mappings(data)
      Data(..acc, light_to_temperature: data)
    }
    "temperature-to-humidity map:\n" <> data -> {
      let data = parse_mappings(data)
      Data(..acc, temperature_to_humidity: data)
    }
    "humidity-to-location map:\n" <> data -> {
      let data = parse_mappings(data)
      Data(..acc, humidity_to_location: data)
    }
    _ -> panic
  }
}

fn parse_mappings(input: String) -> List(Mapping) {
  let lines = string.split(input, "\n")
  use line <- list.map(lines)

  let [destination, source, count] =
    line
    |> string.split(" ")
    |> list.filter_map(int.parse)

  Mapping(source: source, destination: destination, count: count)
}
