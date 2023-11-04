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
    const { title, phonetic, audio } = data

    this.resultTarget.innerHTML = phonetic && audio ? `
      <ul class="md:grid md:grid-flow-col justify-stretch gap-4">
        <li><strong class="text-gray-400">Title</strong> <div class="bold text-4xl">${title}</div></li>
        <li class="mt-5 sm:mt-0"><strong class="text-gray-400">Phonetic</strong> <div class="bold text-4xl">${phonetic}</div></li>
      </ul>
      <div class="py-5">
        <audio controls autoplay class="block w-full">
          <source src="${audio}" type="audio/mpeg" />
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
