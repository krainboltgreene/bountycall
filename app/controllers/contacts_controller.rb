class ContactsController < ApplicationController
  before_action :authenticate_account!

  def new
    subtype = params.fetch(:subtype, nil)

    contact = if subtype.present?
      current_account.contacts.where(:subtype => subtype).build
    end

    render(:new, locals: {:contact => contact})
  end

  def create
    subtype = params.require(:contact).require(:subtype)
    value = params.require(:contact).require(:value)

    contact = subtype.constantize.where(:account => current_account).create!(:value => value)

    redirect_to root_url
  end

  def update
    contact_id = params.require(:id)

    contact = Contact.find(contact_id).morph

    contact.confirm!

    redirect_to root_url
  end
end
