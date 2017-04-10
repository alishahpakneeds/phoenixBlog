defmodule BlogTest.Avatar do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  def __storage, do: Arc.Storage.Local

  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png"}
  end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # def filename(version, {_file, scope}) do
  #   "{scope.uuid}_#{version}"
  # end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do
    "priv/static/images/uploads/user/avatars/#{scope.uuid}"
  end



  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  def thumb_url(image) do
    BlogTest.Avatar.url({image.image, image}, :thumb)
    |> Path.relative_to("/priv/static")
  end
end
