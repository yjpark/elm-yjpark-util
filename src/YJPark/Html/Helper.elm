module YJPark.Html.Helper exposing (..)

import YJPark.Util exposing (..)

import Json.Decode as Decode
import Html
import Http
import Dict exposing (Dict)


--Copied from UrlParser, which is internal
parseParams : String -> Dict String String
parseParams queryString =
  queryString
    |> String.dropLeft 1
    |> String.split "&"
    |> List.filterMap toKeyValuePair
    |> Dict.fromList


--Copied from UrlParser, which is internal
toKeyValuePair : String -> Maybe (String, String)
toKeyValuePair segment =
  case String.split "=" segment of
    [key, value] ->
      Maybe.map2 (,) (Http.decodeUri key) (Http.decodeUri value)

    _ ->
      Nothing

