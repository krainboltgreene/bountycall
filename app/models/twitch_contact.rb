class TwitchContact < Contact
  validates_format_of :value, :with => /\A\@\S+/
end
