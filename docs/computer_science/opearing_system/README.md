# Linux系统

> Linux，全称GNU/Linux，是一种免费使用和自由传播的[类UNIX](https://baike.baidu.com/item/%E7%B1%BBUNIX/9032872)操作系统，其内核由[林纳斯·本纳第克特·托瓦兹](https://baike.baidu.com/item/%E6%9E%97%E7%BA%B3%E6%96%AF%C2%B7%E6%9C%AC%E7%BA%B3%E7%AC%AC%E5%85%8B%E7%89%B9%C2%B7%E6%89%98%E7%93%A6%E5%85%B9/1034429)于1991年10月5日首次发布，它主要受到[Minix](https://baike.baidu.com/item/Minix/7106045)和Unix思想的启发，是一个基于[POSIX](https://baike.baidu.com/item/POSIX)的多用户、[多任务](https://baike.baidu.com/item/%E5%A4%9A%E4%BB%BB%E5%8A%A1/1011764)、支持[多线程](https://baike.baidu.com/item/%E5%A4%9A%E7%BA%BF%E7%A8%8B/1190404)和多[CPU](https://baike.baidu.com/item/CPU)的操作系统
> 

[系统架构](https://www.notion.so/944377d481904a9e8daa9a8eafb7b73c)

[常用指令](https://www.notion.so/483ad220ef504a54b9eb31c000aeb47d)

---

1. 修改系统hosts
    
    > vi /etc/hosts
    > 

```bash
119.28.13.121 [www.notion.so](http://www.notion.so/)
119.28.13.121 [msgstore.www.notion.so](http://msgstore.www.notion.so/)
```

1. 修改系统 dns
    
    > vi /etc/resolv.conf
    > 

```bash
nameserver 114.114.114.114
nameserver 119.29.29.29
```

[Linux系统 (1)](https://www.notion.so/Linux-1-b17e147525544c20b2a9254ae10be501)

[windows](https://www.notion.so/windows-f6386f6f777143028f905d45c61b81c7)

## 1. Github加速

- CDN地址更新网址
    
    [](https://hosts.gitcdn.top/hosts.txt)
    
- 重启命令
    
    ```bash
    Linux: /etc/init.d/network restart
    Windows: ipconfig /flushdns
    Macos: sudo killall -HUP mDNSResponder
    ```
    
- 一键命令
    
    ```bash
    sudo -i 
    # mac 
    sed -i "" "/# fetch-github-hosts begin/,/# fetch-github-hosts end/d" /etc/hosts && curl https://hosts.gitcdn.top/hosts.txt >> /etc/hosts
    # linux
    sed -i "/# fetch-github-hosts begin/,/# fetch-github-hosts end/d" /etc/hosts && curl https://hosts.gitcdn.top/hosts.txt >> /etc/hosts 
    ```