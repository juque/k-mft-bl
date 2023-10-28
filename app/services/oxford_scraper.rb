require 'nokogiri'

class OxfordScraper < ApplicationService

  def initialize(response)
    @response = response
  end

  def call

    doc = Nokogiri::HTML(@response.body.to_s)

    scraped_result = {
      title: extract_inner_html(doc, 'h1'),
      phonetic: extract_inner_html(doc, '.phon'),
      audio: extract_attribute_value(doc, '.pron-uk', 'data-src-mp3')
    }

  end

  private

  def extract_inner_html(doc, selector) 
    element = doc.css(selector).first
    element&.inner_html
  end

  def extract_attribute_value(doc, selector, attribute_name)
    element = doc.css(selector).first
    element&.attribute(attribute_name)&.value
  end

end
