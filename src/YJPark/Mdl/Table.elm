module YJPark.Mdl.Table exposing (..)
import YJPark.Mdl.Types exposing (..)

import Html exposing (..)

import Material
import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table


type alias CellMeta obj msg = (String, Bool, Renderer obj msg)


toTable : List (CellMeta obj msg) -> Events obj msg -> Type msg -> List obj -> Html msg
toTable cells events mdl objects =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                (cells
                    |> List.map (\(title, is_numeric, _) ->
                        case is_numeric of
                            True ->
                                Table.th [ Table.numeric ] [ text title ]
                            False ->
                                Table.th [] [ text title ]))
            ]
        , Table.tbody []
            (objects
                |> List.map (toTableRow cells events mdl))
        ]


toTableCell : CellMeta obj msg -> Renderer obj msg
toTableCell (title, is_numeric, renderer) events mdl obj =
    case is_numeric of
        True ->
            Table.td [ Table.numeric ] [ renderer events mdl obj ]
        False ->
            Table.td [] [ renderer events mdl obj ]


toTableRow : List (CellMeta obj msg) -> Renderer obj msg
toTableRow cells events mdl obj =
    Table.tr []
        (cells
            |> List.map (\cell -> toTableCell cell events mdl obj))

