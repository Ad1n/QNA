class SearchController < ApplicationController

  def search
    @search_class = search_klass
    authorize! :search, @search_class
    @result = search_klass.search params[:query]
    render "search/search"
  end

  private

  def search_klass
    params[:search_type].classify.constantize
  end
end
