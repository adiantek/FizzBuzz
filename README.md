# FizzBuzz in boot sector

1. nasm -f bin fizzbuzz.asm -o fizzbuzz.bin
2. qemu-system-x86_64 -fda fizzbuzz.bin or put fizzbuzz.bin into the floppy disk image on https://copy.sh/v86/

![FizzBuzz](FizzBuzz.png)