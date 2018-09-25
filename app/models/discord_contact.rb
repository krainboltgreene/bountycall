class DiscordContact < Contact
  validates_format_of :value, :with => /\A\@\S+/
end
