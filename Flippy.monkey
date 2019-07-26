Strict

Import mojo
Import tilecolor
Import tile
Import level
Import levelloader

Function Main:Int()
	New Game()
	Return 0
End Function

' Read pre-develop document for further game development.

Class Game Extends App

	Private
	Field level:Level
	
	Method OnCreate:Int()
		SetUpdateRate(60)
		Local loader:LevelLoader = New LevelLoader ' TODO: Do tests first. if done, remove at release.
		level = loader.LoadLevel()
		Return 0
	End Method
	
	Method OnUpdate:Int()
		level.Render()
		Return 0
	End Method
End