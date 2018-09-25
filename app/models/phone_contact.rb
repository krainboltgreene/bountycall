class PhoneContact < Contact
  validates_format_of :value, :with => /\A\+?[1-9]\d{1,14}\z/
end
