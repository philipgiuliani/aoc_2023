import gleam/list
import gleam/string
import gleam/int
import gleam/order.{type Order}
import gleam/dict
import gleam/option.{None, Some}
import gleam/iterator

type Hand {
  Hand(cards: List(Int), bid: Int)
}

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_hand)
  |> list.sort(compare_hand)
  |> list.index_fold(0, fn(acc, hand, i) { acc + hand.bid * { i + 1 } })
}

pub fn pt_2(input: String) {
  todo
}

fn parse_hand(input: String) -> Hand {
  let assert Ok(#(cards, bid)) = string.split_once(input, " ")
  let assert Ok(bid) = int.parse(bid)

  let cards =
    cards
    |> string.split("")
    |> list.map(card_to_int)

  Hand(cards: cards, bid: bid)
}

fn card_to_int(card: String) -> Int {
  case card {
    "A" -> 14
    "K" -> 13
    "Q" -> 12
    "J" -> 11
    "T" -> 10
    "9" -> 9
    "8" -> 8
    "7" -> 7
    "6" -> 6
    "5" -> 5
    "4" -> 4
    "3" -> 3
    "2" -> 2
    _ -> panic
  }
}

fn compare_hand(a: Hand, with b: Hand) -> Order {
  let a_score = score_hand(a)
  let b_score = score_hand(b)

  case a_score, b_score {
    a, b if a > b -> order.Gt
    a, b if a < b -> order.Lt
    _, _ -> compare_higher_card(a, b)
  }
}

fn score_hand(hand: Hand) -> Int {
  let frequencies =
    hand.cards
    |> list.fold(dict.new(), fn(acc, card) {
      dict.update(acc, card, fn(cur) {
        case cur {
          Some(i) -> i + 1
          None -> 1
        }
      })
    })
    |> dict.values()
    |> list.sort(fn(a, b) {
      int.compare(a, b)
      |> order.negate()
    })

  case frequencies {
    // five of a kind
    [5] -> 7
    // four of a kind
    [4, 1] -> 6
    // full house
    [3, 2] -> 5
    // three of a kind
    [3, ..] -> 4
    // two pair
    [2, 2, 1] -> 3
    // one pair
    [2, ..] -> 2
    // nothing
    _ -> 1
  }
}

fn compare_higher_card(a: Hand, b: Hand) -> Order {
  let a = iterator.from_list(a.cards)
  let b = iterator.from_list(b.cards)

  let assert Ok(comparison) =
    iterator.map2(a, b, int.compare)
    |> iterator.find(fn(o) { o != order.Eq })

  comparison
}
