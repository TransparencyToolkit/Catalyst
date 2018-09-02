load 'process_block.rb'

# This calls the appropriate query function in DocManager and runs the annotator block on the results
class QueryDocs
  include DocmanagerAPI
  def initialize(index_name, default_dataspec, docs_to_process, process_block, *args)
    @output = Array.new

    # Set input params
    @process_block = process_block
    @index_name = index_name
    @default_dataspec = default_dataspec
    
    # Get input options that determine which docs it runs on
    @run_over = docs_to_process["run_over"]
    @field_to_search = docs_to_process["field_to_search"]
    @filter_query = docs_to_process["filter_query"]
    @end_filter_range = docs_to_process["end_filter_range"]
    
    # Run over docs
    process_docs(*args)
  end

  # Get the right type of documents to process
  def process_docs(*args)
    case @run_over
    when "all"
      query_all_docs(*args)
    when "unprocessed"
      query_nil_docs(*args)
    when "within_range"
      query_within_range(*args)
    when "matching_query"
      query_matching_docs(*args)
    end
  end

  # Filter documents for the correct type
  def filter_for_correct_type(docs)
    type_to_keep = @index_name+"_"+@default_dataspec.underscore
    return docs.select{|d| d["_type"] == type_to_keep}
  end

  # Query all documents
  def query_all_docs(*args)
    docs = filter_for_correct_type(JSON.parse(get_all_docs(@index_name)))
    run_block(docs, *args)
  end

  # Get docs with nothing in the field
  def query_nil_docs(*args)
    docs = filter_for_correct_type(JSON.parse(get_docs_with_empty_field(@index_name, @field_to_search)))
    run_block(docs, *args)
  end

  # Get all the documents that match a search query
  def query_matching_docs(*args)
    docs = filter_for_correct_type(JSON.parse(get_matching_docs(@index_name, @field_to_search, @filter_query)))
    run_block(docs, *args)
  end

  # Get all the documents after a specified date
  def query_within_range(*args)
    docs = filter_for_correct_type(JSON.parse(get_within_range(@index_name, @field_to_search, @filter_query, @end_filter_range)))
    run_block(docs, *args)
  end

  # Runs the process block over documents
  def run_block(docs, *args)
    if docs.length >= 1
      p = ProcessBlock.new(docs, @index_name, @default_dataspec, @process_block, *args)
    end
  end
end
