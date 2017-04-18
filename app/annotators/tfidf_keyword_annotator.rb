# Extracts keywords using tfidf
class TfidfKeywordAnnotator
  include DocStats
  def initialize(output_field_name, fields_to_check, index_name, lower_bound, upper_bound)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @index_name = index_name
    @lower_bound = lower_bound
    @upper_bound = upper_bound
  end

  # Extract keywords using tf-idf
  def gen_tfidf_block
    return lambda do |doc|
      keywords = Array.new

      # Get the term vector and doc num
      term_vector = get_term_vector(doc)
      doc_count = total_docs(@index_name)
      
      @fields_to_check.each do |field|
        field_text = doc["_source"][field]

        # Calculate keywords from tf-idf
        tfidf_scores = get_all_tfidf_scores(term_vector, doc_count, field, field_text)
        keywords += tfidf_scores.select{|k,v| (v <= @upper_bound) && (v >= @lower_bound)}.map{|k,v| k}
      end

      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_tfidfkeyword"]] = keywords.uniq
      return doc
    end
  end

  # Get all of the tf-idf scores
  def get_all_tfidf_scores(term_vector, doc_count, field, field_text)
    term_stats_for_field = JSON.parse(term_vector)["term_vectors"][field]
    num_terms_indoc = total_terms_in_field(term_stats_for_field)
    tfidf_hash = Hash.new

    # Compute tf-idf for each term
    term_stats_for_field["terms"].each do |tv|
      full_term = get_full_term(field_text, tv[1]["tokens"].first)
      tfidf_hash[full_term] = calculate_tfidf(tv[1], doc_count, num_terms_indoc)
    end
   
    return tfidf_hash
  end

  # Get the full, unstemmed term
  def get_full_term(field_text, term_position)
    return field_text[term_position["start_offset"]...term_position["end_offset"]]
  end

  # Get the term vector for the doc from elasticsearch
  def get_term_vector(doc)
    query = "http://localhost:9200/"+@index_name+"/"+@index_name+"_doc/"+doc["_id"]+"/_termvector?term_statistics=true"
    return Curl.get(query).body_str
  end

  # Get the total number of terms for field in the doc
  def total_terms_in_field(term_stats_for_field)
    return term_stats_for_field["terms"].inject(0){|count,term| count+=term[1]["term_freq"]}
  end

  # Calculate tfidf
  def calculate_tfidf(termvector, doc_count, num_terms_indoc)
    tf = calculate_tf(termvector, num_terms_indoc)
    idf = calculate_idf(termvector, doc_count)
    tfidf = tf*idf
  end

  # Calculate tf = # of times term occurs in doc/# of total terms in doc
  def calculate_tf(termvector, num_terms_indoc)
    term_freq = termvector["term_freq"]
    return term_freq/num_terms_indoc.to_f
  end

  # Calculate idf = log_e(Total # of documents/# of documents with term)
  def calculate_idf(termvector, doc_count)
    doc_freq = termvector["doc_freq"]
    return Math.log(doc_count/doc_freq.to_f)
  end
  
  # Initialize block to call
  def gen_block
    return gen_tfidf_block
  end
end