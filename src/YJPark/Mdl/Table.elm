module YJPark.Mdl.Table exposing (..)
import YJPark.Mdl.Types exposing (..)

import Html exposing (..)

import Material
import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table


type alias CellMeta obj msg = (String, Bool, Renderer obj msg) -- title, is_numeric renderer


renderTable : List (CellMeta obj msg) -> Events obj msg -> Type msg -> List obj -> Html msg
renderTable cells events mdl objects =
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
                |> List.map (renderTableRow cells events mdl))
        ]


renderTableCell : CellMeta obj msg -> Renderer obj msg
renderTableCell (title, is_numeric, renderer) events mdl obj =
    case is_numeric of
        True ->
            Table.td [ Table.numeric ] [ renderer events mdl obj ]
        False ->
            Table.td [] [ renderer events mdl obj ]


renderTableRow : List (CellMeta obj msg) -> Renderer obj msg
renderTableRow cells events mdl obj =
    Table.tr []
        (cells
            |> List.map (\cell -> renderTableCell cell events mdl obj))

