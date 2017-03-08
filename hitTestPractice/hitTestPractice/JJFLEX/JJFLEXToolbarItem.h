//
//  JJFLEXToolbarItem.h
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJFLEXToolbarItem : UIButton

+ (instancetype)toolbarItemWithTitle:(NSString *)title image:(UIImage *)image;
+ (UIColor *)defaultBackgroundColor;

@end
