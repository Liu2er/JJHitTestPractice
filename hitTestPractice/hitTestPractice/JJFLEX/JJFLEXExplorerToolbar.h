//
//  JJFLEXExplorerToolbar.h
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJFLEXExplorerToolbar : UIView

@property (copy, nonatomic) void (^dragButtonAction)(void);
@property (copy, nonatomic) void (^selectButtonAction)(void);
@property (copy, nonatomic) void (^closeButtonAction)(void);

+ (CGSize)toolBarSize;

@end
