# frozen_string_literal: false

class String
  def snake_to_kebab
    gsub('_', '-')
  end

  def kebab_to_snake
    gsub('-', '_')
  end
end
