defmodule Central.Helpers.GeneralTestLib do
  @moduledoc false
  import Phoenix.ConnTest, only: [build_conn: 0, post: 3]

  import Ecto.Query
  alias Central.Repo
  import Phoenix.ChannelTest
  # use Phoenix.ConnTest

  @endpoint CentralWeb.Endpoint

  alias Central.Account.AuthLib

  alias Central.Account
  alias Central.Account.User

  # alias CentralWeb.General.CombinatorLib

  alias CentralWeb.UserSocket

  alias Central.Account.Guardian

  # def make_combos(data), do: CombinatorLib.make_combos(data)

  # import CentralWeb.ACL.Authorisation

  def user_fixture(), do: make_user(%{"permissions" => []})

  def make_user(params \\ %{}) do
    permissions =
      (params["permissions"] || [])
      |> AuthLib.split_permissions()

    {:ok, u} =
      Account.create_user(%{
        "name" => params["name"] || "Test",
        "email" => params["email"] || "email@email#{:rand.uniform(999_999_999_999)}",
        "colour" => params["colour"] || "#00AA00",
        "icon" => params["icon"] || "fa-regular fa-user",
        "permissions" => permissions,
        "password" => params["password"] || "password",
        "password_confirmation" => params["password"] || "password",
        "data" => params["data"] || %{}
      })

    u
  end

  def seeded?() do
    r = Repo.one(from c in Central.Config.SiteConfig, where: c.key == "test.seeded")
    r != nil
  end

  def seed() do
    %Central.Config.SiteConfig{}
    |> Central.Config.SiteConfig.changeset(%{
      key: "test.seeded",
      value: "true"
    })
    |> Repo.insert()

    users = []

    [
      users: users
    ]
    |> Teiserver.Logging.LoggingTestLib.seed()
  end

  def login(conn, email) do
    conn
    |> post("/login", %{"user" => %{email: email, password: "password"}})
  end

  def data_setup(flags \\ []) do
    user =
      if :user in flags do
        make_user(%{
          "name" => "Current user",
          "email" => "current_user@current_user.com",
          "permissions" => []
        })
      end

    {:ok, user: user}
  end

  # Used for those that need to create additional connections
  def new_conn(nil), do: login(build_conn(), "")

  def new_conn(user) do
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    {:ok, user, _claims} = Guardian.resource_from_token(jwt)

    login(build_conn(), user.email)
  end

  # @spec general_setup(list, ) :: tuple
  def conn_setup(permissions \\ [], flags \\ []) do
    {:ok, _data} = data_setup(flags)

    r = :rand.uniform(999_999_999)

    {user, jwt} =
      if :no_user in flags do
        {nil, nil}
      else
        user =
          make_user(%{
            "name" => "Current user",
            "email" => "current_user#{r}@current_user#{r}.com",
            "permissions" => permissions
          })

        # Tokens
        {:ok, jwt, _} = Guardian.encode_and_sign(user)
        {:ok, user, _claims} = Guardian.resource_from_token(jwt)
        {user, jwt}
      end

    # Connection and socket stuff
    # conn = build_conn()
    # |> Guardian.Plug.sign_in(user, %{some: "claim"})
    # |> Guardian.Plug.remember_me(user)

    conn =
      if :no_login in flags or :no_user in flags do
        # build_conn()
        login(build_conn(), "")
      else
        login(build_conn(), user.email)
      end

    child_user =
      if flags[:child_user] do
        Repo.one(from u in User, where: u.name == "child user")
      end

    parent_user =
      if flags[:parent_user] do
        Repo.one(from u in User, where: u.name == "parent user")
      end

    socket =
      if flags[:socket] do
        case connect(UserSocket, %{"token" => jwt}) do
          {:ok, socket} ->
            socket

          _e ->
            raise "Error connecting to socket in test_lib"
        end
      end

    {:ok,
     r: r,
     user: user,
     jwt: jwt,
     child_user: child_user,
     parent_user: parent_user,
     conn: conn,
     user_token: jwt,
     socket: socket}
  end
end
