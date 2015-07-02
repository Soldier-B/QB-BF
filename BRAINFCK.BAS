DECLARE FUNCTION MOVE% (SRC$, IP%, SCOPE%, DIR%)

DIM IP%, MP%, DP%, SCOPE%, INLEN%
DIM MEM(1024) AS INTEGER
DIM SRC$, OUT$, IN$

MP% = 1: DP% = 1: SCOPE% = 1
OUT$ = ""

CLS

INPUT "Program Source: ", SRC$
INPUT "Program Input: ", IN$

INLEN% = LEN(IN$)

FOR IP% = 1 TO LEN(SRC$)
	SELECT CASE MID$(SRC$, IP%, 1)
		CASE "<": MP% = MP% - 1
		CASE ">": MP% = MP% + 1
		CASE "-": MEM(MP%) = (MEM(MP%) + 255) AND 255
		CASE "+": MEM(MP%) = (MEM(MP%) + 1) AND 255
		CASE ",": 
			IF DP% <= INLEN% THEN
				MEM(MP%) = ASC(MID$(IN$, DP%, 1))
				DP% = DP% + 1
			ELSE
				MEM(MP%) = 0
			END IF
		CASE ".": OUT$ = OUT$ + CHR$(MEM(MP%))
		CASE "[":
			IF MEM(MP%) = 0 THEN
				IP% = MOVE%(SRC$, IP%, SCOPE%, 1)
			ELSE
				SCOPE% = SCOPE% + 1
			END IF
		CASE "]":
			IF MEM(MP%) = 0 THEN
				SCOPE% = SCOPE% - 1
			ELSE
				IP% = MOVE%(SRC$, IP%, SCOPE%, -1)
			END IF
	END SELECT
NEXT IP%

PRINT OUT$

FUNCTION MOVE% (SRC$, IP%, SCOPE%, DIR%)
	DIM CURSCOPE%
   
	CURSCOPE% = SCOPE%
	SCOPE% = SCOPE% + DIR%
   
	WHILE SCOPE% <> CURSCOPE%
		IP% = IP% + DIR%
		SELECT CASE MID$(SRC$, IP%, 1)
			CASE "[": SCOPE% = SCOPE% + 1
			CASE "]": SCOPE% = SCOPE% - 1
		END SELECT
	WEND
   
	MOVE% = IP%
END FUNCTION