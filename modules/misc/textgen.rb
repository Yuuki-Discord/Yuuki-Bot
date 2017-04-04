module YuukiBot
  module Textgen
    def self.generate_string(template, parts, variables = nil)
      # Choose random template
      template_base = template.sample
      # Parse variables
      unless variables.nil?
        variables.each do |variable|
          template_base = template_base.gsub("{#{variable[0]}}", (variable[1]).to_s)
        end
      end
      # Parse parts
      parts.each do |part|
        # First check this part is actually in the string.
        dynamic_regex = "{#{part[0]}}"
        loop do
          match = Regexp.new(dynamic_regex).match(template_base)
          # Check for match
          break if match.nil?
          # Okay, we can continue. Let's get a random part.
          part_to_replace = part[1].sample
          template_base = template_base.sub(dynamic_regex, part_to_replace.to_s)
        end
      end
      template_base
    end
  end
end