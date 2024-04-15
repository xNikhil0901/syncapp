defmodule SyncappWeb.Router do
  use SyncappWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SyncappWeb do
    pipe_through :api

    get("/users", SyncController, :get_all_data)
    post("/users", SyncController, :create_user)
    post("/employees", SyncController, :create_employee)
    patch("/syncremote", SyncController, :sync_server)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:syncapp, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: SyncappWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
