# 🎨 Paint-ASM

A simple paint application written in x86 Assembly for DOS.  
It uses VGA graphics mode (13h) and mouse input via DOS interrupts to provide basic drawing functionality.

## 📁 Files Included

- `paint.asm` — The source assembly code.
- `painter.bmp`, `clear.bmp`, `back.bmp` — Bitmap files used by the program.

## ❓ How To Run

### 1. Install DOSBox

DOSBox is an emulator that runs DOS programs on modern systems.

- Download it from: [https://www.dosbox.com/](https://www.dosbox.com/)
- Install and open.

### 2. Prepare The Project Folder

If you want to build the program yourself from `paint.asm`, you need the following tools:

- **Turbo Assembler** (`TASM.EXE`)
- **Turbo Linker** (`TLINK.EXE`)
- **Runtime Manager** (`RTM.EXE`)
- **DPMI Support Overlay** (`DPMI16BI.OVL`)

These are legacy Borland tools from the early 90s. You can find them on archive / abandonware websites.

Then, simply create a folder and place the source files *and* tools inside it.

### 3. Build & Run

Mount your project folder in DOSBox:
```
MOUNT C C:\Path\To\Your\Folder
C:
```

Assemble and link the program:
```
TASM PAINT.ASM
TLINK PAINT.OBJ
```

Run:
```
PAINT.EXE
```

## 🙃 Enjoy!

Feel free to modify the source code or bitmaps.
