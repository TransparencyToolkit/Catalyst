# Tags documents with the term they include and remaps them
class TermlistAnnotator
  def initialize(output_field_name, fields_to_check, term_list, case_sens)
    @fields_to_check = fields_to_check
    @term_list = JSON.parse(term_list)
    
    @output_field_name = output_field_name
    @case_sens = case_sens
    @list_or_category = "list"
  end

  # Extract terms
  def gen_termlist_block
    return lambda do |doc|
      termcategories = Array.new
      foundterms = Array.new
      @fields_to_check.each do |field|
        # Set the text depending on if it is case sensitive or not
        field_text = doc["_source"][field]
        if !@case_sens
          field_text = field_text.downcase if field_text
        end
        
        # Handle category lists with remapping
        if @term_list.is_a?(Hash)
          @term_list.each do |category, terms|
            termcategories, foundterms = match_terms(terms, category, termcategories, foundterms, field_text)
          end

        # Handle simple array lists
        elsif @term_list.is_a?(Array)
          termcategories, foundterms = match_terms(@term_list, nil, termcategories, foundterms, field_text)
        end
      end
      
      # Save in appropriate field, and save terms or categories
      if @list_or_category.downcase == "category"
        doc["_source"][@output_field_name] = termcategories.uniq
      else
        doc["_source"][@output_field_name] = foundterms.uniq
      end
      
      return doc
    end
  end

  # Check if there are matches for each term
  def match_terms(terms, category, termcategories, foundterms, field_text)
    terms.each do |term|
      # Figure out if term to check should be downcase
      if @case_sens
        check_term = term
      else
        check_term = term.downcase
      end
      
      # Check for term with regex
      if field_text =~ /(?<=(?:\b|\s|>|^))#{Regexp.escape(check_term)}(?=(?:\b|\s|'|<|$))/
        termcategories.push(category) if category
        foundterms.push(term)
      end
    end

    # Return matched categories (if any) and terms
    return termcategories, foundterms
  end

  # Initialize block to call
  def gen_block
    return gen_termlist_block
  end
end
