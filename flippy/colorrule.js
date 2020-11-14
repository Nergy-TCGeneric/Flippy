export default class ColorRule {
    constructor(colors) {
        if(!Array.isArray(colors)) throw "Illegal colors are given"
        this.colors = colors
    }

    getNextColor(color) {
        for(let i = 0; i < this.colors.length; i++) {
            if(this.colors[i] === color)
                return i == this.colors.length - 1 ? this.colors[0] : this.colors[i+1];
        }
        return null
    }

    getColorAt(idx) {
        if(idx < 0 || idx >= this.colors.length) throw "Index out of bounds"
        return this.colors[idx]
    }

    getLength() {
        if(!this.colors) throw "Illegal color rule format"
        return this.colors.length
    }
}