defmodule WemosErgoWeb.Components.RecentProjectTable do
  use Phoenix.Component

  import WemosErgo.Helpers.DateTime
  import WemosErgoWeb.Components.ProjectAction

  attr :projects, :list, required: true
  def recent_project_table(assigns) do
    project_text = ["Thông tư 29", "Môi trường lao động"]
    ~H"""
    <div class="relative overflow-x-auto shadow-xl sm:rounded-xl mt-3 font-inter">
      <table class="w-full text-sm text-left rtl:text-right text-gray-500">
        <thead class="text-xs text-white uppercase bg-black">
          <tr>
            <th scope="col" class="px-8 py-5">
              Project Name
            </th>
            <th scope="col" class="px-4 py-5 text-center">
              Project Type
            </th>
            <th scope="col" class="px-4 py-5 text-center">
              Created At
            </th>
            <th scope="col" class="px-8 py-5 text-right">
              Actions
            </th>
          </tr>
        </thead>
        <tbody>
          <%= for project <- @projects do %>
            <tr
              class="bg-white border-b border-gray-200 hover:bg-neutral-100"
              id={"project-" <> project.id}
            >
              <td
                scope="row"
                class="px-8 py-4 font-medium text-gray-900 flex flex-col justify-center space-y-1"
              >
                <div class="text-sm">{project.name}</div>
                <div class="text-zinc-400 text-xs">
                  Last opened at: {project.last_opened_at |> format_readable_datetime()}
                </div>
              </td>
              <td class="px-4 py-6 text-center">
                {project_text |> Enum.at(project.type)}
              </td>
              <td class="px-4 py-6 text-center">
                {project.inserted_at |> format_readable_datetime()}
              </td>
              <td class="px-8 py-2 text-right">
                <.action_button project={project} />
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
