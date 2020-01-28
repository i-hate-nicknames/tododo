module Todo exposing(..)

import Browser
import Html exposing(..)
import Time
import Http
import Json.Decode exposing (Decoder, field, string)

main =
  Browser.element
  { init = init
  , subscriptions = subscriptions
  , update = update
  , view = view
  }

init: () -> (Model, Cmd Msg)
init _ = (Loading, getTodos)


-- Model

type alias Todo =
  { id: Int
  , title: String
  , description: String
  }

type Model
  = Loading
  | Result String


-- Update

type Msg
  = GotTodo (Result Http.Error String)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
  GotTodo result ->
    case result of

      Err _ -> (Result "error :DDD", Cmd.none)

      Ok text -> (Result text, Cmd.none)


-- View

view: Model -> Html Msg
view model = case model of
  Loading -> div [] [ text "cyka" ]

  Result s -> div [] [ text s]


-- Subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none


-- Http

getTodos: Cmd Msg
getTodos =
  Http.get
  { url = "http://localhost:8080/ping"
  , expect = Http.expectJson GotTodo todoDecoder
  }

todoDecoder: Decoder String
todoDecoder =
  field "todos" (field "Title" string)