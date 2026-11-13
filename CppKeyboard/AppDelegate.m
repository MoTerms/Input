#import <UIKit/UIKit.h>

#pragma mark - 主界面：教学 + 跳转到系统键盘设置

@interface MainViewController : UIViewController
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[MainViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

#pragma mark - 主界面实现

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.10 green:0.12 blue:0.16 alpha:1.0];

    CGFloat w = self.view.bounds.size.width;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, w - 40, 44)];
    title.text = @"C++ 常用字符键盘";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, w - 40, 22)];
    sub.text = @"侧载版 · ESign 可用";
    sub.textColor = [UIColor colorWithWhite:0.65 alpha:1.0];
    sub.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:sub];

    UITextView *guide = [[UITextView alloc] initWithFrame:CGRectMake(20, 190, w - 40, 300)];
    guide.editable = NO;
    guide.backgroundColor = [UIColor clearColor];
    guide.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    guide.font = [UIFont systemFontOfSize:16];
    guide.text = @"使用方法：\n\n1. 点击下方按钮打开系统设置；\n\n2. 进入「通用 → 键盘 → 键盘 → 添加新键盘」，选择「C++字符键盘」；\n\n3. 在任意输入框中，长按键盘左下角 🌐 切换到本键盘；\n\n4. 键盘提供 { } ( ) < > ; : -> -> #include 等常用 C++ 字符与片段，点击即上屏。";
    [self.view addSubview:guide];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, self.view.bounds.size.height - 130, w - 40, 52);
    btn.layer.cornerRadius = 12;
    btn.backgroundColor = [UIColor colorWithRed:0.15 green:0.55 blue:0.95 alpha:1.0];
    btn.tintColor = UIColor.whiteColor;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btn setTitle:@"打开键盘设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)openSettings {
    NSURL *url = [NSURL URLWithString:@"App-Prefs:General&path=Keyboard/KEYBOARDS"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
