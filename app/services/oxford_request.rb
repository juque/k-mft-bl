require 'http'

class OxfordRequest < ApplicationService

  BASE_URL = 'https://www.oxfordlearnersdictionaries.com'.freeze

  RESOURCE = '/search/english/direct/?q='.freeze

  attr_reader :word

  def initialize(word)
    @word = word
  end

  def call
    url = "#{BASE_URL}#{RESOURCE}#{word}"
    response = HTTP.follow.get(url)
    case response.code
    when 200
      response
    when 404
      {status: 'error', message: 'Word not found'}
    when 500
      {status: 'error', message: 'Server error'}
    else
      nil
    end
  end

end
