class OxfordFacade 

  def self.call(word)
    response = OxfordRequest.call(word)
    response.respond_to?(:code) ? OxfordScraper.call(response) : response
  end

end
