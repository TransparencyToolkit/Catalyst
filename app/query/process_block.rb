class ProcessBlock
  def initialize(docs, index_name, default_dataspec, process_block, *args)
    @docs = docs
    @doc_output = Array.new

    # Set input vars
    @index_name = index_name
    @default_dataspec = default_dataspec
    @process_block = process_block

    # Run
    loop_and_process(*args)
  end

  # Loop over the docs and run the process block
  def loop_and_process(*args)
    @docs.each do |doc|
      @doc_output.push(gen_save_item(@process_block.call(doc, *args)))
    end

    # Index docs
    SaveDoc.new(@doc_output, @index_name, @default_dataspec)
  end

  # Generate item to save
  def gen_save_item(doc)
    return {item: JSON.pretty_generate(doc["_source"]), id: doc["_id"]}
  end
end