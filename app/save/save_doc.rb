class SaveDoc
  include SaveUtils
  def initialize(doc_data, index_name, default_dataspec)
    @index_name = index_name
    @default_dataspec = default_dataspec
    save_doc(doc_data)
  end

  # Saves all inputted matches
  def save_doc(doc_data)
    # Get the relevant data source
    data_source = JSON.parse(doc_data.first[:item])["data_source"]
    if data_source
      data_source += "Crawl"
    else
      data_source = @default_dataspec
    end
    
    # Set item fields and index
    Curl::Easy.http_post("http://localhost:3000/add_new_item",
                         Curl::PostField.content("source", data_source),
                         Curl::PostField.content("extracted_items", JSON.pretty_generate(doc_data)))
  end
end
