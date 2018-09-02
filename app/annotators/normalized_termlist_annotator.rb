# Tags documents with the term they include and remaps them according to normalized list
class NormalizedTermlistAnnotator < TermlistAnnotator
  def initialize(output_field_name, fields_to_check, term_list, case_sens)
    super
    @list_or_category = "category"
  end
end
