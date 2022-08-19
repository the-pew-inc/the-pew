import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="order-questions"
export default class extends Controller {
  static targets = ["question"];

  connect() {
    this.listOfQuestions = [];
    this.connectObserver();
    this.update();
  }

  disconnect() {
    this.observer.disconnect();
  }

  update(event) {
    const questions = this.questionTargets;
    questions.forEach((element, index) => {
      const questionId = this.getQuestionId(element);
      const upvotes = element.querySelector(
        `#question_${questionId}_count`
      ).innerText;
      const q = {
        id: questionId,
        upvotes: upvotes,
        cronoIndex: index,
        element: element.parentNode,
      };
      const indx = this.listOfQuestions.findIndex((ele) => {
        return ele.id === q.id;
      });
      if (indx === -1) {
        this.listOfQuestions.push(q);
      } else {
        this.listOfQuestions[indx] = q;
      }
    });

    this.sortByVotes();

    // Disconnect the observer
    this.disconnect();

    // Mess with the DOM
    if (this.listOfQuestions.length > 0) {
      for (let i = 0; i < this.listOfQuestions.length; i++) {
        const element = this.listOfQuestions[i];
        const oldElement = document.querySelector(`#question_${element.id}`);
        const parent = oldElement.parentNode;
        parent.removeChild(oldElement);
        parent.appendChild(element.element);
      }
    }

    // Reconnect the observer
    this.connectObserver();
  }

  getQuestionId(question) {
    return question.dataset.questionId || null;
  }

  sortByVotes() {
    this.listOfQuestions.sort((a, b) => {
      if (a.upvotes < b.upvotes) return 1;
      if (a.upvotes > b.upvotes) return -1;
      if (a.upvotes == b.upvotes) {
        if (a.id < b.id) return -1;
      } else {
        return 1;
      }
    });
  }

  sortByTime() {
    this.listOfQuestions.sort((a, b) => {
      if (a.id < b.id) return -1;
      if (a.id > b.id) return 1;
    });
  }

  connectObserver() {
    this.observer = new MutationObserver(this.update.bind(this));
    this.observer.observe(this.element, {
      childList: true,
      attributes: false,
      subtree: true,
    });
  }
}
