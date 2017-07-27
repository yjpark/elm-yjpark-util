module YJPark.Mdl.Page exposing (..)
import YJPark.Mdl.Types exposing (..)

import Html exposing (..)

import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table
import Material.Color as Color
import Material.Typography as Typography
import Material.Card as Card


renderSpace : String -> Html msg
renderSpace height =
    Options.div
        [ css "height" height ]
        [ ]


renderHeadline : String -> Html msg
renderHeadline title =
    Options.span
        [ Typography.headline
        , Color.text Color.primary
        ]
        [ text title ]


renderTitle : String -> Html msg
renderTitle title =
    Options.div
        [ Typography.title
        , Color.text Color.primary
        ]
        [ text title ]


renderCard : String -> String -> List (Html msg) -> Html msg
renderCard width title content =
  Card.view
    [ css "width" width ]
    [ Card.title
        [ css "flex-direction" "column" ]
        [ Card.head [ ] [ text title ]
        --, Card.subhead [ ] [ text "Wed, 14:55, mostly cloudy" ]
        ]
    , Card.actions [ ]
        content
    ]

