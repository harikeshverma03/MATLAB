\ Model matlab
\ LP format - for model browsing. Use MPS format to capture full model detail.
Minimize
  150 C0 + 230 C1 + 260 C2 + 238 C3 + 210 C4 - 170 C5 - 150 C6 - 36 C7
   - 10 C8
Subject To
 R0: C0 + C1 + C2 <= 500
 R1: 2.5 C0 + C3 - C5 >= 200
 R2: 3 C1 + C4 - C6 >= 240
 R3: - 20 C2 + C7 + C8 <= 0
Bounds
 C0 <= 10000
 C1 <= 10000
 C2 <= 10000
 C3 <= 10000
 C4 <= 10000
 C5 <= 10000
 C6 <= 10000
 C7 <= 6000
 C8 <= 10000
End
