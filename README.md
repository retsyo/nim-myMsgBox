# What
a msgbox-like control for https://github.com/khchen/wNim with customizable font for message and buttons. In my case, I will use big and bold font.

# Todo. In the order of difficulty for me
1. icon
1.1 icons from local harddisk image files
1.2 icons from Windows's dll(for example, shell32.dll) to make the binary have a small size

2. solve the warning
```
myMsgBox.nim(286, 32) template/generic instantiation of `MyMsgBox` from here
myMsgBox.nim(247, 9) Warning: Cannot prove that 'result' is initialized. This will become a compile time error in the future. [ProveInit]
```

3. i18n

4. get rid off owner parameter

# Will not do
Change the 4-space to 2-space. Since 2-space is not too obvious for my eyes.

# Schedule
I don't make a living from coding, and current code almost meets my needs, so the update may be very slow or even none. Fork/modification are welcome.

# License
Just use it in any way you like. If possible, please write the code project link in the document, help or something else.
