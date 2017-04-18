module RegexUtils
  # Run the regex on the text passed in
  def run_regex(field_text, regex)
    raw_matches = field_text.to_enum(:scan, /#{regex}/).map{Regexp.last_match}
    return raw_matches.map{|match| match.to_s}
  end
end
