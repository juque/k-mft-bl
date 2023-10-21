require 'http'
require 'nokogiri'
require 'json'
require 'scraper'

class OxfordScraper < ApplicationService

  BASE_URL = 'https://www.oxfordlearnersdictionaries.com'
  RESOURCE = '/definition/english/'

  attr_reader :word

  def initialize(word)
    @word = word
  end

  def call

    begin
      http = HTTP.persistent(BASE_URL)
      response = http.follow.get("#{RESOURCE}/#{word}")
      Scraper.new("#{response.body}").run
    rescue StandardError => e
      puts "#{e.class} -> #{e.message}"
    ensure
      http.close if http
    end

  end

end
