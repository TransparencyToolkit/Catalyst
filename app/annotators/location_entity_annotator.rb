# Extracts names of organizations using Stanford-NER
class LocationEntityAnnotator < NamedEntityAnnotator
  def initialize(output_field_name, fields_to_check)
    super
    @entity_type = "location"
  end
end
