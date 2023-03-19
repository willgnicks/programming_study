[docker容器引擎](https://www.notion.so/docker-de9c4725af7c4b43ac6f59b04a73ee16)

[Understand what BIO/NIO/AIO is](https://programs.team/understand-what-bio-nio-aio-is.html)

BIO/NIO/AIO讲例

# Java IO

## BIO 阻塞IO

> 主要使用socket和server sokect来实现tcp连接，是连接阻塞的，可以通过多线程来开通多连接，性能较低
> 

## NIO 非阻塞IO

> 主要使用socketChannel和serverSocketChannel来时实现非阻塞IO，对连接的事件进行监听轮询，从而提高性能
> 

## AIO 非阻塞异步IO

> 主要使用**AsynchronousSocketChannel和AsynchronousServerSocketChannel**
>