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
      const questionCreatedAt = this.getCreatedAt(element);
      const questionOwner = this.getOwner(element);
      const upvotes = element.querySelector(
        `#question_${questionId}_count`
      ).innerText;
      const q = {
        id: questionId,
        created_at: questionCreatedAt,
        owner: questionOwner,
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
        this.removeHidden();
        this.trending();
        break;
      case "recent":
        this.removeHidden();
        this.sortByTimeNewToOld();
        break;
      case "oldies":
        this.removeHidden();
        this.sortByTimeOldToNew();
        break;
      case "justyours":
        this.justyours();
        break;
      default:
        this.removeHidden();
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

  getCreatedAt(question) {
    return question.dataset.questionCreated || null;
  }

  getOwner(question) {
    return question.dataset.questionOwner || null;
  }

  trending() {
    this.listOfQuestions.sort((a, b) => {
      if (a.upvotes == b.upvotes) {
        return b.created_at - a.created_at;
      } else {
        return b.upvotes - a.upvotes;
      }
    });
  }

  sortByTimeNewToOld() {
    this.listOfQuestions.sort((a, b) => {
      return b.created_at - a.created_at;
    });
  }

  sortByTimeOldToNew() {
    this.listOfQuestions.sort((a, b) => {
      return a.created_at - b.created_at;
    });
  }

  // Displays the user's question(s)
  justyours() {
    this.listOfQuestions.map((a) => {
      if (a.owner !== "you") {
        document.querySelector(`#question_${a.id}`).classList.add("hidden");
      }
    });
  }

  // Removes hidden from an element only if this element is hidden
  removeHidden() {
    this.listOfQuestions.map((a) => {
      if (
        document.querySelector(`#question_${a.id}`).classList.contains("hidden")
      ) {
        document.querySelector(`#question_${a.id}`).classList.remove("hidden");
      }
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
        tab.classList.add(...this.activeClasses);
      } else {
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
