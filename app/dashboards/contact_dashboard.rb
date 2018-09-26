class ContactDashboard < ApplicationDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    :id => Field::String,
    :account => Field::BelongsTo.with_options,
    :versions => Field::HasMany.with_options,
    :subtype => Field::String,
    :value => Field::String,
    :confirmation_state => Field::String,
    :confirmation_state_event => StateMachineField,
    :created_at => Field::DateTime,
    :updated_at => Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :account,
    :value,
    :confirmation_state,
    :subtype,
    :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :subtype,
    :value,
    :confirmation_state,
    :created_at,
    :updated_at,
    :account,
    :versions
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :confirmation_state_event
  ].freeze

  # Overwrite this method to customize how contacts are displayed
  # across all pages of the admin dashboard.
  def display_resource(contact)
    contact.id
  end
end
