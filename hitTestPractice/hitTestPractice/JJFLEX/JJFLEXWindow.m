//
//  JJFLEXWindow.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "JJFLEXWindow.h"

@implementation JJFLEXWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 200;
    }
    return self;
}

@end
