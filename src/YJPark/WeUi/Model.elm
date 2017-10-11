module YJPark.WeUi.Model exposing (..)

import YJPark.Util exposing (..)

import List


type alias DialogMeta =
    { id : String
    , title : String
    , content : String
    , ok : String
    , cancel : Maybe String
    }


type alias Tab =
    { title : String
    , image : String
    , selectedImage : Maybe String
    }


type alias Tabs = List Tab


type alias Type =
    { tabs : Tabs
    , current_tab : Int
    , dialog : Maybe DialogMeta
    }


null =
    { tabs = []
    , current_tab = 0
    , dialog = Nothing
    }


setDialog : DialogMeta -> Type -> Type
setDialog dialog model =
    { model
    | dialog = Just dialog
    }
