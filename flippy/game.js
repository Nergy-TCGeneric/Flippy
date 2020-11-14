const TILE_SIZE = 100

export default class Game {
    constructor(hori, vert, colorrule) {
        if(hori < 0 || vert < 0 || colorrule == null) throw "Invalid value is given!"
        this.hori = hori
        this.vert = vert
        this.colorrule = colorrule
        this.tiles = {}
    }

    init(app) {
        for(let i=0;i<this.hori * this.vert; i++) {
            let sprite = new PIXI.Sprite(PIXI.Texture.WHITE)
            sprite.tint = this.colorrule.getColorAt(i % this.colorrule.getLength())
            sprite.width = TILE_SIZE
            sprite.height = TILE_SIZE
            sprite.id = i
            sprite.x = app.renderer.width / this.hori + sprite.width * (i % this.hori)
            sprite.y = app.renderer.height / this.vert + sprite.width * Math.floor(i / this.vert)
            sprite.interactive = true
            this.tiles[i] = sprite
            app.stage.addChild(sprite)
            sprite.on('pointerdown', (data) => {
                console.log('clicked', data.target)
                data.target.tint = this.colorrule.getNextColor(data.target.tint)
                this.changeAdjacentTile(data.target.id)
            })
        }
    }

    // TODO: Use % 
    changeAdjacentTile(tileId) {
        if(tileId - 1 > 0) this.tiles[tileId - 1].tint = this.colorrule.getNextColor(this.tiles[tileId - 1].tint)
        if(tileId + 1 < this.hori * this.vert) this.tiles[tileId + 1].tint = this.colorrule.getNextColor(this.tiles[tileId + 1].tint)
        if(tileId - this.hori > 0) this.tiles[tileId - this.hori].tint = this.colorrule.getNextColor(this.tiles[tileId - this.hori].tint)
        if(tileId + this.hori < this.hori * this.vert) this.tiles[tileId + this.hori] = this.colorrule.getNextColor(this.tiles[tileId + this.hori].tint)
    }
}