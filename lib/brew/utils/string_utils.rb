class String
  def snake_to_kebab
    self.gsub('_', '-')
  end

  def kebab_to_snake
    self.gsub('-', '_')
  end
end