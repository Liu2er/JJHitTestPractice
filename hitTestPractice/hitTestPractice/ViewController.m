//
//  ViewController.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/1.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Layout.h"
#import "View1.h"
#import "View1-1.h"
#import "View1-2.h"
#import "View2.h"
#import "View2-1.h"
#import "View2-1-1.h"
#import "FLEXManager.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    View1 *view1 = [[View1 alloc] initWithFrame:CGRectMake(60, 60, SCREEN_WIDTH - 60 * 2, (SCREEN_HEIGHT - 60 * 3) * 0.5)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    
    View1_1 *view1_1 = [[View1_1 alloc] initWithFrame:CGRectMake(30, 30, view1.width - 30 * 2, view1.height - 30 * 2)];
    view1_1.backgroundColor = [UIColor greenColor];
    [view1 addSubview:view1_1];
    
    View1_2 *view1_2 = [[View1_2 alloc] initWithFrame:CGRectMake(view1.centerX, view1.centerY, view1_1.width * 0.5, view1_1.height * 0.5)];
    view1_2.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:view1_2];
    
    
    
    View2 *view2 = [[View2 alloc] initWithFrame:CGRectMake(60, view1.bottom + 60, view1.width, view1.height)];
    view2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view2];
    
    View2_1 *view2_1 = [[View2_1 alloc] initWithFrame:CGRectMake(30, 30, view2.width - 30 * 2, view2.height - 30 * 2)];
    view2_1.backgroundColor = [UIColor blueColor];
    [view2 addSubview:view2_1];
    
    View2_1_1 *view2_1_1 = [[View2_1_1 alloc] initWithFrame:CGRectMake(view2_1.centerX + 30, view2_1.centerY + 30, view1_2.width, view1_2.height)];
    view2_1_1.backgroundColor = [UIColor redColor];
    [view2_1 addSubview:view2_1_1];
    
   [[FLEXManager sharedManager] showExplorer];
}

@end
