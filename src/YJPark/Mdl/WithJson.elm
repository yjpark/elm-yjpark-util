module YJPark.Mdl.WithJson exposing (..)
import YJPark.Mdl.Types exposing (..)
import YJPark.Mdl.Events as Events
import YJPark.Mdl.Json as MdlJson
import YJPark.Json as Json exposing (WithJson)

import Html exposing (..)

import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table
import Material.Color as Color
import Material.Typography as Typography
import Material.Card as Card


withJson : Renderer Json.Value msg -> Renderer (WithJson m) msg
withJson renderer events mdl obj =
    let
        wrapped_events = events
            |> Events.wrap (\json -> { obj | json = json})
    in
        renderer wrapped_events mdl obj.json


renderAll : Renderer (WithJson m) msg
renderAll =
    withJson MdlJson.renderAll


renderBool : String -> Renderer (WithJson m) msg
renderBool field =
    withJson <| MdlJson.renderBool field


renderInt : String -> Renderer (WithJson m) msg
renderInt field =
    withJson <| MdlJson.renderInt field


renderFloat : String -> Renderer (WithJson m) msg
renderFloat field =
    withJson <| MdlJson.renderFloat field


renderString : String -> Renderer (WithJson m) msg
renderString field =
    withJson <| MdlJson.renderString field


renderValue : String -> Renderer (WithJson m) msg
renderValue field =
    withJson <| MdlJson.renderValue field


renderStringWithFallbacks : List String -> Renderer (WithJson m) msg
renderStringWithFallbacks fields =
    withJson <| MdlJson.renderStringWithFallbacks fields
