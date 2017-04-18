defmodule BlogTest.LoginChannel do
  use BlogTest.Web, :channel
  alias BlogTest.Presence

  alias BlogTest.Room
  alias BlogTest.Repo
  alias BlogTest.User

  alias BlogTest.Image
  alias BlogTest.ApplicationHelpers
  import Ecto.Query


  def join("login:room", _message, socket) do
    send(self, :after_join)
    # room = Repo.get!(Room,roomId)
    IO.puts "---HERE---in login room------"
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "-----in error-------"
    {:error, %{reason: "you can only join the login"}}
  end

  def handle_info(:after_join, socket) do
     IO.puts "------handle info presense state-------"
     
     IO.inspect  Presence.list(socket)
     push socket, "presence_state", Presence.list(socket)
     {:ok, _} = Presence.track(socket, socket.assigns.auth.user_id, %{
       status_at: :os.system_time(:milli_seconds),
       status: "online"
     })
     {:noreply, socket}
  end

  #manage login status
  def handle_in("new_status", %{"status" => status}, socket) do
     IO.puts "-------new status of current user------"
     IO.puts status
     {:ok, _} = Presence.update(socket, socket.assigns.auth.user_id, %{
       status: status,
       status_at: :os.system_time(:milli_seconds),
     })
     IO.puts status
     {:noreply, socket}
  end

  def terminate(reason, socket) do
     IO.puts socket.assigns.auth.user.first_name
     IO.puts "-------------"
     IO.puts "> leave #{inspect reason}"

     message = %{
            body: "left the room ",
            leaving_by: ApplicationHelpers.user_full_name(socket.assigns.auth.user),
            timestamp: :os.system_time(:millisecond)
          }
     broadcast! socket, "leave_login_room", message
     :ok
  end


end