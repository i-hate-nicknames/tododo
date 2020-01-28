module Todo exposing(..)

import Browser
import Html exposing(..)
import Html.Attributes exposing(class)
import Time
import Http
import Json.Decode exposing (Decoder, field, string, list, map3, int)

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
  | Result (List Todo)
  | Error String


-- Update

type Msg
  = GotTodo (Result Http.Error (List Todo))

update: Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
  GotTodo result ->
    case result of

      Err _ -> (Error "error :DDD", Cmd.none)

      Ok titles -> (Result titles, Cmd.none)


-- View

view: Model -> Html Msg
view model = case model of
  Loading -> div [] [ text "cyka" ]

  Error msg -> div [] [ text msg ]

  Result titles -> div [] (List.map renderTodo titles)

renderTodo: Todo -> Html Msg
renderTodo todo =
  div []
    [ div [ class "id" ] [ text (String.fromInt todo.id)]
    , div [ class "title" ] [ text todo.title]
    , div [ class "description" ] [ text todo.description]
    ]


-- Subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none


-- Http

getTodos: Cmd Msg
getTodos =
  Http.get
  { url = "http://localhost:8080/ping"
  , expect = Http.expectJson GotTodo todosDecoder
  }

todosDecoder: Decoder (List Todo)
todosDecoder =
  field "todos" (list todoItemDecoder)

todoItemDecoder: Decoder Todo
todoItemDecoder =
  map3 Todo
    (field "id" int)
    (field "Title" string)
    (field "Description" string)
