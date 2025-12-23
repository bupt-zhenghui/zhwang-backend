---
draft: false
date: 2025-11-30
tags: [java,并发,多线程]
categories: [java]
---

# Java并发



## 一、线程与进程

##### Q1:什么是进程？什么是线程？

**进程**是程序的一次执行过程，是系统运行程序的基本单位，因此进程是动态的。系统运行一个程序即是一个进程从创建，运行到消亡的过程。

在 Java 中，当我们启动 main 函数时其实就是启动了一个 JVM 的进程，而 main 函数所在的线程就是这个进程中的一个线程，也称主线程。

<!-- more -->

**线程**与进程相似，但线程是一个比进程更小的执行单位。一个进程在其执行的过程中可以产生多个线程。与进程不同的是同类的多个线程共享进程的**堆**和**方法区**资源，但每个线程有自己的**程序计数器**、**虚拟机栈**和**本地方法栈**，所以系统在产生一个线程，或是在各个线程之间做切换工作时，负担要比进程小得多，也正因为如此，线程也被称为轻量级进程。



##### Q2:Java线程与操作系统的线程的区别？

JDK 1.2 之前，Java 线程是基于绿色线程（Green Threads）实现的，这是一种用户级线程（用户线程），也就是说 JVM 自己模拟了多线程的运行，而不依赖于操作系统。由于绿色线程和原生线程比起来在使用时有一些限制（比如绿色线程不能直接使用操作系统提供的功能如异步 I/O、只能在一个内核线程上运行无法利用多核），在 JDK 1.2 及以后，Java 线程改为基于原生线程（Native Threads）实现，也就是说 JVM 直接使用操作系统原生的内核级线程（内核线程）来实现 Java 线程，由操作系统内核进行线程的调度和管理。



- 用户线程：由用户空间程序管理和调度的线程，运行在用户空间（专门给应用程序使用）。
- 内核线程：由操作系统内核管理和调度的线程，运行在内核空间（只有内核程序可以访问）。

顺便简单总结一下用户线程和内核线程的区别和特点：用户线程创建和切换成本低，但不可以利用多核。内核态线程，创建和切换成本高，可以利用多核。

 在Windows 和 Linux 等主流操作系统中，Java 线程采用的是一对一的线程模型，也就是一个 Java 线程对应一个系统内核线程。

一句话概括 Java 线程和操作系统线程的关系：**现在的 Java 线程的本质其实就是操作系统的线程**。



##### Q3:线程与进程的主要区别？

<img src="https://img-1300769438.cos.ap-beijing.myqcloud.com/images/java-runtime-data-areas-jdk1.8.png" alt="Java 运行时数据区域（JDK1.8 之后）" style="zoom:80%;" />

一个进程中可以有多个线程，多个线程共享进程的堆和方法区 (JDK1.8 之后的元空间)资源，但是每个线程有自己的程序计数器、虚拟机栈 和 本地方法栈。

分维度对比：

| 特性         | 进程         | 线程               |
| ------------ | ------------ | ------------------ |
| 资源分配单位 | 基本单位     | 无（共享进程资源） |
| 调度执行单位 | 非基本单位   | 基本单位           |
| 资源独立性   | 强（隔离）   | 弱（共享）         |
| 切换开销     | 大           | 小                 |
| 通信复杂度   | 高（需 IPC） | 低（共享内存）     |
| 崩溃影响     | 仅自身       | 影响整个进程       |

- 资源分配上：进程是系统资源分配的最小单位，每个进程拥有独立地址空间，进程间资源相互隔离；线程是CPU调度执行的最小单位，线程隶属于进程，共享所属进程的资源，仅拥有独立的栈空间和程序计数器
- 独立性上：进程独立性强，进程崩溃不会影响其他进程；线程独立性弱，同一进程内的堪称共享资源，一个线程崩溃可能导致整个进程终止
- 调度开销：进程调度开销大，进程的调度和切换涉及完整的上下文，涉及到操作系统层面的复杂操作；线程调度开销小，仅涉及线程的私有数据（栈空间和程序计数器），效率高
- 通信方式：进程通信需借助IPC（进程间通信）机制；线程通信简单，可直接读写共享内存

总结：进程是 “资源容器”，线程是 “执行流”；进程侧重资源隔离，线程侧重高效调度。多进程适用于资源隔离要求高的场景（如独立服务），多线程适用于并发任务且需共享资源的场景（如 Web 服务器处理请求）。



##### Q4:如何创建线程？

严格说在java中只有一种创建线程的方式，即通过`new Thread().start()`创建

具体在代码实现层面，可以通过：

- 继承`Thread`类
- 实现`Runnable`接口
- 实现`Callable`接口
- 使用线程池
- 使用`CompletableFuture`等



!!! question "可以直接调用Thread类的run()吗？"

    调用starat()方法可以启动线程并使线程进入就绪状态，并自动调用run()方法；直接执行run()方法不会以多线程方式执行





##### Q5:线程的生命周期和状态

线程的整个生命周期中存在一下6种状态：

- NEW：初始状态，线程被创建但没有调用`start()`
- RUNNABLE：运行状态，线程被调用`start()`方法进入运行态
- BLOCKED：阻塞状态，需要等待锁释放
- WAITING：等待状态，表示该线程需要等待其他线程做出一些特定动作（通知或中断）
- TIME_WAITING：超时等待状态，可以在指定的时间后自行返回而不是像WAITING一样一直等待
- TERMINATED：终止状态，表示线程已经运行完毕

![Java 线程状态变迁图](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/640.png)

##### Q6:什么是线程上下文切换？

线程在执行过程中会有自己的运行条件和状态（也称上下文），比如上文提及的线程独有的程序计数器，本地方法栈。当出现以下情况时，线程会从占用CPU状态中退出：

- 主动让出CPU，比如调用了`sleep()`，`wait()`等
- 时间片用完，因为操作系统要防止一个线程或进程长时间占用CPU导致其他线程或进程饿死
- 调用了阻塞类型的系统中断，比如请求IO，线程被阻塞
- 被终止或结束运行

其中前三种都会发生线程切换，线程切换意味着要保存当前线程的上下文，待下次进入运行态时恢复，并加载下一个将要占用CPU的线程上下文



##### Q7:Thread#sleep()与Object#wait()方法对比

共同点：都可以暂停线程的执行

区别：

| 对比维度           | Thread.sleep(long millis)                                   | Object.wait(long timeout)/wait()                             |
| ------------------ | ----------------------------------------------------------- | ------------------------------------------------------------ |
| **所属类**         | `java.lang.Thread` 类的**静态方法**                         | `java.lang.Object` 类的**实例方法**（所有对象可调用）        |
| **核心目的**       | 让当前线程暂停执行指定时间，属于 “主动休眠”                 | 让当前线程释放锁并进入等待状态，属于 “条件等待”              |
| **锁持有行为**     | **不释放任何锁**（持有的对象锁 / 类锁仍保留）               | **必须释放调用对象的监视器锁（monitor）**                    |
| **调用前提**       | 无强制要求（可在任意位置调用）                              | **必须在同步代码块 / 方法中调用**（否则抛 `IllegalMonitorStateException`） |
| **唤醒机制**       | 1. 超时自动唤醒；2. 线程被中断（抛 `InterruptedException`） | 1. 其他线程调用 `object.notify()`/`notifyAll()`；2. 超时自动唤醒；3. 线程被中断（抛 `InterruptedException`） |
| **线程状态**       | 休眠状态（`TIMED_WAITING`）                                 | 等待状态（`WAITING`/`TIMED_WAITING`）                        |
| **是否可指定时间** | 必须指定（`sleep(0)` 表示暂时让出 CPU，立即就绪）           | 可指定超时时间，也可无参（永久等待，直到被唤醒）             |
| **中断处理**       | 抛 `InterruptedException`，但不清除中断标记                 | 抛 `InterruptedException`，且**清除中断标记**（JDK 规范）    |



## 二、多线程

!!! question "并发与并行的区别？"

    并发：两个及两个以上的作业在同一 **时间段** 内执行<br>
    并行：两个及两个以上的作业在同一 **时刻** 执行



!!! question "同步和异步的区别"

    同步：发出一个调用后，在没有得到结果之前，一直等待<br>
    异步：发出一个调用后，不用等待返回结果，直接执行后续命令



##### Q1:为什么要多线程？

**从计算机底层来说：** 线程可以比作是轻量级的进程，是程序执行的最小单位，线程间的切换和调度的成本远远小于进程。另外，多核 CPU 时代意味着多个线程可以同时运行，这减少了线程上下文切换的开销。

**从当代互联网发展趋势来说：** 现在的系统动不动就要求百万级甚至千万级的并发量，而多线程并发编程正是开发高并发系统的基础，利用好多线程机制可以大大提高系统整体的并发能力以及性能。



##### Q2:单核CPU支持Java多线程吗？

支持。操作系统通过时间片轮转的方式，将CPU的时间分配给不同的线程，尽管单核CPU在同一时间只能执行一个任务，但通过快速在多个线程之间切换，可以让用户感觉多个任务在同时执行

!!! tip "操作系统层面的线程调度策略"

    **抢占式调度（Preemptive Scheduling）**：操作系统决定何时暂停当前正在运行的线程，并切换到另一个线程执行，这种切换通常由系统时钟中断（时间片轮转）或其他高优先级事件（如I/O操作完成）触发。这种方式存在上下文切换开销，但公平性和CPU资源利用率较好，不易阻塞<br>
    **协同式调度（Cooperative Scheduling）**：线程执行完毕后，主动通知系统切换到另一个线程。这种方式可以减少上下文切换带来的性能开销，但公平性较差，容易阻塞。

Java使用抢占式调度策略，并将线程调度委托给操作系统，操作系统通常会基于线程优先级和时间片来调度线程的执行。



##### Q3:单核CPU多线程运行效率一定会高吗？

取决于线程的类型和任务性质

- **CPU密集型**：CPU密集型的线程主要进行计算和逻辑处理，需要占用大量的CPU资源
- **IO密集型**：IO密集型的线程主要进行输入输出操作，如读写文件、网络通信等，需要等待IO设备的响应，不占用太多的CPU资源

如果是CPU密集型的线程，那么多个线程同时运行会导致频繁的线程切换，增加了系统的开销，降低了效率；如果是IO密集型的线程，那么多个线程同时运行可以利用CPU在等待IO时的空闲时间，提高效率



##### Q4:多线程的潜在问题

并发编程的目的就是为了能提高程序的执行效率进而提高程序的运行速度，但是并发编程并不总是能提高程序运行速度的，而且并发编程可能会遇到很多问题，比如：内存泄漏、死锁、线程不安全等等。

!!! question "什么是线程安全？"

    线程安全：在多线程环境下，对同一份数据，不管有多少线程同时访问，都能保证这份数据的正确性和一致性<br>
    线程不安全：在多线程环境下，对同一份数据，多个线程同时访问可能会导致数据混乱、错误或丢失



##### Q5:死锁Deadlock

死锁指的是多个线程同时被阻塞，他们中的一个或全部都在等待某个资源的释放。由于线程被无限期地阻塞，程序无法正常终止

![线程死锁示意图 ](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/2019-4%25E6%25AD%25BB%25E9%2594%25811.png)

!!! tip "死锁的四个必要条件"

    **互斥条件**：资源具有排他性，任意时刻只由一个线程占用<br>
    **请求与保持条件**：线程已经持有至少一个资源，又提出了新的资源请求，在新资源被其他线程占用时，该线程不会释放已持有的资源<br>
    **不可剥夺条件**：线程所持有的资源，只能通过主动释放，无法被其他进程强制剥夺<br>
    **循环等待条件**：存在一个线程-资源的循环等待链，链中的每个线程都持有下一个线程所需的资源




java中线程死锁示例（出自《并发编程之美》）

```java
public class DeadLockTest {
    private static Object resource1 = new Object();//资源 1
    private static Object resource2 = new Object();//资源 2

    public static void main(String[] args) {
        new Thread(() -> {
            synchronized (resource1) {
                System.out.println(Thread.currentThread() + "get resource1");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread() + "waiting get resource2");
                synchronized (resource2) {
                    System.out.println(Thread.currentThread() + "get resource2");
                }
            }
        }, "线程 1").start();

        new Thread(() -> {
            synchronized (resource2) {
                System.out.println(Thread.currentThread() + "get resource2");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread() + "waiting get resource1");
                synchronized (resource1) {
                    System.out.println(Thread.currentThread() + "get resource1");
                }
            }
        }, "线程 2").start();
    }
}
```



java中死锁的检测手段

- 使用`jmap`、`jstack`等命令查看JVM线程栈和堆内存的情况；启动死锁进程后，通过`jstack <pid>`、`jcmd <pid> Thread.print`检查进程堆栈

  ```shell
  Found one Java-level deadlock:
  =============================
  "线程 1":
    waiting to lock monitor 0x0000000c52cad960 (object 0x0000000697a816d8, a java.lang.Object),
    which is held by "线程 2"
  
  "线程 2":
    waiting to lock monitor 0x0000000c52cada40 (object 0x0000000697a816c8, a java.lang.Object),
    which is held by "线程 1"
  
  Java stack information for the threads listed above:
  ===================================================
  "线程 1":
          at site.zhwang.demo.DeadLockTest.lambda$main$0(DeadLockTest.java:18)
          - waiting to lock <0x0000000697a816d8> (a java.lang.Object)
          - locked <0x0000000697a816c8> (a java.lang.Object)
          at site.zhwang.demo.DeadLockTest$$Lambda$14/0x0000009001001208.run(Unknown Source)
          at java.lang.Thread.run(java.base@17.0.17/Thread.java:840)
  "线程 2":
          at site.zhwang.demo.DeadLockTest.lambda$main$1(DeadLockTest.java:33)
          - waiting to lock <0x0000000697a816c8> (a java.lang.Object)
          - locked <0x0000000697a816d8> (a java.lang.Object)
          at site.zhwang.demo.DeadLockTest$$Lambda$15/0x0000009001001428.run(Unknown Source)
          at java.lang.Thread.run(java.base@17.0.17/Thread.java:840)
  
  Found 1 deadlock.
  ```

- 使用`jconsole`工具检查；在JDK的bin目录下找到`jconsole`并打开，选择对应java进程

![image-20251207152603514](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20251207152603514.png)



!!! question "如何预防死锁（破坏死锁必要条件）"

    互斥条件：通常无法破坏，多数场景某个线程就是需要独占某个资源<br>
    破坏请求与保持条件：一次性申请所有资源<br>
    破坏不剥夺条件：占用部分资源的线程进一步申请其他资源时，如果申请不到，可以主动释放<br>
    破坏循环等待条件：统一资源（锁）的获取顺序，对锁对象按哈希值、自定义ID等排序，无论线程执行逻辑如何，都先获取编号小的锁，再获取编号大的锁



!!! question "如何避免死锁"

    在资源分配时，借助于算法（比如银行家算法）对资源分配进行计算评估，使其进入安全状态







