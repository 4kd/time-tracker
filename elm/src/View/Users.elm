module View.Users exposing (view)

import Model exposing (Model)
import Types exposing (User, UserSortableField(..), Sorted(..))
import Msg exposing (Msg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, a, img, span)
import Html.Attributes exposing (href, src, style)
import Material.List as List
import Material.Button as Button
import Material.Icon as Icon
import Material.Table as Table
import Material.Options as Options
import Material.Layout as Layout


view : Model -> Html Msg
view model =
    div []
        [ addUserButton model
        , usersTable model
        ]


usersTable : Model -> Html Msg
usersTable model =
    Table.table []
        [ Table.thead []
            [ Table.th [] []
            , Table.th
                (thOptions Name model)
                [ text "Name" ]
            , Table.th [] [ text "Position" ]
            , Table.th [] [ text "Email" ]
            , Table.th [] [ text "Today" ]
            , Table.th [] [ text "Last 7 days" ]
            , Table.th [] [ text "Projects" ]
            , Table.th [] [ text "Open Tasks" ]
            , Table.th [] [ text "Actions" ]
            ]
        , Table.tbody []
            (List.indexedMap (viewUserRow model) model.users)
        ]


viewUserRow : Model -> Int -> User -> Html Msg
viewUserRow model index user =
    let
        attributes =
            case user.id of
                Nothing ->
                    []

                Just id ->
                    [ href (Route.urlFor (ShowUser id)) ]
    in
        Table.tr []
            [ Table.td []
                [ img
                    [ src ("https://api.adorable.io/avatars/30/" ++ user.name ++ ".png"), style [ ( "border-radius", "50%" ) ] ]
                    []
                ]
            , Table.td [] [ a attributes [ text user.name ] ]
            , Table.td [] [ text "Monkey" ]
            , Table.td [] [ text "monkey@example.com" ]
            , Table.td [] [ text "3h 28m" ]
            , Table.td [] [ text "57h 12m" ]
            , Table.td [] [ text "20" ]
            , Table.td [] [ text "8" ]
            , Table.td []
                [ editButton model index user
                , deleteButton model index user
                ]
            ]


addUserButton : Model -> Html Msg
addUserButton model =
    Button.render Mdl
        [ 0, 0 ]
        model.mdl
        [ Options.css "position" "fixed"
        , Options.css "display" "block"
        , Options.css "right" "0"
        , Options.css "bottom" "0"
        , Options.css "margin-right" "40px"
        , Options.css "margin-bottom" "40px"
        , Options.css "z-index" "900"
        , Button.fab
        , Button.colored
        , Button.ripple
        , Button.onClick <| NavigateTo <| Just NewUser
        ]
        [ Icon.i "add" ]


deleteButton : Model -> Int -> User -> Html Msg
deleteButton model index user =
    Button.render Mdl
        [ 0, 1, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.onClick <| DeleteUser user
        ]
        [ Icon.i "delete" ]


editButton : Model -> Int -> User -> Html Msg
editButton model index user =
    case user.id of
        Nothing ->
            text ""

        Just id ->
            Button.render Mdl
                [ 0, 2, index ]
                model.mdl
                [ Button.minifab
                , Button.colored
                , Button.ripple
                , Button.onClick <| NavigateTo <| Just <| EditUser id
                ]
                [ Icon.i "edit" ]


thOptions : UserSortableField -> Model -> List (Options.Property (Header Msg) Msg)
thOptions sortableField model =
    [ Table.onClick (ReorderUsers sortableField)
    , Options.css "cursor" "pointer"
    ]
        ++ case model.usersSort of
            Nothing ->
                []

            Just ( sorted, sortedField ) ->
                case sortedField == sortableField of
                    True ->
                        case sorted of
                            Ascending ->
                                [ Table.sorted Table.Ascending ]

                            Descending ->
                                [ Table.sorted Table.Descending ]

                    False ->
                        []



{- This is just so that we can annotate our thOptions function - I wish it
   were exposed from Material.Table.  https://github.com/debois/elm-mdl/blob/7.5.0/src/Material/Table.elm#L178
-}


type alias Header m =
    { numeric : Bool
    , sorted : Maybe Table.Order
    , onClick : Maybe (Html.Attribute m)
    }
