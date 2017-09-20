module YJPark.Mdl.Action exposing (..)
import YJPark.Mdl.Types exposing (..)
import YJPark.Mdl.Events as MdlEvents
import YJPark.Events as Events

import Html exposing (..)
import Html.Events

import Material
import Material.Color as Color exposing (Color)
import Material.Icon as Icon
import Material.Button as Button
import Material.List as Lists
import Material.Options as Options exposing (when, css)


-- icon, disabled, options
type alias Meta msg = (String, Bool, List (Button.Property msg))


renderAction : (Meta msg) -> List Int -> Renderer (WithIndex obj) msg
renderAction (icon, disabled, options) index events mdl obj =
    Button.render mdl.wrapper (obj.index ++ index) mdl.mdl
        ([ Button.icon
        , Button.colored
        , Button.disabled |> when (disabled)
        , MdlEvents.onClickOption events obj
        ] ++ options)
        [ Icon.i icon ]


appendAction meta index events mdl obj list =
    case meta of
        Nothing ->
            list
        Just action ->
            list ++ [ renderAction action index events mdl obj ]
