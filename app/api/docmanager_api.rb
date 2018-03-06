module DocmanagerAPI
  # Save the data
  def save_data(index_name, dataspec, doc_data)
    c = Curl::Easy.new("#{ENV['DOCMANAGER_URL']}/add_items")
    c.http_post(Curl::PostField.content("item_type", dataspec),
                Curl::PostField.content("index_name", index_name),
                Curl::PostField.content("items", JSON.pretty_generate(doc_data)))
  end

  # Get the total number of docs in the index
  def get_total_docs(index_name)
    http = Curl.get("#{ENV['DOCMANAGER_URL']}/get_total_docs", {index_name: index_name})
    return http.body_str
  end

  # Get all the documents
  def get_all_docs(index_name)
    http = Curl.get("#{ENV['DOCMANAGER_URL']}/get_all_docs", {index_name: index_name})
    return http.body_str
  end

  # Gets the documents with a field empty
  def get_docs_with_empty_field(index_name, field_to_search)
    http = Curl.get("#{ENV['DOCMANAGER_URL']}/get_nil_docs", {index_name: index_name, field_to_search: field_to_search})
    return http.body_str
  end

  # Gets the documents with a field empty
  def get_term_vector(index_name, doc_id, fields_to_check, doc_type)
    http = Curl.get("#{ENV['DOCMANAGER_URL']}/get_term_vector", {index_name: index_name, doc_id: doc_id, fields_to_check: fields_to_check, doc_type: doc_type})
    return http.body_str
  end

  # Get the documents that match a query
  def get_matching_docs(index_name, field_to_search, search_query)
    http = Curl.get("#{ENV['DOCMANAGER_URL']}/run_query_catalyst", {index_name: index_name,
                                                           search_query: search_query,
                                                           field_to_search: field_to_search
                                                          })
    return http.body_str
  end

  # Get the documents that have a date after a certain point
  def get_within_range(index_name, field_to_search, start_filter_range, end_filter_range)
    http = Curl.get("#{ENV['DOCMANAGER_URL']}/run_range_query_catalyst", {index_name: index_name,
                                                                    start_filter_range: start_filter_range,
                                                                    end_filter_range: end_filter_range,
                                                                    field_to_search: field_to_search
                                                                   })
    return http.body_str
  end
end
