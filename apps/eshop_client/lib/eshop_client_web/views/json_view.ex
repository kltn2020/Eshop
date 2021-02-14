defmodule EshopClientWeb.JsonView do
  defmacro __using__(_) do
    quote do
      def render_json(struct, fields, custom_fields, relationships) do
        EshopClientWeb.JsonView.render_json(struct, __MODULE__,
          fields: fields,
          custom_fields: custom_fields,
          relationships: relationships
        )
      end
    end
  end

  @doc """
  Render a struct to a map with given options

  - `fields`: which fields are extract directly from struct
  - `custom_fields`: which fields are render using custom `render_field/2` function
  - `relationships`: a list of {field, view_module} defines which fields are rendered using another view

      defmodule EshopClientWeb.PostView do
          use JsonView

          @fields [:title, :content, :excerpt, :cover]
          @custom_fields [:like_count]
          @relationships [author: EshopClientWeb.AuthorView]

          def render("post.json", %{post: post}) do

              # 1st way if `use JsonView`
              render_json(post, @fields, @custom_fields, @relationships)

              # 2nd way same as above
              JsonView.render_json(post, __MODULE__,
                  fields: @fields,
                  custom_fields: @custom_fields,
                  relationships: @relationships
              )

              # 3rd render manual
              post
              |> JsonView.render_fields(@fields)
              |> Map.merge(JsonView.render_custom_fields(post, __MODULE__, @custom_fields))
              |> Map.merge(JsonView.render_relationships(post, @relationships))
          end

          def render_field(:like_count, item) do
              # load like_count from some where
          end
      end
  """
  def render_json(nil, _, _), do: nil

  def render_json(struct, view, opts) when is_list(opts) do
    fields = Keyword.get(opts, :fields, [])
    custom_fields = Keyword.get(opts, :custom_fields, [])
    relationships = Keyword.get(opts, :relationships, [])

    struct
    |> render_fields(fields)
    |> Map.merge(render_custom_fields(struct, view, custom_fields))
    |> Map.merge(render_relationships(struct, relationships))
  end

  def render_fields(structs, fields) do
    Map.take(structs, fields)
  end

  @doc """
  Render field with custom render function
  View module must defines `render_field/2` function to render each custom field

      use JsonView

      def render_field(:is_success, item) do
        item.state > 3
      end

      render_custom_fields(struct, __MODULE__, [:is_success])

  """
  def render_custom_fields(struct, view, fields) do
    # if fields is not empty and render_field/2 is not defined, raise exception
    if Kernel.function_exported?(view, :render_field, 2) == false and length(fields) > 0 do
      raise "render_field/2 is not defined in #{view}"
    else
      fields
      |> Enum.map(fn field ->
        {field, view.render_field(field, struct)}
      end)
      |> Enum.into(%{})
    end
  end

  @doc """
  Render relationship field for struct. `relationships` is a list of {field, view} for mapping render.
  For each field, call function `View.render()` to render json for relation object.

  Example relationships:

      relationships = [comments: CommentView, author: UserView]

  Result of `render_relationships(post, relationships)` equal to output of below code

      %{
          comments: CommentView.render_many(comments, CommentView, "comment.json"),
          autho: UserView.render_one(author, UserView, "user.json")
      }
  """
  def render_relationships(struct, relationships) when is_list(relationships) do
    Enum.map(relationships, fn {field, view} ->
      {field, render_relationship(struct, field, view)}
    end)
    |> Enum.into(%{})
  end

  # render a single relationship
  defp render_relationship(struct, field, view) do
    references = Map.get(struct, field)

    name = relationship_name(view)

    case references do
      %Ecto.Association.NotLoaded{} ->
        nil

      %{} ->
        Phoenix.View.render_one(references, view, "#{name}.json")

      references when is_list(references) ->
        Phoenix.View.render_many(references, view, "#{name}.json")

      _ ->
        nil
    end
  end

  # get relationship name. Ex: EshopClientWeb.ProductView -> product
  # this value is used to map assign when render relationship
  # render_one(product, EshopClientWeb.ProductView, "product.json")
  defp relationship_name(view) do
    view
    |> Module.split()
    |> Enum.map(&Phoenix.Naming.underscore/1)
    |> List.last()
    |> String.trim_trailing("_view")
  end
end
