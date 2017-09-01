module YJPark.WeUi.TabBar exposing (..)
import YJPark.WeUi.Types exposing (..)
import YJPark.WeUi.Model as Model

import Html exposing (..)
import Material.Options as Options exposing (when, css)

import List


renderTabBar : Model.Tabs -> Html msg
renderTabBar tabs =
    Options.div []
    (tabs
        |> List.map (\t -> text t.title))
