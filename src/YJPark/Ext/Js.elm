module YJPark.Ext.Js exposing (..)
import YJPark.Json as Json
import YJPark.Data as Data

import Native.Ext


openUrl : String -> String -> String
openUrl = Native.Ext.open_url
