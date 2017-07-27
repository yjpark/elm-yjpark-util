module YJPark.Mdl.Json exposing (..)
import YJPark.Mdl.Types exposing (..)
import YJPark.Json as Json

import Html exposing (..)

import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table
import Material.Color as Color
import Material.Typography as Typography
import Material.Card as Card


type alias Value = Json.Value


renderAll : Renderer Json.Value msg
renderAll events mdl obj =
    text (toString obj)


renderBool : String -> Renderer Json.Value msg
renderBool field events mdl obj =
    text <| toString <| Json.getBool field obj


renderInt : String -> Renderer Json.Value msg
renderInt field events mdl obj =
    text <| toString <| Json.getInt field obj


renderFloat : String -> Renderer Json.Value msg
renderFloat field events mdl obj =
    text <| toString <| Json.getFloat field obj


renderString : String -> Renderer Json.Value msg
renderString field events mdl obj =
    text <| Json.getString field obj


renderValue : String -> Renderer Json.Value msg
renderValue field events mdl obj =
    text <| toString <| Json.getValue field obj


renderStringWithFallbacks : List String -> Renderer Json.Value msg
renderStringWithFallbacks fields events mdl obj =
    let
        do_render = (\field result ->
                case result of
                    "" ->
                        Json.getString field obj
                    _ ->
                        result
            )
    in
        fields
            |> List.foldl do_render ""
            |> text



