module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Types exposing (User, UserSortableField(..), Sorted(..))
import Material
import Material.Snackbar as Snackbar
import Navigation
import Route exposing (Location(..))
import API


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg: " msg of
        Mdl msg' ->
            Material.update msg' model

        Snackbar msg' ->
            let
                ( snackbar, snackCmd ) =
                    Snackbar.update msg' model.snackbar
            in
                { model | snackbar = snackbar } ! [ Cmd.map Snackbar snackCmd ]

        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    model ! [ Navigation.newUrl (Route.urlFor location) ]

        GotUsers users ->
            { model | users = users } ! []

        SetNewUserName name ->
            let
                oldNewUser =
                    model.newUser
            in
                { model | newUser = { oldNewUser | name = name } } ! []

        CreateNewUser ->
            model ! [ API.createUser model.newUser model ]

        CreateSucceeded _ ->
            { model | newUser = User Nothing "" }
                ! [ Navigation.newUrl (Route.urlFor Users) ]

        CreateFailed error ->
            let
                _ =
                    Debug.log "Create User failed: " error
            in
                model ! []

        DeleteUser user ->
            let
                _ =
                    Debug.log "Deleting user: " user
            in
                model ! [ API.deleteUser user model ]

        DeleteFailed error ->
            let
                _ =
                    Debug.log "Delete User failed: " error
            in
                model ! []

        DeleteSucceeded user ->
            model ! [ API.fetchUsers model ]

        GotUser user ->
            { model | shownUser = Just user } ! []

        ReorderUsers field ->
            reorderUsers field model ! []

        NoOp ->
            model ! []


reorderUsers : UserSortableField -> Model -> Model
reorderUsers sortableField model =
    let
        fun =
            userSortableFieldFun sortableField
    in
        case model.usersSort of
            Nothing ->
                { model
                    | usersSort = Just ( Ascending, sortableField )
                    , users = List.sortBy fun model.users
                }

            Just ( Ascending, sortableField ) ->
                { model
                    | usersSort = Just ( Descending, sortableField )
                    , users = List.sortBy fun model.users |> List.reverse
                }

            Just ( Descending, sortableField ) ->
                { model
                    | usersSort = Just ( Ascending, sortableField )
                    , users = List.sortBy fun model.users
                }

            Just _ ->
                { model
                    | usersSort = Just ( Ascending, sortableField )
                    , users = List.sortBy fun model.users
                }


userSortableFieldFun : UserSortableField -> (User -> String)
userSortableFieldFun sortableField =
    case sortableField of
        Name ->
            .name
