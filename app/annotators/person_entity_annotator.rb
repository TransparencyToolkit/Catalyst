# Extracts names of people using Stanford-NER
class PersonEntityAnnotator < NamedEntityAnnotator
  def initialize(output_field_name, fields_to_check)
    super
    @entity_type = "person"
  end
end
