defmodule WemosErgoWeb.ProjectIndexLive do
  use WemosErgoWeb, :live_view

  alias WemosErgo.Accounts.Project
  alias WemosErgo.Repo

  import WemosErgoWeb.Components.RecentProjectTable

  def render(assigns) do
    ~H"""
    <div class="flex justify-end">
      <.link
        class="!px-4 !py-2 text-right rounded-xl !bg-brand hover:!bg-brand/75 flex text-white font-inter text-sm items-center font-semibold"
        navigate={~p"/projects/new"}
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="size-6 mr-2"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m3.75 9v6m3-3H9m1.5-12H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z"
          />
        </svg>
        New project
      </.link>
    </div>
    <%= if not Enum.empty?(@user_projects) do %>
      <div class="flex flex-col">
        <div class="mt-8 text-lg uppercase font-semibold flex items-center bg-transparent">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="size-5 mr-2"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z"
              clip-rule="evenodd"
            />
          </svg>
          Recent projects
        </div>
        <.recent_project_table projects={@user_projects} />
      </div>
    <% end %>

    <script>
      window.addEventListener("phx:hide-deleted-project", (e) => {
      document.getElementById(e.detail.id).remove();
      })
    </script>
    """
  end

  import Ecto.Query, warn: false

  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id

    user_projects =
      Project
      |> where(user_id: ^current_user_id)
      |> order_by([project], desc: coalesce(project.last_opened_at, project.inserted_at))
      |> Repo.all()

    socket = socket |> assign(:user_projects, user_projects)

    {:ok, socket}
  end

  def handle_event("destroy-project", %{"project_id" => project_id}, socket) do
    Project |> where(id: ^project_id) |> Repo.delete_all()

    user_projects =
      Project
      |> where(user_id: ^socket.assigns.current_user.id)
      |> order_by([project], desc: coalesce(project.last_opened_at, project.inserted_at))
      |> Repo.all()

    socket = socket |> assign(:user_projects, user_projects)

    {:noreply, socket |> push_event("hide-deleted-project", %{id: "project-" <> project_id})}
  end
end
