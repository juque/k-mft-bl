require 'webmock/rspec'

describe OxfordScraper do

  subject(:scraper) { OxfordScraper.new(response) }

  context 'Successful scrape' do

    let(:response) { double(body: File.read('spec/support/fixtures/comfortable.html'))  }

    it 'returns a scraped result with: title, phonetic and audio' do

      scraped_result = scraper.call

      expect(scraped_result).to eq({
        title: 'comfortable',
        phonetic: '/ˈkʌmftəbl/',
        audio: 'https://www.oxfordlearnersdictionaries.com/media/english/uk_pron/c/com/comfo/comfortable__gb_1.mp3'
      })

    end
  end

  context 'The scraped result does not have valid data' do

    let(:response) { double(body: File.read('spec/support/fixtures/not_match_elements.html')) }

    it 'returns a scraped result with nil title, phonetic, and audio' do

      scraped_result = scraper.call

      expect(scraped_result).to eq({
        title: nil,
        phonetic: nil,
        audio: nil
      })

    end

  end

end
