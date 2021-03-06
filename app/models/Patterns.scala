package models

import wasabi.perceptron.Pattern

object Patterns {

  val DIGITS_0_TO_9 = List(
    Pattern(List(.0,1.0,1.0,1.0,.0,1.0,1.0,.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0,.0,.0,1.0,.0,1.0,1.0,1.0,.0),        List(1.0,.0,.0,.0,.0,.0,.0,.0,.0,.0)),
    Pattern(List(1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,1.0,1.0,1.0,1.0),    List(.0,1.0,.0,.0,.0,.0,.0,.0,.0,.0)),
    Pattern(List(1.0,1.0,1.0,.0,.0,.0,.0,1.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,1.0,1.0,1.0,1.0,.0,1.0,.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,1.0),         List(.0,.0,1.0,.0,.0,.0,.0,.0,.0,.0)),
    Pattern(List(1.0,1.0,1.0,1.0,.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,1.0,1.0,.0,.0,1.0,1.0,1.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0),        List(.0,.0,.0,1.0,.0,.0,.0,.0,.0,.0)),
    Pattern(List(1.0,.0,.0,1.0,.0,1.0,.0,.0,1.0,.0,1.0,.0,.0,1.0,.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0),              List(.0,.0,.0,.0,1.0,.0,.0,.0,.0,.0)),
    Pattern(List(1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0),         List(.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0)),
    Pattern(List(.0,1.0,1.0,1.0,.0,1.0,1.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,.0,.0,1.0,.0,1.0,1.0,1.0,1.0),     List(.0,.0,.0,.0,.0,.0,1.0,.0,.0,.0)),
    Pattern(List(1.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,.0,.0,.0),              List(.0,.0,.0,.0,.0,.0,.0,1.0,.0,.0)),
    Pattern(List(1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0), List(.0,.0,.0,.0,.0,.0,.0,.0,1.0,.0)),
    Pattern(List(1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0),          List(.0,.0,.0,.0,.0,.0,.0,.0,.0,1.0))
  )

  val VARIOUS_SYMBOLS = List(
    // :-| indifference
    Pattern(List(1.0,1.0,.0,1.0,1.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0),                    List(1.0,.0,.0,.0,.0,.0,.0,.0,.0,.0)),
    // :-) happiness
    Pattern(List(1.0,1.0,.0,1.0,1.0,1.0,1.0,.0,1.0,1.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,1.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0),               List(.0,1.0,.0,.0,.0,.0,.0,.0,.0,.0)),
    // :-( sadness
    Pattern(List(1.0,.0,.0,.0,1.0,.0,.0,.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,1.0),                      List(.0,.0,1.0,.0,.0,.0,.0,.0,.0,.0)),
    // 8-O astonishment
    Pattern(List(1.0,1.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,1.0,1.0,1.0,.0,.0,1.0,.0,1.0,.0,.0,1.0,1.0,1.0,.0),              List(.0,.0,.0,1.0,.0,.0,.0,.0,.0,.0)),
    // love (a heart)
    Pattern(List(1.0,1.0,1.0,1.0,1.0,1.0,.0,1.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0,.0,1.0,1.0,.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0),           List(.0,.0,.0,.0,1.0,.0,.0,.0,.0,.0)),
    // death (a skull)
    Pattern(List(1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,.0,.0,1.0,1.0,1.0,.0), List(.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0)),
    // :-/ skepticism
    Pattern(List(1.0,.0,.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,.0,.0,1.0,1.0,1.0,.0,.0,1.0,1.0,.0,.0,1.0,1.0,.0,.0,1.0,1.0,.0,.0,.0),                List(.0,.0,.0,.0,.0,.0,1.0,.0,.0,.0)),
    // the sun
    Pattern(List(.0,.0,1.0,.0,.0,1.0,1.0,1.0,.0,1.0,.0,1.0,1.0,1.0,1.0,.0,1.0,.0,1.0,.0,1.0,1.0,.0,1.0,1.0,.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0),         List(.0,.0,.0,.0,.0,.0,.0,1.0,.0,.0)),
    // big ben
    Pattern(List(.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0,1.0,.0,.0,.0,1.0),     List(.0,.0,.0,.0,.0,.0,.0,.0,1.0,.0)),
    // laughing
    Pattern(List(1.0,1.0,.0,.0,1.0,1.0,1.0,1.0,.0,1.0,.0,.0,1.0,.0,.0,.0,.0,1.0,.0,.0,1.0,1.0,1.0,.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,.0,.0,.0,1.0,1.0,1.0,1.0,1.0,1.0),         List(.0,.0,.0,.0,.0,.0,.0,.0,.0,1.0))
  )

}
