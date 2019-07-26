Strict

Import tilecolor
Import level

Class LevelLoader
	' Level files are stored as JSON format.
	# Rem
		Replace stub code when it done.
	# End
	
	Method LoadLevel:Level()
		Local c:TileColor = New TileColor()
		Local colorrule:Float[][] = [c.getTileColor(1 Shl 1), c.getTileColor(1 Shl 2), c.getTileColor(1 Shl 3)]
		Return New Level(7, 6, colorrule)
	End Method
End Class