# cordova-plugin-mp3

## 安装

``` bash
cordova plugin add https://gitee.com/undsky/cordova-plugin-mp3.git
```

## 使用

### 录音

``` javascript
var path = (('ios' == cordova.platformId ? cordova.file.tempDirectory : cordova.file.externalCacheDirectory) + (('' + new Date()).getTime() + Math.random().toFixed(7) * 10000000) + '.mp3').replace(/^file:\/\//, '');

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
// 使用 https://github.com/apache/cordova-plugin-media
var media = new Media(path);
media.play();
```

## 参考

+ [lame](http://lame.sourceforge.net/)

### Android

+ [Recorder-Android](https://github.com/lijunzz/Recorder-Android)
+ ~~[TAndroidLame](https://github.com/naman14/TAndroidLame)~~

### iOS

+ [build-lame-for-iOS](https://github.com/Superbil/build-lame-for-iOS)
+ [iOS-Lame-Audio-transcoding](https://github.com/CivelXu/iOS-Lame-Audio-transcoding)
+ ~~[iOS-Record-Transcoding-mp3-lameDemo](https://github.com/AceDong0803/iOS-Record-Transcoding-mp3-lameDemo)~~