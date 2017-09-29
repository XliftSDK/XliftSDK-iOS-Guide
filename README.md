# 目次

* [インフィード広告](#infeed)
    * [メディア設定](#infeed/setting)
    * [XliftSDKのインストール](#infeed/install)
    * [インフィード広告のロード](#infeed/load)
    * [インフィード広告の表示](#infeed/display)
    * [インフィード広告のクリック時の遷移処理](#infeed/click)

<a name="setting"></a>
## インフィード広告用のメディア設定
[X-lift管理画面](https://console.x-lift.jp/)でインフィード広告を掲載するアプリをメディア登録してください。

「ウィジェット設定（スロットの決定）」にて、「Advertising」のスロットを作成して下さい。  
スロット数が、1度の広告リクエストで取得する広告数となります。

<a name="infeed/install"></a>
## XliftSDKのインストール
### Cocoapodsからインストール
Podfileに下記を追加
```
pod 'XliftSDK'
```


<a name="infeed/load"></a>
## インフィード広告のロード

```objc
//(1) ヘッダーをインポート
#import <Xlift/XliftInfeedAd.h>
#import <Xlift/XliftInfeedAdLoader.h>
#import <Xlift/XliftInfeedAdDelegate.h>

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

// (5) インフィード広告ロードの完了。
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
  adView.siteTitle.text = [NSString stringWithFormat:@"PR: %@", ad.siteTitle];;
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
