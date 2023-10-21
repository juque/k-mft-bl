class Scraper

  attr_reader :input

  def initialize(input)
    @input = input
  end

  def run

    doc = Nokogiri::HTML(input.to_s)
    scraped_result = {
      title: extract_inner_html(doc, 'h1'),
      phonetic: extract_inner_html(doc, '.phon'),
      audio: extract_attribute_value(doc, '.pron-uk', 'data-src-mp3')
    }

    return { status: "success", data: {} } if scraped_result[:phonetic].nil? || scraped_result[:audio].nil?

    format_result(scraped_result)

  end

  private

  def format_result(scraped_result)
    { status: "success", data: scraped_result }
  end

  def extract_inner_html(doc, selector)
    element = doc.css(selector).first
    element&.inner_html
  end

  def extract_attribute_value(doc, selector, attribute_name)
    element = doc.css(selector).first
    element&.attribute(attribute_name)&.value
  end

end
