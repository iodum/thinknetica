class SearchesController < ApplicationController
  respond_to :html

  def index
    respond_with @items = Search.search(params[:q], params[:resource])
  end
end
