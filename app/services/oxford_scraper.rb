require 'nokogiri'

class OxfordScraper < ApplicationService

  def initialize(response)
    @response = response
  end

  def call

    doc = Nokogiri::HTML(@response.body.to_s)

    scraped_result = {
      title: extract_inner_html(doc, 'h1'),
      phonetic_uk: extract_inner_html(doc, '.phons_br .phon'),
      phonetic_us: extract_inner_html(doc, '.phons_n_am .phon'),
      audio_uk: extract_attribute_value(doc, '.pron-uk', 'data-src-mp3'),
      audio_us: extract_attribute_value(doc, '.pron-us', 'data-src-mp3')
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
