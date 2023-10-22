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
      <ul style="list-style-type:none;padding-left:0">
        <li><strong>Title</strong>: ${title}</li>
        <li><strong>Phonetic</strong>: ${phonetic}</li>
        <li>
          <audio controls autoplay class="block w-full">
            <source src="${audio}" type="audio/mpeg" />
          </audio>
        </li>
      </ul>`
      : "<p>Word not found</p>"

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
