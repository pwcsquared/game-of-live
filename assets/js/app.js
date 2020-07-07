// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

const getPixelRatio = context => {
  var backingStore =
    context.backingStorePixelRatio ||
    context.webkitBackingStorePixelRatio ||
    context.mozBackingStorePixelRatio ||
    context.msBackingStorePixelRatio ||
    context.oBackingStorePixelRatio ||
    context.backingStorePixelRatio ||
    1;

  return (window.devicePixelRatio || 1) / backingStore;
};

const resize = (canvas, ratio) => {
    canvas.width = window.innerWidth * ratio;
    canvas.height = window.innerHeight * ratio;
    canvas.style.width = `${window.innerWidth}px`;
    canvas.style.height = `${window.innerHeight}px`;
}

const renderBoard = (board, length, canvas, canvasContext) => {
  const canvasSidePixelCount = canvas.width > canvas.height ? canvas.height : canvas.width;
  const cellSize = canvasSidePixelCount / length / getPixelRatio(canvasContext);
  canvasContext.fillStyle = "dodgerblue";

  canvasContext.clearRect(0, 0, canvas.width, canvas.height); 
  board.forEach((cell) => {
    const xPos = cell[0] * cellSize;
    const yPos = cell[1] * cellSize;
    canvasContext.fillRect(xPos, yPos, cellSize, cellSize);  // for live cells
  });
}

let hooks = {
  canvas: {
    mounted() {
      let canvas = this.el;
      let context = canvas.getContext("2d");
      let ratio = getPixelRatio(context);

      Object.assign(this, { canvas, context });

      let resizeCanvas = () => {
        this.pushEvent("resize", {width: window.innerWidth * ratio, height: window.innerHeight * ratio})
      }

      window.addEventListener("resize", resizeCanvas);
      this.pushEvent("resize", {width: window.innerWidth, height: window.innerHeight})
    },

    updated() {
      let { canvas, context } = this;
      let halfHeight = canvas.height / 2;
      let halfWidth = canvas.width / 2;
      let smallerHalf = Math.min(halfHeight, halfWidth);
      let board = JSON.parse(canvas.dataset.board);
      let length = canvas.dataset.length;

      if (this.animationFrameRequest) {
        window.cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = window.requestAnimationFrame(() => {
        renderBoard(board, length, canvas, context);
        this.pushEvent("advance", {});
      });
    }
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
