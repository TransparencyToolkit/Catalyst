module DocStats
  def total_docs(index_name)
    return Elasticsearch::Model.client.search(from: 0, size: 1, index: index_name, body: {query:{ match_all:{}}})["hits"]["total"]
  end
end
