import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["word", "result", "button", "wordList"];

  connect() {
    const wordList = this.wordListTarget.querySelectorAll('a');
    wordList.forEach(this._handleClickOnList.bind(this));
    this.wordTarget.addEventListener('keypress', event => {
      if (event.keyCode === 13) {
        this.buttonTarget.dispatchEvent(new Event('click'));
      }
    })
  }

  async search() {
    const element = this.wordTarget;
    const word = element.value;
    this.buttonTarget.disabled = true;
    this.buttonTarget.classList.add('italic');
    this.buttonTarget.classList.remove('bg-green-500');
    this.buttonTarget.classList.add('bg-green-900');
    console.log(this.buttonTarget.classList);
    if (word.length > 0) {
      try {
        const response = await fetch(`/scraping?q=${word.toLowerCase()}`, {
          method: 'GET',
          headers: { 'Accept': 'application/json' }
        });
        const result = await response.json();
        this._renderData(result.data);
      } catch (error) {
        console.log(error)
      } finally {
        this.buttonTarget.disabled = false;
        this.buttonTarget.classList.remove('italic');
        this.buttonTarget.classList.remove('bg-green-900');
        this.buttonTarget.classList.add('bg-green-500');
      }
    }

  }

  _renderData(data) {
    const { title, phonetic_uk, phonetic_us, audio_uk, audio_us } = data

    const phonetic = phonetic_uk && phonetic_us;
    const audio = audio_uk && audio_us;

    this.resultTarget.innerHTML = phonetic && audio ? `
      <div class="text-center bold text-4xl">${title}</div>
      <div class="py-5">
        <div class="px-5 pb-2 flex justify-between">
          <div>UK</div>
          <div class="bold text-2xl">${phonetic_uk}</div>
        </div>
        <audio controls autoplay class="block w-full">
          <source src="${audio_uk}" type="audio/mpeg" />
        </audio>
      </div>
      <div class="py-5">
        <div class="px-5 pb-2 flex justify-between">
          <div>US</div>
          <div class="bold text-2xl">${phonetic_us}</div>
        </div>
        <audio controls class="block w-full">
          <source src="${audio_us}" type="audio/mpeg" />
        </audio>
      </div>`
      : '<p class="italic">Word not found</p>'

  }

  _handleClickOnList(item) {
    item.addEventListener( 'click', event => {
      event.preventDefault();
      const currentText = event.target.innerText;
      this.wordTarget.value = currentText
      this.buttonTarget.dispatchEvent(new Event('click'));
    })
  }

}
