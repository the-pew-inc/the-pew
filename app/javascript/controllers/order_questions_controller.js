import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="order-questions"
export default class extends Controller {
  static targets = ["question", "tab"];
  static classes = ["active", "inactive"];
  static values = { ordering: { type: String, default: "trending" } };

  connect() {
    this.listOfQuestions = [];
    this.connectObserver();
    this.initTabs();
    this.update();
  }

  disconnect() {
    this.observer.disconnect();
  }

  update() {
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

    switch (this.orderingValue) {
      case "trending":
        this.trending();
        break;
      case "recent":
        this.sortByTimeNewToOld();
        break;
      case "oldies":
        this.sortByTimeOldToNew();
        break;
      default:
        this.trending();
        break;
    }

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

  trending() {
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

  sortByTimeNewToOld() {
    this.listOfQuestions.sort((a, b) => {
      if (a.id < b.id) return -1;
      if (a.id > b.id) return 1;
    });
  }

  sortByTimeOldToNew() {
    this.listOfQuestions.sort((a, b) => {
      if (a.id < b.id) return 1;
      if (a.id > b.id) return -1;
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

  refreshWithOrder(event) {
    this.orderingValue = event.params.order;
    // Update the question list
    this.update();
    // Update the tabs
    this.updateTabs();
  }

  initTabs() {
    this.tabs = this.tabTargets;
    this.tabs.forEach((tab) => {
      if (tab.getAttribute("aria-current") === "page") {
        console.debug("We found the current page");
        tab.classList.add(...this.activeClasses);
      } else {
        console.debug("This is not the current page");
        tab.classList.add(...this.inactiveClasses);
      }
    });
  }

  updateTabs() {
    this.tabs.forEach((tab) => {
      if (
        tab.getAttribute("data-order-questions-order-param") ===
          this.orderingValue &&
        tab.getAttribute("aria-current") === "page"
      ) {
        // already active - do nothing just exit the loop
        return;
      }
      if (
        tab.getAttribute("data-order-questions-order-param") ===
          this.orderingValue &&
        tab.getAttribute("aria-current") !== "page"
      ) {
        // make active and keep looping till the end
        tab.classList.remove(...this.inactiveClasses);
        tab.classList.add(...this.activeClasses);
        tab.setAttribute("aria-current", "page");
      }
      if (
        tab.getAttribute("data-order-questions-order-param") !==
          this.orderingValue &&
        tab.getAttribute("aria-current") === "page"
      ) {
        // make inactive and keep looping till the end
        tab.classList.remove(...this.activeClasses);
        tab.classList.add(...this.inactiveClasses);
        tab.setAttribute("aria-current", "none");
      }
    });
  }
}
