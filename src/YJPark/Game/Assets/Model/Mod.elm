module YJPark.Game.Assets.Model.Mod exposing (..)
import YJPark.Game.Assets.Model.Bundle as Bundle

import WebGL.Texture as Texture exposing (Texture)

import Dict exposing (Dict)
import Task


type Asset
    = Texture Texture


type alias Type =
    { base_url : String
    , assets : Dict String Asset
    , bundle : Bundle.Type
    }


init : String -> Type
init base_url =
    { base_url = base_url
    , assets = Dict.empty
    , bundle = Bundle.init []
    }


getProgress : Type -> Float
getProgress model =
    Bundle.getProgress model.bundle


getTexture : String -> Type -> Maybe Texture
getTexture path model =
    case Dict.get path model.assets of
        Nothing ->
            Nothing
        Just (Texture texture) ->
            Just texture
