# cordova-plugin-mp3

> record mp3

## 安装

``` bash
cordova plugin add https://gitee.com/undsky/cordova-plugin-mp3.git
```

## 使用

### 录音

``` javascript
// https://github.com/apache/cordova-plugin-file
var path = (('ios' == cordova.platformId ? cordova.file.tempDirectory : cordova.file.externalCacheDirectory) + ('' + new Date().getTime() + Math.random().toFixed(7) * 10000000) + '.mp3').replace(/^file:\/\//, '');

cordova.plugins.JLRecorder.start(path, function (path) {
    console.log(path);
}, function (error) {
    console.log(error);
});
```

### 停止

``` javascript
cordova.plugins.JLRecorder.stop();
```

### 销毁

``` javascript
cordova.plugins.JLRecorder.destroy();
```

### 播放

``` javascript
// https://github.com/apache/cordova-plugin-media
var media = new Media(path);
media.play();
```

## 依赖

+ [lame](http://lame.sourceforge.net/)
+ [Recorder-Android](https://github.com/lijunzz/Recorder-Android)
+ [build-lame-for-iOS](https://github.com/Superbil/build-lame-for-iOS)
+ [iOS-Lame-Audio-transcoding](https://github.com/CivelXu/iOS-Lame-Audio-transcoding)

## issues

### iOS

#### __weak typeof(self) wSelf = self报错：- A parameter list without types is only allowed in a function definition.

[https://www.jianshu.com/p/b8ce20d8b24d](https://www.jianshu.com/p/b8ce20d8b24d)

Xcode－> Build Settings-> C Language Dialect修改配置，C99改为GNU99，C99不包含typeof

## [查看更多项目](https://www.undsky.com)
