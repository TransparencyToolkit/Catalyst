load 'process_block.rb'

class QueryDocs
  include SaveUtils
  include DocStats
  def initialize(index_name, default_dataspec, docs_to_process, process_block, *args)
    @output = Array.new

    # Set input params
    @process_block = process_block
    @index_name = index_name
    @default_dataspec = default_dataspec
    
    # Calculate return # info
    @return_size = 9000
    @return_count = get_return_size

    # Get input options that determine which docs it runs on
    @run_over = docs_to_process["run_over"]
    @field_to_search = docs_to_process["field_to_search"]
    @filter_query = docs_to_process["filter_query"]
    
    # Run over docs
    query_block = process_docs
    run_query(query_block, *args)
  end

  # Get the return size
  def get_return_size
    total = total_docs(@index_name)
    return (total/@return_size)+1
  end

  # Get the right type of documents to process
  def process_docs
    case @run_over
    when "all"
      return process_all_docs
    when "unprocessed"
      return process_nil_or_empty
    when "after_date"
      return process_after
    when "matching_query"
      return process_matching
    end
  end

  # Runs all queries generated
  def run_query(query_block, *args)
    docs = Array.new

    # Get the documents in chunks
    @return_count.times do |i|
      docs = save_retry(0) { query_block.call(i) }
      run_block(docs, *args)
    end
  end

  # Processes only documents created or updated after a certain point
  def process_after
    return lambda do |i|
      Elasticsearch::Model.client.search(from: i*@return_size, size: @return_size,
                                         index: @index_name, body: { query:{
                                                                       range: {@field_to_search+"_at" => {gte: @filter_query}}
                                                                     }})["hits"]["hits"]
    end
  end

  # Run over the docs where field is nil, empty, or not there
  def process_nil_or_empty
    return lambda do |i|
      Elasticsearch::Model.client.search(from: i*@return_size, size: @return_size,
                                         index: @index_name, body: { filter: {
                                                            or:[
                                                              {term: {@field_to_search => ""}},
                                                              {missing: {field: @field_to_search}}
                                                            ]}})["hits"]["hits"]
    end
  end

  # Process only the documents that match a query
  def process_matching
    return lambda do |i|
      Elasticsearch::Model.client.search(from: i*@return_size, size: @return_size,
                                         index: @index_name, body: { query: {
                                                                       match: { @field_to_search => @filter_query}
                                                                     }})["hits"]["hits"]
    end
  end

  # Just run over all the docs
  def process_all_docs
    return lambda do |i|
      Elasticsearch::Model.client.search(from: i*@return_size, size: @return_size,
                                         index: @index_name, body: {query:{ match_all:{}}})["hits"]["hits"]
    end
  end

  # Runs the process block over documents
  def run_block(docs, *args)
    if docs.length >= 1
      p = ProcessBlock.new(docs, @index_name, @default_dataspec, @process_block, *args)
    end
  end
end
