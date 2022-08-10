fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios yk_syncer
```
fastlane ios yk_syncer
```
同步开发者证书
### ios yk_analyze
```
fastlane ios yk_analyze
```
使用infer分析项目中的问题
### ios yk_component_release_src
```
fastlane ios yk_component_release_src
```
发布源码组件
### ios yk_component_release_static_lib
```
fastlane ios yk_component_release_static_lib
```
发布static lib组件
### ios yk_component_release_fmk
```
fastlane ios yk_component_release_fmk
```
发布Framework组件
### ios yk_app_build
```
fastlane ios yk_app_build
```
应用构建
### ios yk_app_publish
```
fastlane ios yk_app_publish
```
应用发布到内测ipapkserver或者TestFlight
### ios yk_testflight_publish
```
fastlane ios yk_testflight_publish
```
从TestFlight选择一个build，发布到appstore
### ios analyze
```
fastlane ios analyze
```
code analyze
### ios build_fmk
```
fastlane ios build_fmk
```
build dynamic framework
### ios build_lib
```
fastlane ios build_lib
```
build static library
### ios publish_src
```
fastlane ios publish_src
```
publish source
### ios publish_lib
```
fastlane ios publish_lib
```
publish static library
### ios publish_fmk
```
fastlane ios publish_fmk
```
publish fmk

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
