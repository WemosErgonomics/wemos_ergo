defmodule WemosErgo.Helpers.DateTime do
  # shift this into Ho_Chi_Minh timezone and format it
  def format_readable_datetime(datetime, format_string \\ "%Y-%m-%d %H:%M:%S")
  def format_readable_datetime(nil, _), do: "----"
  def format_readable_datetime(datetime, format_string),
    do:
      datetime
      |> DateTime.shift_zone!("Asia/Ho_Chi_Minh")
      |> Calendar.strftime(format_string)
end
