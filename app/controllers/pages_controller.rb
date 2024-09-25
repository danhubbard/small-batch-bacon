class PagesController < ApplicationController

  def index
  end

  def show
    page = params[:id].gsub(/[^\w-]/, '').underscore
    render template: "pages/#{page}"
  end
end