defmodule WemosErgoWeb.ProjectNewLive do
  alias WemosErgo.Accounts
  alias WemosErgo.Accounts.Project
  alias WemosErgo.Repo

  use WemosErgoWeb, :live_view

  @project_type_options [
    {"", -1},
    {"Thông tư 29", 0},
    {"Môi trường lao động", 1}
  ]

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md">
      <.header class="text-center">
        Create new project
      </.header>

      <.simple_form
        for={@form}
        id="new_project_form"
        phx-submit="create"
        phx-change="validate"
        action={~p"/projects/new?_action=creation"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input
          field={@form[:name]}
          class="!rounded-xl tracking-wide font-inter"
          type="text"
          label="Name"
          placeholder="Your project name"
        />
        <.input
          field={@form[:type]}
          class="laeding-6 !rounded-xl py-2.5 tracking-wide"
          type="select"
          options={@project_type_options}
          label="Project type"
        />

        <:actions>
          <.button class="flex items-center justify-center !bg-brand hover:!bg-brand/75 !rounded-xl w-full" phx-disable-with="Creating project...">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="size-5 mr-1"
            >
              <path
                fill-rule="evenodd"
                d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z"
                clip-rule="evenodd"
              />
            </svg>
            Create new project
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    project_changeset = Accounts.change_project(%Project{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(:project_type_options, @project_type_options)
      |> assign_form(project_changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset = Accounts.change_project(%Project{}, project_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("create", %{"project" => project_params}, socket) do
    changeset = Accounts.change_project(%Project{}, project_params)

    new_project = changeset |> Ecto.Changeset.put_assoc(:user, socket.assigns.current_user) |> Repo.insert
    case new_project do
      {:ok, _} ->
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}
      {:error, %Ecto.Changeset{} = err_changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(err_changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "project")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
