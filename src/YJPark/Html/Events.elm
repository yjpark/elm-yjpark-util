module YJPark.Html.Events exposing (..)

import YJPark.Util exposing (..)

import Json.Decode as Decode
import Html
import Html.Events


--https://groups.google.com/forum/#!topic/elm-discuss/yzIiqZ30qdg
type alias ScrollEvent =
  { scrollHeight : Int
  , scrollPos : Int
  , visibleHeight : Int
  }


onScroll : (ScrollEvent -> msg) -> Html.Attribute msg
onScroll tagger =
  Html.Events.on "scroll" (Decode.map tagger onScrollJsonParser)


onScrollJsonParser : Decode.Decoder ScrollEvent
onScrollJsonParser =
  Decode.map3 ScrollEvent
    (Decode.at ["target", "scrollHeight"] Decode.int)
    (Decode.at ["target", "scrollTop"] Decode.int)
    (Decode.at ["target", "clientHeight"] Decode.int)
