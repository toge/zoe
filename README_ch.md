[![Build Status](https://travis-ci.com/winsoft666/zoe.svg?branch=master)](https://travis-ci.com/winsoft666/zoe) 
[![Vcpkg package](https://img.shields.io/badge/Vcpkg-package-blueviolet)](https://github.com/microsoft/vcpkg/tree/master/ports/zoe)
[![badge](https://img.shields.io/badge/license-GUN-blue)](https://github.com/winsoft666/zoe/blob/master/LICENSE)

简体中文 | [ English](README.md)

**该项目原名为teemo，由于被灰产非法使用，导致代码被加入安全软件特征库。作者将项目改为私有并修改了代码结构，现重新开源。**

# 一、介绍
目前虽然有很多成熟且功能强大的下载工具，如`Free Download Manager`, `Aria2`等等，但当我想找一个支持多种协议(如http， ftp)、多线程下载、断点续传、跨平台的开源库时，发现很难找到满意的，特别是使用C++开发的。于是我基于libcurl开发了这个名为`"zoe"`下载库，它可以支持如下特性：

✅ 多协议支持，由于是基于libcurl的，所以支持libcurl所支持的所有协议，如http, https, ftp等。

✅ 支持多线程下载

✅ 支持断点续传

✅ 支持暂停/继续下载

✅ 支持获取实时下载速率

✅ 支持下载限速

✅ 支持磁盘缓存

✅ 支持文件哈希校验

✅ 支持大文件下载

✅ 支持兼容服务器对客户端加速下载的限制

---

# 二、编译与安装

## 方式一、使用vcpkg（**暂时不可用**）
`zoe`库已经收录到微软的[vcpkg](https://github.com/microsoft/vcpkg/tree/master/ports/zoe)之中，可以使用如下命令快速安装:

- 1) 下载安装vcpkg（详见[https://github.com/microsoft/vcpkg](https://github.com/microsoft/vcpkg)
```bash
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
PS> bootstrap-vcpkg.bootstrap
Linux:~/$ ./bootstrap-vcpkg.sh
```

- 2) 安装zoe
```bash
PS> .\vcpkg install zoe [--triplet x64-windows-static/x64-windows/x64-windows-static-md and etc...]
Linux:~/$ ./vcpkg install zoe
```

## 方式二、使用源码编译
### 1. 安装依赖项
我倾向于使用[vcpkg](https://github.com/microsoft/vcpkg)来安装依赖项，当然，这不是安装依赖项的唯一方式，你可以使用任何方式来安装依赖项。

建议将vcpkg.exe所在目录添加到PATH环境变量。

- libcurl
    ```bash
    # 如果需要支持非http协议，如ftp等，需要指定[non-http]选项
    vcpkg install curl[non-http]:x86-windows
    ```

- gtest
单元测试项目使用了gtest。

    ```bash
    vcpkg install gtest:x86-windows
    ```


### 2. 编译
使用CMake生成相应的工程，然后编译即可。
**Windows示例**
```bash
cmake.exe -G "Visual Studio 15 2017" -DBUILD_SHARED_LIBS=ON -DBUILD_TESTS=ON -S %~dp0 -B %~dp0build
```

**Linux示例**
```bash
cmake -DBUILD_SHARED_LIBS=ON -DBUILD_TESTS=ON

# 如果使用vcpkg安装依赖库，需要指定CMAKE_TOOLCHAIN_FILE
cmake -DCMAKE_TOOLCHAIN_FILE=/xxx/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-linux -DBUILD_SHARED_LIBS=ON -DBUILD_TESTS=ON

make
```

---

# 三、快速开始
```cpp
#include <iostream>
#include "zoe.h"

int main(int argc, char** argv) {
  using namespace zoe;

  Zoe::GlobalInit();

  Zoe efd;

  efd.setThreadNum(10);                     // 可选的
  efd.setTmpFileExpiredTime(3600);          // 可选的
  efd.setDiskCacheSize(20 * (2 << 19));     // 可选的
  efd.setMaxDownloadSpeed(50 * (2 << 19));  // 可选的
  efd.setHashVerifyPolicy(ALWAYS, MD5, "6fe294c3ef4765468af4950d44c65525"); // 可选的, 支持 MD5, CRC32, SHA256
  // 还支持其他更多的选择，请查看zoe.h
  efd.setVerboseOutput([](const utf8string& verbose) { // 可选的
    printf("%s\n", verbose.c_str());
  });
  efd.setHttpHeaders({  // 可选的
    {u8"Origin", u8"http://xxx.xxx.com"},
    {u8"User-Agent", u8"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)"}
   });
  
  std::shared_future<Result> async_task = efd.start(
      u8"http://xxx.xxx.com/test.exe", u8"D:\\test.exe",
      [](Result result) {  // 可选的
        // 结果回调
      },
      [](int64_t total, int64_t downloaded) {  // 可选的
        // 进度回调
      },
      [](int64_t byte_per_secs) {  // 可选的
        // 实时速率回调
      });

  async_task.wait();

  Zoe::GlobalUnInit();

  return 0;
}
```

---

# 四、命令行工具
`zoe_tool`是一个基于`zoe`库开发的命令行下载工具，用法如下：

```bash
zoe_tool URL TargetFilePath [ThreadNum] [DiskCacheMb] [MD5] [TmpExpiredSeconds] [MaxSpeed]
```

参数解释：
- URL: 下载链接
- TargetFilePath: 下载的目标文件保存路径
- ThreadNum: 线程数量，可选，默认为1
- DiskCacheMb: 磁盘缓存大小，单位Mb，默认为20Mb
- MD5: 下载文件的MD5，可选，若不为空，则在下载完成之后会进行文件MD5校验
- TmpExpiredSeconds: 秒数，可选，临时文件经过多少秒之后过期
- MaxSpeed: 最高下载速度(byte/s)



---



# 五、捐赠

本项目暂不接受捐赠，感谢你的好意！

开源不易，如果这个项目帮助到了你，可以给项目点颗小星星⭐.
