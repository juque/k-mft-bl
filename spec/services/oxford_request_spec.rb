require 'webmock/rspec'

describe OxfordRequest do

  describe '#call' do
    let(:oxford_request) { OxfordRequest.new(word) }

    context 'when the word is found' do
      let(:word) { 'hello' }

      it 'returns a successful response' do
        stub_request(:get, "https://www.oxfordlearnersdictionaries.com/search/english/direct/?q=#{word}")
          .to_return(status: 200)

        expect(oxford_request.call.code).to eq(200)
      end
    end


    context 'when the word is not found' do
      let(:word) { 'nonexistent' }

      it 'returns an error message for word not found' do
        stub_request(:get, "https://www.oxfordlearnersdictionaries.com/search/english/direct/?q=#{word}")
          .to_return(status: 404)

        expect(oxford_request.call).to eq({ status: 'error', message: 'Word not found' })
      end
    end

  end

end
