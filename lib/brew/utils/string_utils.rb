# frozen_string_literal: false

class String
  def snake_to_kebab
    gsub('_', '-')
  end

  def squish
    strip.gsub(/\s+/, ' ')
  end
end
