JUMPS
IDEAL
MODEL small
STACK 100h
; --------------------------
DATASEG
	FileName  db 'assets\painter.bmp', 0
	FileName2 db 'assets\clear.bmp', 0
	FileName3 db 'assets\back.bmp', 0
	FileHandle dw ?
	Header  db 54 dup (0)
	Palette db 256 * 4 dup (0)
	ScrLine  db 320 dup (0)
	X dw ?  ; Coordinate X.
	Y dw ?  ; Coordinate Y.
	Color db ?  ; The color will be set later.
	CounterX dw 320  ; Coordinate X's counter.
	CounterY dw 200  ; Coordinate Y's counter.
	Counter  dw ?  ; Will be used for loops.
	MyCursor db 11111111b, 11110001b
			 db 11111111b, 11100000b
             db 11111111b, 11100000b
             db 11111111b, 11100000b
             db 11111111b, 11100000b
             db 11111111b, 11100000b
             db 00000111b, 10000000b
             db 00000011b, 00000000b
			 db 00000011b, 00000000b
			 db 00000111b, 10000000b
			 db 00000111b, 10000000b
			 db 00001111b, 11000000b
			 db 00011111b, 11100000b
			 db 00011111b, 11110000b
			 db 00011111b, 11110000b
			 db 00011111b, 11110000b
			 db 00000000b, 00000000b
			 db 00000000b, 00001110b
			 db 00000000b, 00001110b
			 db 00000000b, 00001110b
			 db 00000000b, 00001110b
			 db 00000000b, 00001110b
			 db 00000000b, 00001110b
			 db 11111000b, 01111111b
			 db 11111000b, 01111111b                              
			 db 11110000b, 00111111b
			 db 11110000b, 00111111b
			 db 11100000b, 00011111b
			 db 11000000b, 00001111b
			 db 11000000b, 00000111b
			 db 11000000b, 00000111b
			 db 00000000b, 00000000b
; --------------------------
CODESEG
; Opens the first BMP file.
proc OpenFile
	mov ah, 3Dh
	xor al, al
	mov dx, offset FileName
	int 21h
	mov [FileHandle], ax
	ret
endp OpenFile
; --------------------------
; Opens the second BMP file.
proc OpenFile2
	mov ah, 3Dh
	xor al, al
	mov dx, offset FileName2
	int 21h
	mov [FileHandle], ax
	ret
endp OpenFile2
; --------------------------
; Opens the third BMP file.
proc OpenFile3
	mov ah, 3Dh
	xor al, al
	mov dx, offset FileName3
	int 21h
	mov [FileHandle], ax
	ret
endp OpenFile3
; --------------------------
; Reads BMP file header [54 bytes].
proc ReadHeader
	mov ah, 3Fh
	mov bx, [FileHandle]
	mov cx, 54
	mov dx, offset Header
	int 21h
	ret
endp ReadHeader
; --------------------------
; Reads BMP file's color palette --> 256 colors * 4 bytes (400h).
proc ReadPalette
	mov ah, 3Fh
	mov cx, 400h
	mov dx, offset Palette
	int 21h
	ret
endp ReadPalette
; --------------------------
; Copies the colors' palette to the video memory.
proc CopyPal
	mov si, offset Palette
	mov cx, 256
	mov dx, 3C8h  ; The number of the first color should be sent to port 3C8h.
	mov al, 0
	out dx, al  ; Copies starting color to port 3C8h.
	inc dx  ; Copies the palette to port 3C9h.
PalLoop:
	mov al, [si + 2] ; Gets red value.
	shr al, 2  ; Maximum is 255, but video palette's maximal value = 63. Therefore, dividing by 4.
	out dx, al ; Sends it.
	mov al, [si + 1] ; Gets green value.
	shr al, 2  ; Maximum is 255, but video palette's maximal value = 63. Therefore, dividing by 4.
	out dx, al ; Sends it.
	mov al, [si] ; Gets blue value.
	shr al, 2  ; Maximum is 255, but video palette's maximal value = 63. Therefore, dividing by 4.
	out dx, al ; Sends it.
	add si, 4  ; Points to the next color.
	loop PalLoop
	ret
endp CopyPal
; --------------------------
; BMP graphics are saved upside-down. 
; Therefore, displaying the lines from bottom to top.
proc CopyBitmap
	mov ax, 0A000h
	mov es, ax
	mov cx, 200
PrintBMPLoop:
	push cx
	; di = cx * 320, points to the correct screen line.
	mov di, cx
	shl cx, 6
	shl di, 8
	add di, cx
	; Reads one line.
	mov ah, 3Fh
	mov cx, 320
	mov dx, offset ScrLine
	int 21h
	cld ; Clears direction flag, for movsb.
	; Copies one line into video memory.
	mov cx, 320
	mov si, offset ScrLine
	rep movsb ; Copies line to the screen.
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitmap
; --------------------------
proc CopyBitmap2
    xor si, si
	xor di, di
	mov ax, 0A000h
	mov es, ax
	mov cx, 11
PrintBMPLoop2:
	push cx
	; di = cx * 320, points to the correct screen line.
	mov di, cx
	add di, 4
	shl cx, 6
	shl di, 8
	add di, 165
	add di, cx
	; Reads one line.
	mov ah, 3Fh
	mov cx, 32
	mov dx, offset ScrLine
	int 21h
	cld ; Clear direction flag, for movsb.
	; Copies one line into video memory.
	mov cx, 32
	mov si, offset ScrLine
	rep movsb ; Copies line to the screen.
	pop cx
	loop PrintBMPLoop2
	ret
endp CopyBitmap2
; --------------------------
proc CopyBitmap3
    xor si, si
	xor di, di
	mov ax, 0A000h
	mov es, ax
	mov cx, 11
PrintBMPLoop3:
	push cx
	; di = cx * 320, points to the correct screen line.
	mov di, cx
	add di, 4
	shl cx, 6
	shl di, 8
	add di, 202
	add di, cx
	; Reads one line.
	mov ah, 3Fh
	mov cx, 28
	mov dx, offset ScrLine
	int 21h
	cld ; Clear direction flag, for movsb.
	; Copies one line into video memory.
	mov cx, 28
	mov si, offset ScrLine
	rep movsb ; Copies line to the screen.
	pop cx
	loop PrintBMPLoop3
	ret
endp CopyBitmap3
; --------------------------
proc DrawFullLines
	mov [X], 0  ; X's starting point = Row 0.
	mov [CounterX], 320  ; 320 pixels at each line [Full Line].
LoopDFL:	
	; Prints a pixel at a given X & Y.
	mov bh, 0h   ; BH = 0.
	mov cx, [X]  ; CX = Coordinate X.
	mov dx, [Y]  ; DX = Coordinate Y.
	mov al, [Color]  ; AL = Color.
	; Interrupt 0Ch - Writes a pixel dot 
	; with a color at a specified coordinates.
	mov ah, 0Ch
	int 10h
	; Counts the lines.
    inc [X]
    dec [CounterX]
    cmp [CounterX], 0
    jne LoopDFL
	; Resets X.
	mov [X], 0
	mov [CounterX], 320
    ; Count the columns.
    inc [Y]
    dec [CounterY]
    cmp [CounterY], 0
	jne LoopDFL
	ret
endp DrawFullLines
; --------------------------
proc DrawColorSquares
	push [X]
LoopDCS:
	; Prints a pixel in a given X & Y.
	mov bh, 0h  ; BH = 0.
	mov cx, [X] ; CX = Coordinate X.
	mov dx, [Y] ; DX = Coordinate Y.
	mov al, [Color] ; AL = Color.
	; Interrupt 0Ch - Writes a pixel dot 
	; with a color at a specified coordinates.
	mov ah, 0Ch
	int 10h
	inc [X]
	dec [CounterX]
	cmp [CounterX], 0
    ja  LoopDCS
	sub [X], 11
	add [CounterX], 11
    inc [Y]
    dec [CounterY]
    cmp [CounterY], 0
	ja  LoopDCS
	pop [X]
	ret
endp DrawColorSquares
; --------------------------
start:  mov ax, @data
	    mov ds, ax
		push ds
        ; Graphic Mode: 13h.
	    mov ax, 13h
	    int 10h
OpeningScreen:
		; Resets Driver.
		mov ax, 0
		int 33h
		; Processes the first BMP file.
   	    call OpenFile
   	    call ReadHeader
	    call ReadPalette
		call CopyPal
	    call CopyBitmap
; --------------------------
		; Shows the cursor.
		mov ax, 01h
		int 33h
StartMouse: ; Gets mouse button status.
		mov ax, 03h
		int 33h
        cmp bx, 01h      ; If the clicked button is
		jne StartMouse   ; the left one, continues.
		cmp dx, 164
		jb  StartMouse
		cmp dx, 192
		ja  StartMouse
		; Checks if the user pressed the "PAINT" button.
		cmp cx, 352  ; 176 (PAINT's Starting X) * 2 = 352.
		jb  CheckExit
		cmp cx, 490  ; 245 (PAINT's Ending X) * 2 = 490.
		ja  CheckExit
		jmp Painter
CheckExit: ; Checks if the user pressed the "EXIT" button.
		cmp cx, 506  ; 253 (EXIT's Starting X) * 2 = 506.
		jb  StartMouse
		cmp cx, 624  ; 312 (EXIT's Ending X) * 2 = 624.
		ja  StartMouse
		mov [Color], 0     ; Color = Black.		
	    call DrawFullLines
		mov ax, 1Fh
		int 33h
		mov ax, 4c00h
		int 21h
Painter: ; Draws the painter.
		xor ax, ax  ; Resets the
		int 33h     ; mouse cursor.
		mov [Color], 0FFh  ; Color = White.		
	    call DrawFullLines	
	    mov [Y], 0         ; Y's Starting Point = Line 0.
	    mov [Color], 0     ; Color = Black.
	    mov [CounterY], 1  ; 1 line.
	    call DrawFullLines
	    mov [Y], 19        ; Y's Starting Point = Line 19.
	    mov [CounterY], 1  ; 1 line.
	    call DrawFullLines
		mov [Y], 1         ; Y's Starting Point = Line 1.
	    mov [Color], 7     ; Color = Light Gray.
	    mov [CounterY], 18 ; 18 lines.
		call DrawFullLines
; --------------------------
	    mov [X], 5         ; X's Starting Point = Line 5.
	    mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0     ; Color = Black.
	    call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 9Bh   ; Color = Gray.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0ECh   ; Color = Silver.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0FEh  ; Color = Pale Blue.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0FBh  ; Color = Yellow.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0FAh  ; Color = Green.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0B1h  ; Color = Aqua Green.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 2Ch   ; Color = Olive Green.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 1Fh   ; Color = Orange.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 9Fh   ; Color = Light Pink.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0C7h   ; Color = Pink.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0Fh   ; Color = Red.
		call DrawColorSquares
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 0FCh  ; Color = Blue.
		call DrawColorSquares		
		add [X], 16
		mov [Y], 4         ; Line = 4.
	    mov [CounterX], 11 ; 11 pixels each line.
	    mov [CounterY], 11 ; 11 lines.
		mov [Color], 8Ah   ; Color = Purple.
		call DrawColorSquares
; --------------------------
		; Processes the second BMP file.
   	    call OpenFile2
   	    call ReadHeader
	    call ReadPalette
		call CopyPal
	    call CopyBitmap2
; --------------------------
		; Processes the third BMP file.
   	    call OpenFile3
   	    call ReadHeader
	    call ReadPalette
		call CopyPal
	    call CopyBitmap3
; --------------------------
		mov cx, 299
		mov dx, 4
CurrColor1:
		mov al, 0
		mov ah, 0Ch
		mov bh, 0
		int 10h
		inc cx
		cmp cx, 315
		jb  CurrColor1
		mov cx, 299
		mov dx, 14
CurrColor2:
		int 10h
		inc cx
		cmp cx, 315
		jb  CurrColor2
		mov cx, 299
		mov dx, 4
CurrColor3:
		int 10h
		inc dx
		cmp dx, 15
		jb  CurrColor3
		mov cx, 314
		mov dx, 4
CurrColor4:
		int 10h
		inc dx
		cmp dx, 15
		jb  CurrColor4
		mov al, 0FFh
		mov cx, 300
		mov dx, 5
WHITE:  int 10h
		inc cx
		cmp cx, 314
		jb  WHITE
		mov cx, 300
		inc dx
		cmp dx, 14
		jb  WHITE
; --------------------------
		mov [Color], 0FFh ; Resets "Color".
PaintMouse: ; Shows the cursor.
		mov ax, 01h
		int 33h
		mov ax, @data
		mov es, ax
		mov ax, 09h
		mov bx, 05h
		mov cx, 0h
		mov dx, offset MyCursor
		int 33h
CheckLeft: ; Gets mouse button status.
		mov ax, 03h
		int 33h
        cmp bx, 01h  ; If the clicked button is
		jne PaintMouse    ; the left one, continues.
		; Hides the cursor.
		mov ax, 02h
		int 33h
		cmp dx, 5
		jb  Continue2
		cmp dx, 15
		ja  Continue2
		cmp cx, 458  ; 229 (CLEAR's Starting X) * 2 = 458.
		jb  Continue1
		cmp cx, 520  ; 260 (CLEAR's Ending X) * 2 = 520.
		ja  Continue1
		mov al, [Color]
		mov ah, 0Ch
		mov bh, 0h
		mov cx, 300
		mov dx, 5
BLACKCLR:
		int 10h
		inc cx
		cmp cx, 314
		jb  BLACKCLR
		mov cx, 300
		inc dx
		cmp dx, 14
		jb  BLACKCLR
		mov [Y], 20
		mov [CounterY], 180
		mov bl, [Color]
		push bx
		mov [Color], 0FFh
		call DrawFullLines
		pop bx
		mov [Color], bl
		xor bx, bx
		jmp CheckLeft
Continue1:
		cmp cx, 532 ; 266 (BACK's Starting X) * 2 = 532.
		jb  Continue2
		cmp cx, 586 ; 293 (BACK's Ending X) * 2 = 586.
		ja  CheckLeft
		jmp OpeningScreen
; --------------------------
Continue2:
		cmp dx, 5
		jb  CheckLeft
		cmp dx, 15
		ja  PrintDot
		cmp cx, 10 ; 5 (Black's Starting X) * 2 = 10.
		jb  CheckLeft
		cmp cx, 30 ; 15 (Black's Ending X) * 2 = 30.
		ja  GRAY
		mov [Color], 0
		jmp CurrColor
GRAY:   cmp cx, 42 ; 21 (Gray's Starting X) * 2 = 42.
		jb  CheckLeft
		cmp cx, 62 ; 31 (Gray's Ending X) * 2 = 62.
		ja  SILVER
		mov [Color], 9Bh
		jmp CurrColor
SILVER: cmp cx, 74 ; 37 (Silver's Starting X) * 2 = 74.
		jb  CheckLeft
		cmp cx, 94 ; 47 (Silver's Ending X) * 2 = 94.
		ja  PALE
		mov [Color], 0ECh
		jmp CurrColor
PALE:   cmp cx, 106 ; 53 (Pale's Starting X) * 2 = 106.
		jb  CheckLeft
		cmp cx, 126 ; 63 (Pale's Ending X) * 2 = 126.
		ja  YELLOW
		mov [Color], 0FEh
		jmp CurrColor
YELLOW: cmp cx, 138 ; 69 (Yellow's Starting X) * 2 = 138.
		jb  CheckLeft
		cmp cx, 158 ; 79 (Yellow's Ending X) * 2 = 158.
		ja  GREEN
		mov [Color], 0FBh
		jmp CurrColor
GREEN:  cmp cx, 170 ; 85 (Green's Starting X) * 2 = 170.
		jb  CheckLeft
		cmp cx, 190 ; 95 (Green's Ending X) * 2 = 190.
		ja  AQUA
		mov [Color], 0FAh
		jmp CurrColor
AQUA:   cmp cx, 202 ; 101 (Aqua's Starting X) * 2 = 202.
		jb  CheckLeft
		cmp cx, 222 ; 111 (Aqua's Ending X) * 2 = 222.
		ja  OLIVE
		mov [Color], 0B1h
		jmp CurrColor
OLIVE:  cmp cx, 234 ; 117 (Olive's Starting X) * 2 = 234.
		jb  CheckLeft
		cmp cx, 254 ; 127 (Olive's Ending X) * 2 = 254.
		ja  ORANGE
		mov [Color], 2Ch
		jmp CurrColor
ORANGE: cmp cx, 266 ; 133 (Orange's Starting X) * 2 = 266.
		jb  CheckLeft
		cmp cx, 286 ; 143 (Orange's Ending X) * 2 = 286.
		ja  LPINK
		mov [Color], 1Fh
		jmp CurrColor
LPINK:  cmp cx, 298 ; 149 (Light Pink's Starting X) * 2 = 298.
		jb  CheckLeft
		cmp cx, 318 ; 159 (Light Pink's Ending X) * 2 = 318.
		ja  PINK
		mov [Color], 9Fh
		jmp CurrColor
PINK:   cmp cx, 330 ; 165 (Pink's Starting X) * 2 = 330.
		jb  CheckLeft
		cmp cx, 350 ; 175 (Pink's Ending X) * 2 = 350.
		ja  RED
		mov [Color], 0C7h
		jmp CurrColor
RED:    cmp cx, 362 ; 181 (Red's Starting X) * 2 = 362.
		jb  CheckLeft
		cmp cx, 382 ; 191 (Red's Ending X) * 2 = 382.
		ja  BLUE
		mov [Color], 0Fh
		jmp CurrColor
BLUE:   cmp cx, 394 ; 197 (Blue's Starting X) * 2 = 394.
		jb  CheckLeft
		cmp cx, 414 ; 207 (Blue's Ending X) * 2 = 414.
		ja  PURPLE
		mov [Color], 0FCh
		jmp CurrColor
PURPLE: cmp cx, 426 ; 213 (Purple's Starting X) * 2 = 426.
		jb  CheckLeft
		cmp cx, 446 ; 223 (Purple's Ending X) * 2 = 446.
		ja  CheckLeft
		mov [Color], 8Ah
; --------------------------
CurrColor:
		mov al, [Color]
		mov ah, 0Ch
		mov bh, 0
		mov cx, 300
		mov dx, 5
CCOLOR: int 10h
		inc cx
		cmp cx, 314
		jb  CCOLOR
		mov cx, 300
		inc dx
		cmp dx, 14
		jb  CCOLOR
		jmp CheckLeft
; --------------------------
PrintDot: ; Gets mouse button status.
		mov ax, 03h
		int 33h
        cmp bx, 01h  ; If the clicked button is
		jne PaintMouse    ; the left one, continues.
		; Hides the cursor.
		mov ax, 02h
		int 33h
		; If DX (Y Coordinate) is above or equals 20, continues.
		cmp dx, 20
		jbe CheckLeft
		; Prints the pixel.
		mov bh, 0
		shr cx, 1  ; Adjusts cx to range 0-319, to fit screen.
		sub dx, 1  ; Moves one pixel, so the pixel will not be hidden by mouse.
		mov al, [Color]  ; Moves to AL the color found before.
		mov ah, 0Ch
		int 10h
		jmp PaintMouse
; --------------------------
exit:	mov ax, 4c00h
		int 21h
END start