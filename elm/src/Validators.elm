module Validators exposing (validateNewUser, validateNewOrganization, validateNewProject, validateLoginForm)

import Form.Validate exposing (Validation, form1, form2, get, string)
import Types exposing (User, Organization, Project, APIFieldErrors)


validateNewUser : Validation String User
validateNewUser =
    form1 (User Nothing)
        (get "name" string)


validateNewProject : Validation String Project
validateNewProject =
    form1 (Project Nothing)
        (get "name" string)


validateNewOrganization : Validation String Organization
validateNewOrganization =
    form1 (Organization Nothing)
        (get "name" string)


validateLoginForm : Validation String ( String, String )
validateLoginForm =
    form2 (,)
        (get "username" string)
        (get "password" string)
