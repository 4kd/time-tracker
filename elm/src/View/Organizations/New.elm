module View.Organizations.New exposing (view)

import Model exposing (Model)
import Types exposing (Organization)
import Msg exposing (Msg(..), OrganizationMsg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, form, a)
import Html.Attributes exposing (href)
import Material.List as List
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Grid exposing (grid, size, cell, Device(..))
import Form exposing (Form)
import Form.Field
import Form.Input
import Form.Error
import OurForm


view : Model -> Html Msg
view model =
    grid []
        [ cell [ size All 12 ]
            [ nameField model ]
        , cell [ size All 12 ]
            [ submitButton model
            , cancelButton model
            ]
        ]


nameField : Model -> Html Msg
nameField model =
    let
        ( form, apiErrors ) =
            model.organizationsModel.newOrganizationForm

        name =
            Form.getFieldAsString "name" form
                |> OurForm.handleAPIErrors apiErrors
    in
        Textfield.render Mdl
            [ 6, 0 ]
            model.mdl
            ([ Textfield.label "Name"
             , Textfield.floatingLabel
             , Textfield.text'
             , Textfield.value <| Maybe.withDefault "" name.value
             , Textfield.onInput <| tagged << (Form.Field.Text >> Form.Input name.path)
             , Textfield.onFocus <| tagged <| Form.Focus name.path
             , Textfield.onBlur <| tagged <| Form.Blur name.path
             ]
                ++ OurForm.errorMessagesForTextfield name
            )


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 6, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick <| tagged Form.Submit
        ]
        [ text "Submit" ]


cancelButton : Model -> Html Msg
cancelButton model =
    Button.render Mdl
        [ 6, 2 ]
        model.mdl
        [ Button.ripple
        , Button.onClick <| NavigateTo <| Just Organizations
        , Options.css "margin-left" "1rem"
        ]
        [ text "Cancel" ]


tagged : Form.Msg -> Msg
tagged =
    OrganizationMsg' << NewOrganizationFormMsg
