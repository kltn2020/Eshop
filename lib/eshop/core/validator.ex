defmodule Eshop.Core.Validator do
  def check_and_apply_changes(form_changesets) when is_list(form_changesets) do
    Enum.reduce(form_changesets, {:ok, []}, fn
      form_changeset, {:ok, data} ->
        if form_changeset.valid? do
          changes = form_changeset |> Ecto.Changeset.apply_changes()
          {:ok, [changes | data]}
        else
          {:error, :validation_failed, form_changeset}
        end

      _form_changeset, acc ->
        acc
    end)
  end

  def check_and_apply_changes(form_changeset) do
    if form_changeset.valid? do
      changes = form_changeset |> Ecto.Changeset.apply_changes()

      {:ok, changes}
    else
      {:error, :validation_failed, form_changeset}
    end
  end

  def get_validation_error_message(%{} = error, parent_key \\ nil) do
    first_error_field =
      Enum.find(error, fn
        {_key, [_ | _] = _errors} ->
          true

        _ ->
          false
      end)

    case first_error_field do
      {key, errors} ->
        current_key =
          [parent_key, Atom.to_string(key)]
          |> Enum.filter(& &1)
          |> Enum.join(" -> ")

        if is_binary(List.first(errors)) do
          "#{current_key} #{List.first(errors)}"
        else
          get_validation_error_message(List.first(errors), current_key)
        end

      _ ->
        ""
    end
  end
end
