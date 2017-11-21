# 目次

* [XliftSDKのインストール](#install)
* [インフィード広告](#infeed)
    * [メディア設定](#infeed/setting)
    * [インフィード広告のロード](#infeed/load)
    * [インフィード広告の表示](#infeed/display)
    * [インフィード広告のクリック時の遷移処理](#infeed/click)
    * [Swiftで実装](#infeed/swift)
* [レコメンド・ウィジェット](#widget)
    * [記事データのクローリング](#widget/crawling)
    * [レコメンド・ウィジェットの配置](#widget/arrangement)
    * [レコメンド・ウィジェットの実装例](#widget/implementation)
    * [Swiftで実装](#widget/swift)


<a name="install"></a>
# XliftSDKのインストール
## Cocoapodsからインストール
Podfileに下記を追加
```
target ...
  pod 'XliftSDK', '= 2.0.1'
```
インストール実行
```
$ pod setup
$ pod install
```

<a name="infeed"></a>
# インフィード広告
<a name="infeed/setting"></a>
## インフィード広告用のメディア設定
[X-lift管理画面](https://console.x-lift.jp/)でインフィード広告を掲載するアプリをメディア登録してください。

「ウィジェット設定（スロットの決定）」にて、「Advertising」、または「自社枠」のスロットを作成して下さい。
スロット数が、一度の広告リクエストで取得する広告数となります。

<a name="infeed/load"></a>
## インフィード広告のロード

```objc
//(1) ヘッダーをインポート
#import <Xlift/XliftInfeedAd.h>
#import <Xlift/XliftInfeedAdLoader.h>
#import <Xlift/XliftInfeedAdLoaderDelegate.h>

@interface SampleViewController()<XliftInfeedAdLoaderDelegate>
//(2) プロパティを定義
@property(nonatomic) XliftInfeedAdLoader *infeedAdLoader;
@end

@implementation SampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // (3) XliftInfeedAdLoaderを生成。initWithMediaIdにメディアIDを指定。
    self.infeedAdLoader = [[XliftInfeedAdLoader alloc] initWithMediaId:xxx];

    // ※ テスト時は、initWithMediaId:isTestでisTestにYESを指定
    // self.infeedAdLoader = [[XliftInfeedAdLoader alloc] initWithMediaId: isTest:YES];

    // (4) delegateを設定
    self.infeedAdLoader.delegate = self;

    // (5) インフィード広告をロード
    [self.infeedAdLoader loadInfeedAd];
}

// (6) インフィード広告ロードの完了。
- (void)XliftInfeedAdLoader:(XliftInfeedAdLoader *)infeedAdLoader didLoadInfeedAds:(NSArray<XliftInfeedAd *> *)infeedAds
{
    self.infeedAds = infeedAds;
}

// (7) インフィード広告ロードの失敗。
- (void)XliftInfeedAdLoader:(XliftInfeedAdLoader *)infeedAdLoader didFailLoadInfeedAdWithError:(NSError *)error
{
    NSLog(@"ad load error");
}
```

<a name="infeed/display"></a>
## インフィード広告の表示
`XliftInfeedAd`の情報をもとに、広告を表示させます。
表示内容が広告であることをユーザーが認識できる文言を必ず記述して下さい。

```objc
  adView.titleLabel.text = infeedAd.title;
  adView.siteTitle.text = [NSString stringWithFormat:@"PR: %@", ad.siteTitle];
  infeedAd.loadImageWithCompleteHandler:^(UIImage *image, NSError *error) {
    if (error == nil) {
        adView.imageView.image = image;
    } else {
        NSLog(@"ad image load error");
    }
  }];

```

<a name="infeed/click"></a>
## インフィード広告のクリック時の遷移処理
広告がクリックされたら、以下のメソッドを呼び出し、ユーザーを遷移させてください。
```objc
[infeedAd openWithCompleteHandler:^(BOOL success){
    if (!success) {
        NSLog(@"ad click error");
    }
}];

```

<a name="infeed/swift"></a>
## Swiftでの実装
ブリッジヘッダファイルが必要です。
[サンプルプロジェクト](https://github.com/XliftSDK/XliftSDK-iOS-Guide/tree/master/Example/XliftSDKSwiftExampleInfeed)の [XliftSDK-Bridge-Header.h](https://github.com/XliftSDK/XliftSDK-iOS-Guide/blob/master/SwiftExample/XliftSDKSwiftExampleInfeed/XliftSDKSwiftExampleInfeed/XliftSDK-Bridge-Header.h)を参考にして下さい。

<a name="widget"></a>
# レコメンド・ウィジェット
|XliftWidgetViewHorizontal|XliftWidgetViewVertical|
|:-:|:-:|
|<img src="https://user-images.githubusercontent.com/32383368/33060902-50bf85a2-cedd-11e7-84f1-dcd375a4612a.png" width="320" title="レコメンド・ウィジェット" alt="レコメンド・ウィジェット" />|<img src="https://user-images.githubusercontent.com/32383368/34375425-dcbb47f4-eb29-11e7-9d87-c7be148de533.png" width="320" title="レコメンド・ウィジェット" alt="レコメンド・ウィジェット" />|
<a name="widget/crwaling"></a>
## 記事データのクローリング
アプリ内の各記事に対応するWebページが存在し、  
X-liftシステムによりクローリングを行えることを前提とします。  
X-liftサーバへのリクエスト、および取得されるレスポンスデータにおいて、  
記事データを識別するためにWebページのURLを使用します。

<a name="widget/arrangement"></a>
## レコメンド・ウィジェットの配置
<br />
Storyboard等でUIViewを配置し、Custom ClassにXliftWidgetViewを継承したクラス（XliftWidgetViewHorizontal、XliftWidgetViewVertical、もしくはカスタムWidgetView）を指定する。
<img src="https://user-images.githubusercontent.com/32383368/34373832-e5f1dbb6-eb20-11e7-94d9-fb8eb4c5dc1e.png" width="640" title="Storyborad1" alt="Storyboard1" />
<br />
<br />
配置したXliftWidgetViewをコードと紐付ける
<img src="https://user-images.githubusercontent.com/32383368/34373530-ec55bcb8-eb1e-11e7-9ed2-aa557de2a4ff.png" width="640" title="Storyborad2" alt="Storyboard2" />
<br />
<br />
XliftWidgetViewのheightに対するConstraintをコードと紐付ける
<img src="https://user-images.githubusercontent.com/32383368/34373637-bf93ece4-eb1f-11e7-815e-9c3b077e8d3d.png" width="640" title="Storyborad3" alt="Storyboard3" />
<br />
Attribute Inspectorで「Media Id(メディアID)」と「Is Test（テストフラグ）」を設定。
「Header Font Size」「Header Text Color」「Header Bacground Color」「Partition Color」を任意で設定。
コード上で設定することも可能。<img src="https://user-images.githubusercontent.com/32383368/34374984-87767036-eb27-11e7-8612-583003e787c1.png" width="640" title="Storyborad4" alt="Storyboard4" />

<a name="widget/implementation"></a>
## レコメンド・ウィジェットの実装例(Objective-C)
```objc
#import "SampleViewController.h"
#import "XliftWidgetView.h"
#import "XliftWidgetViewDelegate.h"
#import "XliftWidgetRecommend.h"

// XliftWidgetViewDelegateプロトコルを実装する
@interface SampleViewController() <XliftWidgetViewDelegate>
// XliftWidgetViewをプロパティとして定義
@property (weak, nonatomic) IBOutlet XliftWidgetView *widgetView;
@end

@implementation SampleViewController
- (void)viewDidLoad {
    // URLをもとにコンテンツを生成
    ...

    // delegateを設定
    self.widgetView.delegate = self;
    // Widgetデータをロード。表示しようとする画面に対応するURLをパラメータで付与する。
    [self.widgetView loadWithURL:[NSURL URLWithString:self.url]];
}

// Widgetがクリックされた時に呼び出される
- (BOOL)XliftWidgetView:(XliftWidgetView *)XliftWidgetView didSelectItem:(XliftWidgetItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    if (item.itemType == XliftWidgetItemTypeAd) {
        // 遷移をSDKへ任せる（ブラウザで開く）場合はtrueを返す
        return true;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sample"];
        viewController.url = item.linkURL;
        [self.navigationController pushViewController:viewController animated:YES];
        // 遷移をアプリ自身で行う場合はfalseを返す
        return false;
    }
}

// Widget用のViewに高さを設定
- (void)XliftWidgetView:(XliftWidgetView *)XliftWidgetView recommendHeight:(CGFloat)height
{
    self.XliftWidgetViewHeightConstraint.constant = height;
}
```

<a name="widget/swift"></a>
## Swiftでの実装
ブリッジヘッダファイルが必要です。
[サンプルプロジェクト](https://github.com/XliftSDK/XliftSDK-iOS-Guide/tree/master/Example/XliftSDKSwiftExampleWidget)の [XliftSDK-Bridge-Header.h](https://github.com/XliftSDK/XliftSDK-iOS-Guide/blob/master/Example/XliftSDKSwiftExampleWidget/XliftSDKSwiftExampleWidget/XliftSDK-Bridge-Header.h)を参考にして下さい。
