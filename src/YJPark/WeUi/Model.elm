module YJPark.WeUi.Model exposing (..)

import YJPark.Util exposing (..)

import List


type alias Tab =
    { title : String
    , image : String
    }


type alias Tabs = List Tab


type alias Type =
    { tabs : Tabs
    , current_tab : Int
    }


null =
    { tabs = []
    , current_tab = 0
    }
