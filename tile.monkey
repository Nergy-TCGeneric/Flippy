Strict

Import tilecolor

' If tile is destoryed, the color array will filled with 0

Class Tile
	Field color:Float[] = [ 0.0, 0.0, 0.0 ] ' Failsafe
	Field x:Int = 0
	Field y:Int = 0
	Field size:Int = 50
	Field willbedestroyed:Bool = False
	
	Method New(x:Int, y:Int, color:Float[])
		Self.color = color
		Self.x = x
		Self.y = y
	End Method
	
	Method ChangeColor:Void(nextcolor:Float[])
		color = nextcolor
	End Method
End