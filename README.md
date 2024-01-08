# RANC

RANC is a full featured environment for experimentation with neuromorphic architectures.这是一篇对RANC模拟器的复现工作，原项目参见 https://ua-rcl.github.io/RANC .复现的项目地址是：

## 实验环境：

windows10

## 文件组织结构：

1. /experiments里面是两个用于测试的项目文件，EEG是在RANC上运行使用MINST数据集的神经网络，VMM是在RANC上运行矩阵乘法。
2. /simulator里面是RANC模拟器的代码，底下有config.json文件，/build/Release里面有可执行的ranc_sim程序和input.json,output.json文件。
3. /software里面是运行测试项目时需要的一些函数。
4. /hardware是使用vivado模拟RANC架构时给出的一些源文件和脚本文件。

## 运行：

### 									RANC模拟器（software）

进入../simulator/build/Release/目录，执行

ranc_sim -h指令，可以看到参数提示：

![image-20231114234542446](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231114234542446.png)



进入../Release目录，模拟器运行指令：

ranc_sim -i path/to/your/input.json -o path/to/your/output.json  path/to/config.json -t number -r  report_frequency

这里用的都是绝对地址，因为实践发现相对地址有时会出错。并且注意所有选项都要按顺序来。这里的input.json和config.json,都是原项目中已经给出的，output.json的路径可以自己随意指定。

```
ranc_sim -i C:\Users\lhm\Desktop\system_structure\RANC\simulator\data\example\input.json -o  C:\Users\lhm\Desktop\system_structure\RANC\simulator\data\example\output.json  -c C:\Users\lhm\Desktop\system_structure\RANC\simulator\config.json  --ticks 4
```



![image-20231119164838413](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231119164838413.png)

得到的输出结果：

![image-20231119164953064](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231119164953064.png)





## RANC模拟器（hardware）:

(1)原项目指导书中首先有一个用TrueNorth实现的指导：

原项目的指导书中，提示引入这4个IP block再连线，(是rancnetwork)

![image-20240107224521921](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240107224521921.png)

就能实现下面的电路图：

![image-20240107224447489](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240107224447489.png)

这里显然就不适配，图中还是TrueNorth的IP模块，而原项目中给的IP文件是rancnetwork的，并且原项目中给出的rancnetwork模块和truenorth模块的接口也不一样：

![image-20240107224833960](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240107224833960.png)



发现原项目的IP文件里面除去这4个IP模块以外，还有一个StreamPacketBuffer模块！所以尝试DIY一下连线：

DIY失败，发现RANC这个模块根本匹配不了，还有之后的参数配置，也是差距太多，DIY不了。

![image-20240108000309587](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240108000309587.png)



(2)后来发现在/harware/projects中有一个streaming.tcl脚本文件，可以直接在vivado的Tools->Run Tcl Script中运行，运行后打开block design就能获得如下电路设计图，这就是RANC的初步架构图：

![image-20240108212119625](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240108212119625.png)

尝试运行Run Simulation,首先报错：

ERROR: [Runs 36-335] 'c:/Users/lhm/Desktop/system_structure/RANC/hardware/Projects/Streaming/src/blockdesign/streaming/ip/streaming_RANCNetwork_0_1/streaming_RANCNetwork_0_1.dcp' is not a valid design checkpoint

**第一次尝试解决**：.tcl文件中指定的Vivado版本是2018，我使用的是2019版本，所以对.tcl文件的这部分进行修改；

仍然报相同的错误。

找到IP Status中关于RANCNETWORK报这样的错误：      \* IP definition 'RANCNetwork (2.0)' for IP 'streaming_RANCNetwork_0_1'     (customized with software release 2018.2) was not found in the IP Catalog.     * IP 'streaming_RANCNetwork_0_1' contains one or more locked subcores.  

**第二次尝试解决**:在.bd文件中，找到RANCNETWORK的版本，修改成v1,因为/hardware/ip中给出的IP核是v1版本的：

![image-20240108220456816](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240108220456816.png)



仍然报错。

后来在IP Sources中我打开streaming_RANCNetwork_0_1的结构图发现，代码实现的是这样的：

![image-20240108221055907](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240108221055907.png)

但是由第一步的尝试我们看到给出的IP核结构是这样的：

![image-20240108221139631](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20240108221139631.png)

他们并不匹配，也就是说作者没有给出这里需要的版本2的RANCNetwork的IP核，因此无法往下生成。



## 尝试在RANC模拟器上运行使用MNIST数据集的神经网络

1.配环境

1)官网下载安装Annaconda

2)创建虚拟环境

```
conda create -n tensorflow python=3.7
```

3)下载安装7.4版本的cudunn和10版本的cuda，下图是官网指定的适配版本

![image-20231208130633765](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231208130633765.png)

4)安装tensorflow

```
pip install tensorflow-gpu==2.0.0b1
```

![image-20231208125715897](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231208125715897.png)

要跑通EEG的python代码，因为项目里面使用了tea learning的算法，因此作者提到必须安装tealayer1.0和tealayer2.0,但是tealayer2.0的setup.py中要求tensorflow-gpu版本必须为2.0.0b1,这个版本笔者在windows10环境中尝试了几个镜像源都没有找到，这个版本在ubuntu里面也无法安装。遂放弃。

5)另外，在尝试安装其他版本的tensorflow的时候，还发现，有些安装教程指出如果正确安装tensorflow,会显示相应的cudnn版本，但是笔者在安装过程就没有这条显示，发现不影响后续配合使用cudnn.



## 尝试在RANC模拟器上运行向量矩阵乘法VMM：

(1)进入/software/vmmmap文件夹：执行

```
pip install .
```

(2)进入/software/rancutils文件夹：执行

```
pip install .
```

(3)终端用管理员身份执行指令：

根据vmm.py文件中的click装饰器定义可知，这里有3种选项：

1)--use_single_mat  2)--use_batch_mat  3)--use_hardcoded 4)--use_random

分别对应用一台虚拟机执行.mat文件；用多台虚拟机执行.mat文件；使用源码中硬编码的虚拟机数据；

下面以--use_single_mat为例

```
python your/path/to/vmm.py --use_single_mat --mat_file your/path/to/VMM/testcase_UA.mat
```

报错系统拒绝访问。诡异的是已经使用了管理员权限，居然还报错拒绝访问。

![image-20231208141337990](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231208141337990.png)

虽然报的是创建子进程时系统拒绝访问的错误，让人以为是没拿到系统创建进程的权限，但最终找到是因为subprocess.Popen()的参数设置不对：第一个参数路径应该包括一个可执行文件，这里的可执行文件指的是ranc_sim。

subprocess.Popen()第一个参数：

![image-20231209010122076](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231209010122076.png)

这里bash_cmd的第一个参数是sim_path

![image-20231209005332775](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231209005332775.png)

修改--sim_path

![image-20231209005218496](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231209005218496.png)

给予子进程的命令也应该进行修改：把input,output,config的文件路径都改成绝对路径。笔者尝试过在同一个文件夹下使用相对路径，模拟器运行失败。另外，--r 1选项也可以删除，因为这个参数本来的默认值就是1，加上之后有时候还会导致程序运行失败。



(4)最后,在read_vmm_output函数中将output.txt文件以utf-8的格式打开，避免自动的gbk格式读取导致文件读取失败：

```python
def read_vmm_output(file_path):
    spikes = []
    with open(file_path,encoding='utf-8') as f:
        ...
```

测试运行结果：

![image-20231208231240295](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231208231240295.png)



##### 测试结果分析：

正确，并且和TrueNorth架构的结果是一样的。



## RANC模拟器架构分析

Ranc是一个以True North作为设计参考原型、基于FPGA实现的可配置的仿真环境。在写神经形态芯片综述的时候，我也恰巧了解到True North的基本架构。True North由4096个核心构成，每个核心分成内存、控制器、调度器、路由和神经元块五部分。RANC的核心基本也是如此架构的，只是增加了一个输出总线。(Fig.1)

![image-20231215233812067](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231215233812067.png)

在RANC中，神经元块的作用是计算神经元的电势。(Fig.2.)

每个核心有256个神经元。对于每个神经元，图片的最左边选择器的输入是4个突触权重，对应与上下左右四个相邻神经元之间的突触权重。遍历所有与当前神经元连接的、上面有脉冲的轴突，第一步，根据输入轴突是哪一个(Gi)来决定选择哪一个突触权重；第二步，将选出的突触权重和当前的电势相加；第三步，将当前电势再加上一个泄露指数(λj)；第四步，将当前电势与正阈值和负阈值进行比对。如果电势已经大于正阈值，神经元就发起一个脉冲并且将按照线性或绝对两种重置模式将电势置为（当前电势-正阈值）或者重置值；如果电势仍然低于负阈值，就只将电势按照线性或绝对两种重置模式置为（当前电势-负阈值）或者-重置值；如果前面两种情况均不满足，就维持当前的电势，以便下一个输入轴突做累加使用。

![image-20231216002824027](C:\Users\lhm\AppData\Roaming\Typora\typora-user-images\image-20231216002824027.png)



在RANC中，CSRAM的作用是存储核内所有256个神经元的信息。csram被分成了控制和存储两部分。控制部分决定从哪一个神经元上读取信息。作者指出这样可以将csram映射到FPGA更少的BRAM块上（约1/70），节约资源。

在RANC中，ROUTER的作用就是路由器，也可以说相当于是交通枢纽，是帮助脉冲信息包在核内部和核之间移动转发的。这里相对于True North做的优化是把FIFO 缓冲重新布局了，使得背压(back pressure)逻辑的实现更简单而且在高度拥塞时将吞吐量扩大到了2-3倍。

在RANC中，Scheduler的作用是接收路由路径中的脉冲包。当脉冲包到达目的核心时，会被传递给调度器。调度器包含一个256行、16列的SRAM，可以分别指示接受到的脉冲包来自哪一个轴突，以及tick是多少，调度器可以根据这个信息将脉冲事件放入队列中，以让核心按顺序执行脉冲事件。调度器还可以将这些信息发给控制器。RANC在这一部分相对于True North所做的优化是，当接收到的脉冲包tick等于当前的tick(也就是新的脉冲包想在当前时钟周期执行，而这显然是不可能的)，RANC会像True North一样将该脉冲包丢弃，但是并不会将错误信息传递给控制器，而是直接传递给用户，作者提出这样有利于设计者区分控制器出现的问题和这里出现的tick冲突问题。



在RANC中，Controller的作用就是维持其他4个主要组件间的交流，主要是根据Scheduler传递来的信息帮助神经元块决策如何计算电势以及是否发送脉冲。

在RANC中，输出总线的作用就是将每个时钟周期神经元的最终输出结果传递给用户。



## 模拟器源文件解读

main.cpp 设计命令行交互，并且从用户输入的input文件中拿到神经形态芯片的网格。

core.cpp 包括核心的构造函数（定义核心的五大模块，核心所在的二维坐标）、输出核心位置信息的函数、运行核心的函数、接收包的函数和更新当前字的函数。

neuronblock.cpp 计算神经元的输出电势和判断是否发起脉冲。

csramrow.cpp csramrow的构造函数，记录了每个神经元和其他神经元的连接情况、当前电势、重置值、泄露值、正阈值、负阈值、权重矩阵、目标轴突、目标tick、位置等参数

corecontroller.cpp 主要利用各路信息帮助神经元块判断如何计算电势以及是否发出脉冲。

packet.cpp 定义脉冲包移动的信息（dx,dy,tick,目标轴突）以及朝4个方向移动的函数。

router.cpp 定义了从核内、核外各个方向接收到脉冲包后如何转发的函数。

schedulersram.cpp 存储了每个时钟周期的轴突状态信息。



