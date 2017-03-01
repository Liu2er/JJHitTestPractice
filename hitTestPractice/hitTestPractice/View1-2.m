//
//  View1-2.m
//  hitTest
//
//  Created by 刘佳杰 on 2017/2/23.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "View1-2.h"

@implementation View1_2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"View1_2";
        label.textColor = [UIColor redColor];
        [label sizeToFit];
        [self addSubview:label];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"View1-2 = hitTest:withEvent:");
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"View1-2 = touchesBegan:withEvent:");
}

@end
