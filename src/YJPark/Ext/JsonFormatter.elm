module YJPark.Ext.JsonFormatter exposing (..)
import YJPark.Json as Json
import YJPark.Data as Data

import Native.Ext


render : String -> Json.Value -> Int -> String
render = Native.Ext.render_json


renderWithConfig : String -> Json.Value -> Int -> Json.Value -> String
renderWithConfig = Native.Ext.render_json_with_config


noConfig : Json.Value
noConfig =
    Data.empty
        |> Data.toValue
