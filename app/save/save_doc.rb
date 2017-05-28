class SaveDoc
  include SaveUtils
  def initialize(doc_data, index_name, default_dataspec)
    @index_name = index_name
    @default_dataspec = default_dataspec
    save_doc(doc_data)
  end

  # Saves all inputted matches
  def save_doc(doc_data)
    # Set item fields and index
    c = Curl::Easy.new("http://localhost:3000/add_items")
    c.http_post(Curl::PostField.content("item_type", @default_dataspec),
                Curl::PostField.content("index_name", @index_name),
                Curl::PostField.content("items", JSON.pretty_generate(doc_data)))
  end
end
