class EmailContact < Contact
  validates_format_of :value, :with => /\A[^@\s]+@[^@\s]+\z/
end
