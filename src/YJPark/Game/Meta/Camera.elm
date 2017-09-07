module YJPark.Game.Meta.Camera exposing (..)
import YJPark.Game.Consts exposing (..)

import YJPark.Data as Data exposing (Data)


type Kind
    = FixedWidth
    | FixedHeight


type alias Type =
    { kind : Kind
    , data : Data
    }


fixedWidth : Int -> (Int, Int) -> Type
fixedWidth w (x, y) =
    { kind = FixedWidth
    , data = Data.empty
        |> Data.insertInt key_width w
        |> Data.insertInt key_x x
        |> Data.insertInt key_y y
    }


fixedHeight : Int -> (Int, Int) -> Type
fixedHeight h (x, y) =
    { kind = FixedHeight
    , data = Data.empty
        |> Data.insertInt key_height h
        |> Data.insertInt key_x x
        |> Data.insertInt key_y y
    }

