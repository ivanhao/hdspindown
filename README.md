# hdspindown
>用来解决linux下通过hdparm -S 60这种方式硬盘无法自动休眠的问题。例如一些WD的硬盘，或pve下zfs硬盘。
## 用法：
单盘：
```
./hdspindown sda
```
多盘：
```
./spindownall 
```
计划任务：
```
*/5 * * * * /path/spindownall  #五分钟运行一次
```
