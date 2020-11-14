const TILE_SIZE = 100

export default class Game {
    constructor(hori, vert, colorrule) {
        if(hori < 0 || vert < 0 || colorrule == null) throw "Invalid value is given!"
        this.hori = hori
        this.vert = vert
        this.colorrule = colorrule
        this.tiles = []
    }

    init(app) {
        for(let i=0;i<this.hori * this.vert; i++) {
            let sprite = new PIXI.Sprite(PIXI.Texture.WHITE)
            sprite.tint = this.colorrule[i % this.colorrule.length]
            sprite.width = TILE_SIZE
            sprite.height = TILE_SIZE
            sprite.x = app.renderer.width / this.hori + sprite.width * (i % this.hori)
            sprite.y = app.renderer.height / this.vert + sprite.width * Math.floor(i / this.vert)
            sprite.interactive = true
            this.tiles.push(sprite)
            sprite.on('pointerdown', (data) => console.log("Sprite clicked", data.target))
            app.stage.addChild(sprite)
        }
    }

    getTile(clickedLoc) {
        // TODO: Code goes here
    }
}