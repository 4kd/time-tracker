defmodule TimeTrackerBackend.UserController do
  use TimeTrackerBackend.Web, :controller

  def index(conn, _params) do
    users = Repo.all(User)

    json conn, users
  end
end
