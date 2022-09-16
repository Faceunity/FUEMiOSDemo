# FUEMiOSDemo 快速接入文档

FUEMiOSDemo 是集成了 Faceunity 面部跟踪和虚拟道具功能 和 [EMiOSDemo](<https://www.easemob.com/download/rtc>) 音视频功能的 Demo。

本文是 FaceUnity SDK 快速对接环信EMiOSDemo 的导读说明，关于 `FaceUnity SDK` 的详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)

## 快速集成方法

### 一、导入 SDK

将  FaceUnity  文件夹全部拖入工程中，并且添加依赖库 `OpenGLES.framework`、`Accelerate.framework`、`CoreMedia.framework`、`AVFoundation.framework`、`libc++.tbd`、`CoreML.framework`

备注: Cocoapods 管理无需添加依赖库

### FaceUnity 模块简介
```C
-FUManager              //nama 业务类
-FUCamera               //视频采集类   
-authpack.h             //权限文件
+FUAPIDemoBar     //美颜工具条,可自定义
+items       //贴纸和美妆资源 xx.bundel文件
      
```


### 二、加入展示 FaceUnity SDK 美颜贴纸效果的  UI

1、在 `Call1v1VideoViewController.m`  中添加头文件，并创建页面属性

```C
/** faceU */
#import "FUManager.h"
#import "FUAPIDemoBar.h"


@property (nonatomic, strong) FUAPIDemoBar *demoBar;

```

2、初始化 UI，并遵循代理  FUAPIDemoBarDelegate ，实现代理方法 `demoBarDidSelectedItem:` 切换贴纸 和 `demoBarBeautyParamChanged` 更新美颜参数。

```C
/// 初始化 demoBar
- (FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 164 -250, self.view.frame.size.width, 164)];
        _demoBar.mDelegate = self;
    }
    return _demoBar ;
}

```

#### 切换贴纸

```C
// 切换贴纸
-(void)bottomDidChange:(int)index{
    if (index < 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeBeautify];
    }
    if (index == 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeStrick];
    }
    
    if (index == 4) {
        [[FUManager shareManager] setRenderType:FUDataTypeMakeup];
    }
    if (index == 5) {
        [[FUManager shareManager] setRenderType:FUDataTypebody];
    }
}

```

#### 更新美颜参数

```C
// 更新美颜参数    
- (void)filterValueChange:(FUBeautyParam *)param{
    [[FUManager shareManager] filterValueChange:param];
}
```

### 三、在 `viewDidLoad:` 初始化SDK,并将`demoBar`添加到页面上

```C
/**faceU */
[[FUManager shareManager] loadFilter];
[FUManager shareManager].isRender = YES;
[FUManager shareManager].flipx = YES;
[FUManager shareManager].trackFlipx = YES;
[[FUManager shareManager] setAsyncTrackFaceEnable:NO];
[self.view addSubview:self.demoBar];

```

### 四、图像处理

在  `DemoCallManager `类中设置自定义视频采集`options.enableCustomizeVideoData = YES`，获取视频数据，对图像进行处理，并发送给环信sdk：

```c
-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//    NSLog(@"自采集视频数据.....");
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
//    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    
    if (pixelBuffer != NULL) {
        CMTime cmTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        
      /* 视频处理 */
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        
        /* 自采集预览 */
        [_glView displayPixelBuffer:pixelBuffer];
        
        [EMClient.sharedClient.callManager inputVideoPixelBuffer:pixelBuffer sampleBufferTime:cmTime rotation:0 callId:self.currentCall.callId completion:^(EMError *aError) {
            //NSLog(@"发送完成");
        }];
    
    }
}
```

### 五、销毁道具

1 视图控制器生命周期结束时,销毁道具
```C
[[FUManager shareManager] destoryItems];
```

2 切换摄像头需要调用,切换摄像头
```C
[[FUManager shareManager] onCameraChange];
```

### 关于 FaceUnity SDK 的更多详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)