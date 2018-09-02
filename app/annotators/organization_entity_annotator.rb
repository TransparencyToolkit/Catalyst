# Extracts names of organizations using Stanford-NER
class OrganizationEntityAnnotator < NamedEntityAnnotator
  def initialize(output_field_name, fields_to_check)
    super
    @entity_type = "organization"
  end
end
