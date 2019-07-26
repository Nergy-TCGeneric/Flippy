Strict

Import flippy
Import tile
Import level
Import levelloader
Import tilecolor

Class FlippyTest
	Public
	Method DoTests:Void()
		TileClickTest
		AdjacentTileColorChangeTest
		TileDestroyTest
		TileGravitationTest
	End Method
	
	Private
	Method TileClickTest:Void()
		' Code goes here
	End Method
	
	Method AdjacentTileColorChangeTest:Void()
		' Code goes here
	End Method
	
	Method TileDestroyTest:Void()
		' Code goes here
	End Method
	
	Method TileGravitationTest:Void()
		' Code goes here
	End Method
	
	Method AssertObj:Bool(expected:Object, actual:Object)
		If(expected <> actual)
			Throw New AssertFailureException("Expected " + expected + ", " + "but the actual is " + actual)
		Endif
		Return True
	End Method
	
	Method AssertInt:Bool(expected:Int, actual:Int)
		Return AssertObj(expected, actual)
	End Method
	
	Method AssertBool:Bool(expected:Bool, actual:Bool)
		Return AssertObj(expected, actual)
	End Method
	
End Class

Class AssertFailureException Extends Throwable
	Field msg:String
	Method New(msg:String)
		self.msg = msg
	End Method
End Class