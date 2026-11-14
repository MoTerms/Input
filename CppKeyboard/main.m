#import <UIKit/UIKit.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        // 用 NSClassFromString 获取 AppDelegate，避免 main.m 里未声明类导致的编译错误
        return UIApplicationMain(argc, argv, nil, NSClassFromString(@"AppDelegate"));
    }
}

