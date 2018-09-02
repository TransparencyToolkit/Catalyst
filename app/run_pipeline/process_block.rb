# This runs the block of code for the annotator over the document and saves the results
class ProcessBlock
  include DocmanagerAPI
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
      @doc_output.push(@process_block.call(doc, *args)["_source"])
    end
    
    # Index/Save the documents
    save_data(@index_name, @default_dataspec, @doc_output)
  end
end
