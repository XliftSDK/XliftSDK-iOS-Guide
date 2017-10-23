# インフィード広告実装例 Swift版
SwiftからXliftSDKを利用した、インフィード広告の実装例です。
## セットアップ
本プロジェクト直下にて下記コマンドを実行して下さい。
```
$ pod setup
$ pod install
$ open XliftSDKSwiftExampleInfeed.xcworkspace
```
## メディアID
mdediaIdは、管理画面でメディア登録を行った際に発行されたIDをお使い下さい。

```swift
let infeedAdLoader:XliftInfeedAdLoader = XliftInfeedAdLoader(mediaId:123456789, isTest:true)
```
