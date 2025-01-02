// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let Hooks = {};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

Hooks.TestEachProject = {
  mounted() {
    this.chart = null; // Initialize chart instance
    this.delayed = false; // Define delayed at the instance level
    this.initChart();
  },

  destroyed() {
    // Destroy the chart when the component is removed
    if (this.chart) {
      this.chart.destroy();
    }
  },

  initChart() {
    const totals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    const canvasId = this.el.querySelector("canvas").id; // Get the unique canvas ID
    const canvas = document.getElementById(canvasId);

    // Destroy the existing chart instance if it exists
    if (this.chart) {
      this.chart.destroy();
    }

    this.chart = new Chart(canvas, {
      type: "bar",
      data: {
        labels: months,
        datasets: [
          {
            label: "Campaign Analytics",
            data: totals,
            backgroundColor: "#9681B1",
            borderWidth: 0,
            borderRadius: 5,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            display: false, // Hide legend
          },
          title: {
            display: false,
            text: "Values",
            color: "#849aa9",
          },
        },
        scales: {
          y: {
            display: false,
          },
          x: {
            display: true,
            position: "bottom",
            color: "#9681B1",
            grid: {
              display: false, // Remove the grid lines
            },
          },
        },
        animation: {
          onComplete: () => {
            this.delayed = true;
          },
          delay: (context) => {
            let delay = 0;
            if (
              context.type === "data" &&
              context.mode === "default" &&
              !this.delayed
            ) {
              delay = context.dataIndex * 300 + context.datasetIndex * 100;
            }
            return delay;
          },
        },
        elements: {
          bar: {
            barPercentage: 0.9, // Make bars 90% of the available space
          },
        },
      },
    });
  },
};

Hooks.FlatpickrHook = {
  mounted() {
    const toggleButton = this.el.querySelector("#togglePicker");
    const dateInput = this.el.querySelector("#datepicker");

    // Initialize Flatpickr on the hidden input
    this.flatpickrInstance = flatpickr(dateInput, {
      enableTime: false,
      dateFormat: "Y-m-d",
      onChange: (selectedDates, dateStr) => {
        this.pushEvent("date_selected", { value: dateStr });
      },
    });

    // Show the Flatpickr input when clicking the label
    toggleButton.addEventListener("click", () => {
      this.flatpickrInstance.open(); // Open Flatpickr without altering the layout
    });
  },

  destroyed() {
    if (this.flatpickrInstance) {
      this.flatpickrInstance.destroy();
    }
  },
};

Hooks.OutsideClickHook = {
  mounted() {
    // Add a click listener to the document
    this.handleOutsideClick = (event) => {
      if (!this.el.contains(event.target)) {
        this.pushEvent("clear_priority_list");
      }
    };

    document.addEventListener("click", this.handleOutsideClick);
  },

  destroyed() {
    // Remove the click listener when the hook is destroyed
    document.removeEventListener("click", this.handleOutsideClick);
  },
};
Hooks.FlatpickrHookDateTime = {
  mounted() {
    const toggleButton = this.el.querySelector("#togglePickerDateTime");
    const dateInput = this.el.querySelector("#datetimepicker");

    // Initialize Flatpickr on the hidden input
    this.flatpickrInstance = flatpickr(dateInput, {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      onChange: (selectedDates, dateStr) => {
        this.pushEvent("datetime_selected", { value: dateStr });
      },
    });

    toggleButton.addEventListener("click", () => {
      this.flatpickrInstance.open(); // Open Flatpickr without altering the layout
    });
  },

  destroyed() {
    if (this.flatpickrInstance) {
      this.flatpickrInstance.destroy();
    }
  },
};

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
