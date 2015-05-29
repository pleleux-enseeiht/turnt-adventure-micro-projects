# UART
Implementation of an Asynchrone Unit of Reception/Transmission.

## Launch
**minicom -s**

#### Configuration du port série:
```
A - Port série /dev/ttyS0
E-  Speed     C 9600 bauds
    Parity    M Even
    Data      V 8
    Stopbits  W 1

    9600 8E1
F - Contrôle de flux matériel : Non
```

#### Sortir de la configuration
You now have a mini-terminal. The characters are input with the keyboard via the serial link. You UART receive them one by one and transmit them to the other terminal via the serial link.

Everything you type must appear on the other terminal.

#### Quitter minicom
```
Crtl-A Z
Sortir et ràz  X
```
