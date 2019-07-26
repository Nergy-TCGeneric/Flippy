Strict

Class TileColor

	# Rem
	* Color is hardcoded. but, i think i have no choice.
	
	Const RED:Float[] = [ 226, 0, 0 ]
	Const YELLOW:Float[] = [ 255, 242, 0 ]
	Const GREEN:Float[] = [ 128, 255, 128 ] 
	Const BLUE:Float[] = [ 0, 162, 232 ]
	Const ORANGE:Float[] = [ 255, 127, 39 ]
	Const DARK_BLUE:Float[] = [ 128, 0, 255 ]
	Const PINK:Float[] = [ 255, 0, 128 ]
	Const BROWN:Float[] = [ 128, 64, 64 ]
	# End
	
	Public 
	Method getTileColor:Float[] (id:int)
		Select id
			Case 1 Shl 1
				Return [ 226.0, 0.0, 0.0 ]
			Case 1 Shl 2
				Return [ 255.0, 242.0, 0.0 ]
			Case 1 Shl 3
				Return [ 128.0, 255.0, 128.0 ]
			Case 1 Shl 4
				Return [ 0.0, 162.0, 232.0 ]
			Case 1 Shl 5
				Return [ 255.0, 127.0, 39.0 ]
			Case 1 Shl 6
				Return [ 128.0, 0.0, 255.0 ]
			Case 1 Shl 7
				Return [ 255.0, 0.0, 128.0 ]
			Case 1 Shl 8
				Return [ 128.0, 64.0, 64.0 ]
			Default
				Return New Float[3]
		End Select
	End Method
	
	Method IsBlankColor:Bool(color:Float[])
		If(color.Length() <> 3) ' If format is not RGB format, return true
			Return True
		Endif
		Return color[0] = 0 And color[1] = 0 And color[2] = 0
	End Method
	
	Method IsEqualColor:Bool(first:Float[], second:Float[])
		If(IsBlankColor(first) Or IsBlankColor(second)) ' If color is blank, comparison becomes meaningless.
			Return false
		EndIf
		If(first.Length() <> 3 Or second.Length() <> 3)
			Return false
		EndIf
		Return first[0] = second[0] And first[1] = second[1] And first[2] = second[2]
	End Method
End Class