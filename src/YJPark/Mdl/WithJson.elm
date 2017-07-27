module YJPark.Mdl.WithJson exposing (..)
import YJPark.Mdl.Types exposing (..)
import YJPark.Mdl.Events as Events
import YJPark.Mdl.Json as Json

import Html exposing (..)

import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table
import Material.Color as Color
import Material.Typography as Typography
import Material.Card as Card


type alias WithJson m =
    { m | json : Json.Value }


withJson : Renderer Json.Value msg -> Renderer (WithJson m) msg
withJson renderer events mdl obj =
    let
        wrapped_events = events
            |> Events.wrap (\json -> { obj | json = json})
    in
        renderer wrapped_events mdl obj.json


renderAll : Renderer (WithJson m) msg
renderAll =
    withJson Json.renderAll


renderBool : String -> Renderer (WithJson m) msg
renderBool field =
    withJson <| Json.renderBool field


renderInt : String -> Renderer (WithJson m) msg
renderInt field =
    withJson <| Json.renderInt field


renderFloat : String -> Renderer (WithJson m) msg
renderFloat field =
    withJson <| Json.renderFloat field


renderString : String -> Renderer (WithJson m) msg
renderString field =
    withJson <| Json.renderString field


renderValue : String -> Renderer (WithJson m) msg
renderValue field =
    withJson <| Json.renderValue field


renderStringWithFallbacks : List String -> Renderer (WithJson m) msg
renderStringWithFallbacks fields =
    withJson <| Json.renderStringWithFallbacks fields
