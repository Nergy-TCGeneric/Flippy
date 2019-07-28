Strict

Import mojo2
Import tilecolor
Import tile
Import monkey.random

Class Level

	Private
	Field rows:Int
	Field cols:Int
	Field tilegrid:Tile[]
	Field colorrule:Float[][]
	Field canvas:Canvas
	Field colormgr:TileColor
	Field score:Int
	Field gamemodestrategy:GameMode
	
	Public
	Method New(rows:Int, cols:Int, colorrule:Float[][])
		Self.rows = rows
		Self.cols = cols
		Self.tilegrid = New Tile[rows * cols]
		Self.colorrule = colorrule
		Self.canvas = New Canvas
		Self.colormgr = New TileColor()
		score = 0
		InitializeTiles()
	End Method
	
	Method Render:Void()
		' column : vertical, row : horizontal - do not confuse :p
		' Note that on Desktop, Each Device's width and height is 640, 480.
		' Of course, this resolution can be modified by using 2D transform.
		canvas.Clear
		For Local i:Int=0 Until rows
			For Local j:Int=0 Until cols
				Local t:Tile = tilegrid[i*(rows-1) + j]
				canvas.SetColor(t.color[0], t.color[1], t.color[2])
				canvas.DrawRect(t.x, t.y, t.size, t.size)
			Next
		Next
		canvas.DrawText("Score: " + score, 540, 40)
		canvas.Flush
		
		Local touched:Tile = Null
		For Local i:Int=0 Until rows * cols
			Local t:Tile = tilegrid[i]
			If(colormgr.IsBlankColor(t.color))
				Continue
			Else
				If(MouseHit(MOUSE_LEFT))
					If(TouchX(0) >= t.x And TouchX(0) <= t.x + t.size)
						If(TouchY(0) >= t.y And TouchY(0) <= t.y + t.size)
							touched = t
						Endif
					Endif
				Endif
			EndIf
		Next
		
		If(touched <> Null)
			touched.ChangeColor(GetNextColorFromRule(touched.color))
			ChangeAdjacentTileColor(touched)
		End If
		
		Seed = Millisecs()
		DestroySameColorTile()
		GravitateTiles()
		GenerateTile()
	End Method
	
	Private
	Method InitializeTiles:Void()
		Seed = Millisecs()
		#Rem
		For Local i:Int = 0 Until rows	' Rows first, columns last.
			For Local j:Int = 0 Until cols
				' Don't randomly generate tiles at first. Try to make every adjacent tile's color is different
				Local colornum:Int = Int(Rnd()*3)
				Local c:Float[] = colorrule[colornum]
				Local t:Tile = New Tile(DeviceWidth()/3 + 50 * i, DeviceHeight()/4 + 50 * j, c)
				tilegrid[i*cols + j] = t
			Next
		Next
		#End
		
		' Initialize phase
		Local avaidx:Int[] = New Int[rows * cols]
		For Local i:= Eachin avaidx
			i = 1
		Next
		
		Local placecomplete:Bool = False
		Repeat
			' Code goes here
		Until placecomplete
	End Method
	
	Method GravitateTiles:Void()
		
		For Local i:Int = cols - 1 To rows * cols
			Local count:Int = 0
			Repeat
				For Local j:Int = i To i - cols + 2 Step -1
					Local target:Tile = tilegrid[j]
					Local target2:Tile = tilegrid[j+1]
				
					If(colormgr.IsBlankColor(target.color) And Not colormgr.IsBlankColor(target2.color))
						Local temp:Tile = target
						target = target2
						target2 = temp
					Endif
					
					If(j = i - cols + 2)
						count += 1
					EndIf
					' Don't do anything when target has non-blank color and target2 has blank-color, or both has blank or non-blank colors.
				Next
			Until count >= cols
			i += cols
		Next
	End Method
	
	Method GenerateTile:Void()
		' Search for blank tiles and add random tiles at there.
		' Must called after GravitateTiles() is called.
		For Local i:Int=0 Until rows * cols
			Local t:Tile = tilegrid[i]
			If(colormgr.IsBlankColor(t.color))
				Local idx:Int = Int(Rnd()*3)
				t.color = colorrule[idx]
			Endif
		Next
	End Method
	
	' Assuming that tile grid is rectangular. If tile is destroyed, tile's color will be a blank color(0, 0, 0).
	Method DestroySameColorTile:Void()
		UnmarkDestroyableTiles()
		MarkDestroyableTiles()
		For Local i:Int = 0 Until cols * rows
			If(tilegrid[i].willbedestroyed)
				tilegrid[i].color = New Float[3] ' 5 score per one tile
				score += 5
			Endif
		Next
	End Method
	
	' Assuming that tile grid is rectangular.
	Method ChangeAdjacentTileColor:Void(origin:Tile)
		Local idx:Int = GetIndexOfTile(origin)
		
		Local u:Bool = True
		Local d:Bool = True
		Local r:Bool = True
		Local l:Bool = True
		
		If(idx Mod cols = 0)
			u = False
		Endif
		If(idx Mod cols = cols - 1)
			d = False
		Endif
		If(idx < cols)
			l = False
		Endif
		If(idx >= cols * (rows - 1))
			r = False
		Endif
		
		If(u)
			tilegrid[idx - 1].ChangeColor(GetNextColorFromRule(tilegrid[idx - 1].color))
		Endif
		If(d)
			tilegrid[idx + 1].ChangeColor(GetNextColorFromRule(tilegrid[idx + 1].color))
		Endif
		If(l)
			tilegrid[idx - cols].ChangeColor(GetNextColorFromRule(tilegrid[idx - cols].color))
		Endif
		If(r)
			tilegrid[idx + cols].ChangeColor(GetNextColorFromRule(tilegrid[idx + cols].color))
		Endif
		
	End Method
	
	Method GetNextColorFromRule:Float[](color:Float[])
	
		Local last:Float[] = colorrule[colorrule.Length()-1]
		If(colormgr.IsEqualColor(last, color))
			Return colorrule[0]
		EndIf
	
		For Local i:Int=0 Until colorrule.Length() - 1
			Local crule:Float[] = colorrule[i]
			If(colormgr.IsEqualColor(crule, color))
				Return colorrule[i+1]
			Endif
		Next
		
		Return New Float[3]
	End Method
	
	Method GetIndexOfTile:Int(target:Tile)
		For Local i:Int = 0 Until rows * cols
			Local t:Tile = tilegrid[i]
			If(t.x = target.x And t.y = target.y)
				Return i
			EndIf
		Next
		Return -1
	End Method
	
	' TODO: Now clarify this messy code.
	' Assuming that tile is rectangular.
	Method MarkDestroyableTiles:Void()
		
		Local checkedindex:IntSet = New IntSet
		Local rowadj:Int = 0
		Local coladj:Int = 0
		
		' Column deletion marking
		For Local i:Int = 0 Until rows * cols
			If(i Mod cols < cols - 1)
				Local c1:Float[] = tilegrid[i].color
				Local c2:Float[] = tilegrid[i+1].color
				
				If(colormgr.IsBlankColor(c1) Or colormgr.IsBlankColor(c2))
					rowadj = 0
				EndIf
					
				If(colormgr.IsEqualColor(c1, c2))
					rowadj += 1
					checkedindex.Insert(i)
					checkedindex.Insert(i+1)
				Else
					rowadj = 0
					checkedindex.Clear()
				EndIf
			Else
				checkedindex.Clear()
				rowadj = 0
			Endif
			
			If(rowadj >= 2)
				Local enum:= checkedindex.ObjectEnumerator()
				Repeat
					Local i:= enum.NextObject()
					tilegrid[i].willbedestroyed = True
				Until Not enum.HasNext()
			EndIf
		Next
		
		' Row deletion marking
		For Local i:Int = 0 Until rows - 1
			For Local j:Int = 0 Until cols
				If(j Mod cols < cols)
					Local c1:Float[] = tilegrid[i + j * cols].color
					Local c2:Float[] = tilegrid[i + (j + 1) * cols].color
					
					If(colormgr.IsBlankColor(c1) Or colormgr.IsBlankColor(c2))
						coladj = 0
					EndIf
					
					If(colormgr.IsEqualColor(c1, c2))
						coladj += 1
						checkedindex.Insert(i + j * cols)
						checkedindex.Insert(i + (j + 1)* cols)
					Else
						coladj = 0
						checkedindex.Clear()
					EndIf
				Else
					checkedindex.Clear()
					coladj = 0
				Endif
				
				If(coladj >= 2)
					Local enum:= checkedindex.ObjectEnumerator()
					Repeat
						Local i:= enum.NextObject()
						tilegrid[i].willbedestroyed = True
					Until Not enum.HasNext()
				EndIf
			Next
		Next
	End Method
	
	Method UnmarkDestroyableTiles:Void()
		For Local i:Int = 0 Until rows * cols
			tilegrid[i].willbedestroyed = false
		Next
	End Method
End