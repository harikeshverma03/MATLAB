\ Model matlab
\ LP format - for model browsing. Use MPS format to capture full model detail.
Maximize
  x + y + 2 z
Subject To
 R0: x + 2 y + 2 z <= 4
 R1: x + y + z >= 1
Bounds
 x <= 2
 1 <= y <= 2
 z <= 2
End
