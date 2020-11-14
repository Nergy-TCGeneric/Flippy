import Game from "./flippy/game.js"

const container = document.getElementById("flippy-container")
const COLORS = [ 0x0048BA, 0xB0BF1A, 0x7CB9E8, 0xC0E8D5, 0xC46210, 0xE52B50, 0x3B7A57, 0xFFBF00 ]
const app = new PIXI.Application({
    resizeTo: container
})
app.renderer.autoDensity = true
app.renderer.resize(container.offsetWidth, container.offsetHeight)
container.appendChild(app.view)

let game = new Game(5, 5, COLORS)
game.init(app)