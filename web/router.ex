defmodule BlogTest.Router do
  use BlogTest.Web, :router


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogTest.Plugs.SetUser
    # plug BlogTest.SetStatic
  end

  pipeline :csrf do
     plug :protect_from_forgery # to here
  end

  pipeline :chat do
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug BlogTest.Plugs.SetUser

    plug :accepts, ["json","html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogTest do
    pipe_through [:browser, :csrf] # Use the default browser stack

    get "/", PageController, :index
    get "/auth-token-verification", PageController, :verify_token



    resources "/users", UserController
    resources "/categories", CategoryController
    resources "/posts", PostController
    resources "/rooms", RoomController
    resources "/images", ImageController
    resources "/profile", ProfileController,except: [:new,:index,:edit,:show,:update,:create,:delete]

    scope "/profile" do
      get "/edit", ProfileController,:edit
      put "/update", ProfileController,:update
      get "/show", ProfileController,:show

      get "/edit-password", ProfileController,:edit_password
      put "/update-password", ProfileController,:update_password
    end


  end

  scope "/remote", BlogTest do
    pipe_through [:browser]
    get "/test-js.js", PageController, :test_js
  end
  #only for api
  scope "/chat", BlogTest do
    pipe_through [:chat,:csrf]
    post "/:id/change-user-room", RoomController, :change_user_room
  end
  scope "/auth", BlogTest do
    pipe_through [:browser] # Use the default browser stack
    resources "/", AuthController,only: [:new,:create,:delete]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback

  end



  # Other scopes may use custom stacks.
  # scope "/api", BlogTest do
  #   pipe_through :api
  # end
end
