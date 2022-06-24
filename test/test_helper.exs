# ExUnit.start()
ExUnit.start(timeout: 100_000_000)

Ecto.Adapters.SQL.Sandbox.mode(Rauversion.Repo, :manual)

defmodule ActiveStorageTestHelpers do
  def create_file_blob(options \\ []) do
    default = [
      key: nil,
      filename: "racecar.jpg",
      content_type: "image/jpeg",
      metadata: nil,
      service_name: "local",
      record: nil
    ]

    options = Keyword.merge(default, options)

    file = File.open!("./test/files/#{options[:filename]}")

    blob = %ActiveStorage.Blob{}

    ActiveStorage.Blob.create_and_upload!(blob,
      io: {:io, file},
      filename: options[:filename],
      content_type: options[:content_type],
      metadata: options[:metadata],
      service_name: options[:service_name],
      identify: true
    )

    # ActiveStorage::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename, content_type: content_type, metadata: metadata, service_name: service_name, record: record
  end
end
