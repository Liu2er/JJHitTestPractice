//
//  JJFLEXManager.h
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJFLEXWindow.h"

@interface JJFLEXManager : NSObject
@property (strong, nonatomic) JJFLEXWindow *explorerWindow;

+ (instancetype)sharedManager;
- (void)showExplorer;
- (void)hideExplorer;

@end
