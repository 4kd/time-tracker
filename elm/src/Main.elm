module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Route
import Msg exposing (Msg(..))
import Material
import API


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
        { init = Model.init
        , update = Update.update
        , urlUpdate = urlUpdate
        , view = View.view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model


urlUpdate : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
urlUpdate route model =
    let
        newModel =
            { model | route = route }
    in
        case route of
            Just (Route.Users) ->
                newModel ! [ API.fetchUsers newModel ]

            Just (Route.ShowUser id) ->
                newModel ! [ API.fetchUser id newModel ]

            _ ->
                newModel ! []
