defmodule WemosErgoWeb.Components.ProjectAction do
  alias Phoenix.LiveView.JS
  use Phoenix.Component

  import WemosErgoWeb.CoreComponents

  attr :project, :map

  def action_button(assigns) do
    ~H"""
    <div>
      <button
        class="text-white bg-red-500 hover:bg-red-600 px-2 py-2 rounded-full"
        phx-click={show_modal("confirm-delete-" <> @project.id)}
      >
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-4">
          <path
            fill-rule="evenodd"
            d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z"
            clip-rule="evenodd"
          />
        </svg>
      </button>
      <.modal id={"confirm-delete-" <> @project.id}>
        <div class="flex justify-center items-center text-black text-lg font-inter pt-12 pb-8">
          <div>
            Are you sure to delete <span class="font-extrabold">{@project.name}</span> project?
          </div>
        </div>

        <div class="space-x-1">
          <.button
            phx-disable-with="Deleting..."
            class="!bg-red-600 hover:!bg-red-700 rounded-xl !text-sm"
            type="button"
            phx-click={hide_modal("confirm-delete-" <> @project.id) |> hide("project-" <> @project.id) |> JS.push("destroy-project", value: %{project_id: @project.id})}
          >
            Yes, I'm sure
          </.button>
          <.button
            class="!bg-gray-100 hover:!bg-gray-200 rounded-xl !text-black !text-sm"
            type="button"
            phx-click={hide_modal("confirm-delete-" <> @project.id)}
          >
            Cancel
          </.button>
        </div>
      </.modal>
    </div>
    """
  end
end
