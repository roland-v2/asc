# asc
Arhitectura Sistemelor de Calcul

File Storage Manager in Assembly

This project implements a simple file storage manager in x86 Assembly.
It uses a fixed-size memory array (_0 file) and matrix (_1 file) to simulate a storage space where files (identified by IDs) can be added, retrieved, deleted, and reorganized (defragmented).

⸻

Features (array version _0)

The program supports the following operations:
	1.	Add file (operation = 1)
Reads the number of files to add.
For each file, reads:
File ID
File size (in bytes)
Finds a contiguous free space in memory (v) and stores the file ID across that range.
If placement succeeds, prints the file ID and allocated memory interval.
If no space is available, prints (0,0).
	2.	Get file (operation = 2)
Reads a file ID.
Scans memory for the file’s location.
Prints the starting index and length of the allocated space if found.
Prints (0,0) if not found.
	3.	Delete file (operation = 3)
Reads a file ID.
Frees all memory locations where that ID is stored (replaces them with 0).
Prints updated file ranges still present in memory.
	4.	Defragmentation (operation = 4)
Moves files towards the beginning of memory without changing their relative order.
Eliminates empty gaps between files.
Prints updated file ranges after compaction.
	5.	Exit
After all operations are executed, the program prints the full memory state (v array).

The same features are presented in the matrix _1 version, only the logic is a bit different.
