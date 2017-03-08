//
//  JJFLEXToolbarItem.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "JJFLEXToolbarItem.h"

@interface JJFLEXToolbarItem ()

@end

@implementation JJFLEXToolbarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[self class] defaultBackgroundColor];
        [self setTitleColor:[[self class] defaultTitleColor] forState:UIControlStateNormal];
        [self setTitleColor:[[self class] disabledTitleColor] forState:UIControlStateDisabled];
    }
    return self;
}

+ (UIColor *)defaultBackgroundColor {
    return [UIColor colorWithWhite:1.0 alpha:0.95];
}

+ (UIColor *)highlightedBackgroundColor {
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

+ (UIColor *)selectedBackgroundColor {
    return [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)defaultTitleColor {
    return [UIColor blackColor];
}

+ (UIColor *)disabledTitleColor {
    return [UIColor colorWithWhite:121.0/255.0 alpha:1.0];
}

@end
