# Seed data for annotators to create
annotators = {
  "PersonEntityAnnotator" => {
    name: "Extract Names",
    description: "Extracts the names of people from text using named entity extraction.",
    default_icon: "social",
    default_human_readable_label: "People",
    output_display_type: "Category",
    input_params: {}
  },
  "OrganizationEntityAnnotator" => {
    name: "Extract Organizations",
    description: "Extracts the names of companies and other organizations from text using named entity extraction.",
    default_icon: "building",
    default_human_readable_label: "Organizations",
    output_display_type: "Category",
    input_params: {}
  },
  "LocationEntityAnnotator" => {
    name: "Extract Locations",
    description: "Extracts locations from text using named entity extraction.",
    default_icon: "map",
    default_human_readable_label: "Locations",
    output_display_type: "Category",
    input_params: {}
  },
  "SentimentAnnotator" => {
    name: "Analyze Sentiment",
    description: "Determines if a document expresses positive or negative sentiment.",
    default_icon: "sentiment",
    default_human_readable_label: "Sentiment",
    output_display_type: "Category",
    input_params: {}
  },
  "LanguageAnnotator" => {
    name: "Detect Language",
    description: "Detects the language each document is written in.",
    default_icon: "language",
    default_human_readable_label: "Language",
    output_display_type: "Category",
    input_params: {}
  },
  "TermlistAnnotator" => {
    name: "Extract Terms",
    description: "Takes a list of terms to extract and adds the terms each document includes as tags.",
    default_icon: "research",
    default_human_readable_label: "Extracted Terms",
    output_display_type: "Category",
    input_params: {term_list: "array", case_sensitive: "boolean"}
  },
  "NormalizedTermlistAnnotator" => {
    name: "Extract and Normalize Terms",
    description: "Takes a list of terms to extract along with a value to normalize each of them to. This is like the normal term exractor, but useful in situations where you may want to have a 2 letter country code, 3 letter country code, and country name all normalize to a single country name in the document tags.",
    default_icon: "analysis",
    default_human_readable_label: "Normalized Extracted Terms",
    output_display_type: "Category",
    input_params: {term_list: "hash", case_sensitive: "boolean"}
  },
  "RegexAnnotator" => {
    name: "Extract Regex Matches",
    description: "Extracts all terms in the text that match a regular expression.",
    default_icon: "regex",
    default_human_readable_label: "Regex Matches",
    output_display_type: "Set By User",
    input_params: {output_display_type: ["Category", "Short Text"], regex: "string"}
  },
  "HighscoreAnnotator" => {
    name: "Identify Keywords",
    description: "Identifies single-word keywords based on word length, frequency within a single document, and composition.",
    default_icon: "codewords",
    default_human_readable_label: "Keywords",
    output_display_type: "Category",
    input_params: {number_of_keywords: "integer"}
  },
  "RakeAnnotator" => {
    name: "Identify Multi-Word Keywords",
    description: "Detects multi-word keywords.",
    default_icon: "codewords",
    default_human_readable_label: "Multi-Word Keywords",
    output_display_type: "Category",
    input_params: {number_of_keywords: "integer"}
  },
  "EmailAnnotator" => {
    name: "Extract Email Addresses",
    description: "Extracts email addresses from document text.",
    default_icon: "email",
    default_human_readable_label: "Email",
    output_display_type: "Short Text",
    input_params: {}
  },
  "PhoneAnnotator" => {
    name: "Extract Phone Numbers",
    description: "Extracts phone numbers from document text.",
    default_icon: "telephone",
    default_human_readable_label: "Phone Numbers",
    output_display_type: "Short Text",
    input_params: {}
  },
  "IpAnnotator" => {
    name: "Extract IP Addresses",
    description: "Extracts IP addresses mentioned in a document.",
    default_icon: "server",
    default_human_readable_label: "IP Addresses",
    output_display_type: "Short Text",
    input_params: {}
  },
  "UrlAnnotator" => {
    name: "Extract Links",
    description: "Extracts links from document text.",
    default_icon: "link",
    default_human_readable_label: "Links",
    output_display_type: "Link",
    input_params: {}
  },
  "TfidfKeywordAnnotator" => {
    name: "Detect Significant Terms",
    description: "Finds keywords by comparing term frequency within a document to term frequency within the whole corpus using TF-IDF.",
    default_icon: "documents",
    default_human_readable_label: "Significant Terms",
    output_display_type: "Category",
    input_params: {num_keywords_per_document: "Ingeger"}
  }
}

annotators.each do |classname, settings|
  Annotator.create(classname: classname,
                   name: settings[:name],
                   description: settings[:description],
                   input_params: settings[:input_params],
                   output_display_type: settings[:output_display_type],
                   default_icon: settings[:default_icon],
                   default_human_readable_label: settings[:default_human_readable_label])
end
