# and-operation
AND operation between two binary numbers.

# Running the application

### Requirements
Download [DOSBOX](https://www.dosbox.com/download.php?main=1) \
We are also going to need TASM, which i have added to this repository.

### How to run
1. Put .asm file and 2 .txt files with binary numbers into the TASM folder.
2. Open DOSBOX application
3. mount a virtual drive, for example, named `a` by typing the following `mount a *TASM folder location*`
4. type `a:` (name of the drive)
5. Assemble the .asm file into the object file by typing `tasm fileName.asm` \
 ![Now you will see the list of erros, warnings and etc.](/readMeImages/info1.png)
6. To get the .exe file type `tlink fileName.obj` (should be the same as .asm) \
 ![Ntlink](/readMeImages/info2.png)
7. Now you can launch the application by typing `fileName.exe *firstBinary.txt* *secondBinary.txt* *outputFileName.txt*`
8. Now you can see the result in the outputfile.


