class HomeController < ApplicationController
  before_action :scraping_param, only: :perform_scraping

  def index
  end

  def perform_scraping
  
    result = OxfordScraper.call(params[:q])

    respond_to do |format|
      format.json { render json: result, status: 201 }
    end

  end

  private

    def scraping_param 
      params.permit(:q, :format)
    end
end
