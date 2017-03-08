//
//  JJFLEXManager.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "JJFLEXManager.h"
#import "JJFLEXWindow.h"
#import "JJFLEXExplorerViewController.h"

@interface JJFLEXManager ()

//@property (strong, nonatomic) JJFLEXWindow *explorerWindow;
@property (nonatomic, strong) JJFLEXExplorerViewController *explorerViewController;

@end

@implementation JJFLEXManager

+ (instancetype)sharedManager {
    static JJFLEXManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (JJFLEXWindow *)explorerWindow {
    if (!_explorerWindow) {
        _explorerWindow = [[JJFLEXWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _explorerWindow.rootViewController = self.explorerViewController;
    }
    return _explorerWindow;
}

- (JJFLEXExplorerViewController *)explorerViewController
{
    if (!_explorerViewController) {
        _explorerViewController = [[JJFLEXExplorerViewController alloc] init];
    }
    return _explorerViewController;
}

- (void)showExplorer {
    self.explorerWindow.hidden = NO;
}

- (void)hideExplorer {
    self.explorerWindow.hidden = YES;
}

@end
