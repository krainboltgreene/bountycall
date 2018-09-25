class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :dynamic

  private def dynamic
    case params.fetch(:id)
    when "home" then "home"
    else "application"
    end
  end
end
