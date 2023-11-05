require 'webmock/rspec'

describe OxfordScraper do

  subject(:scraper) { OxfordScraper.new(response) }

  context 'Successful scrape' do

    let(:response) { double(body: File.read('spec/support/fixtures/comfortable.html'))  }

    it 'returns a scraped result with: title, phonetic and audios (UK and US)' do

      scraped_result = scraper.call

      expect(scraped_result).to eq({
        title: 'comfortable',
        phonetic_uk: '/ˈkʌmftəbl/',
        phonetic_us: '/ˈkʌmftəbl/',
        audio_uk: 'https://www.oxfordlearnersdictionaries.com/media/english/uk_pron/c/com/comfo/comfortable__gb_1.mp3',
        audio_us: 'https://www.oxfordlearnersdictionaries.com/media/english/us_pron/c/com/comfo/comfortable__us_4.mp3',
      })

    end
  end

  context 'The scraped result does not have valid data' do

    let(:response) { double(body: File.read('spec/support/fixtures/not_match_elements.html')) }

    it 'returns a scraped result with nil title, phonetic, and audio' do

      scraped_result = scraper.call

      expect(scraped_result).to eq({
        title: nil,
        phonetic_uk: nil,
        phonetic_us: nil,
        audio_uk: nil,
        audio_us: nil
      })

    end

  end

end
