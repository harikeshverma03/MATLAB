\ Model matlab
\ LP format - for model browsing. Use MPS format to capture full model detail.
Maximize
  2 C0 + C1 + 3 C2
Subject To
 R0: C0 + C1 <= 1
 R1: - C1 + 2 C2 <= 0.5
Bounds
 -100 <= C0 <= 0
 C1 <= 3
 C2 <= 1
End
