//
//  JJFLEXExplorerViewController.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "JJFLEXExplorerViewController.h"
#import "JJFLEXExplorerToolbar.h"
#import "UIView+Layout.h"
#import "JJFLEXManager.h"

@interface UIWindow (allWindows)

+ (NSArray *)allWindowsIncludingInternalWindows:(BOOL)includeInternalWindows onlyVisibleWindows:(BOOL)onlyVisibleWindows;

@end

@interface JJFLEXExplorerViewController ()

@property (nonatomic, strong) JJFLEXExplorerToolbar *explorerToolbar;

/// Only valid while a toolbar drag pan gesture is in progress.
@property (nonatomic, assign) CGRect toolbarFrameBeforeDragging;

// 用于存放 HitView 和 HitView 的 outlineView，其中 key 是 HitView，value 是 outlineView
@property (nonatomic, strong) NSMutableDictionary *outlineViewsForHitViews;

@property (nonatomic, assign) BOOL isSelectItemChosen;

@end

@implementation JJFLEXExplorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelectItemChosen = NO;
    
    self.explorerToolbar = [[JJFLEXExplorerToolbar alloc] initWithFrame:CGRectMake(100, 400, 0, 0)];
    self.explorerToolbar.size = [JJFLEXExplorerToolbar toolBarSize];
    self.explorerToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.explorerToolbar];
    
    UIButton *buttont = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    buttont.backgroundColor = [UIColor redColor];
    [self.view addSubview:buttont];
    
    
    self.explorerToolbar.closeButtonAction = ^(){
        [JJFLEXManager sharedManager].explorerWindow.hidden = YES;
    };
    
    __weak typeof(self) weakSelf = self;
    weakSelf.explorerToolbar.selectButtonAction = ^(){
        weakSelf.isSelectItemChosen = !self.isSelectItemChosen;
        if (!weakSelf.isSelectItemChosen) {
            // 移除之前添加的 outlineViews
            [weakSelf removeOutlineViews];
        }
    };
    
    self.outlineViewsForHitViews = [NSMutableDictionary dictionary];
    
    [self setupSelectionTapGestures];
    [self setupToolbarPanGestures];
}

- (void)setupSelectionTapGestures {
    UITapGestureRecognizer *selectionTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectionTap:)];
    [self.view addGestureRecognizer:selectionTapGR];
}

// 监听屏幕点击事件
- (void)handleSelectionTap:(UITapGestureRecognizer *)tapGR {
    if (tapGR.state != UIGestureRecognizerStateRecognized) return;
    // 移除之前添加的 outlineViews
    [self removeOutlineViews];
    
    if (self.isSelectItemChosen) {
        // 添加新的 outlineViews
        CGPoint tapPointInView = [tapGR locationInView:self.view];
        CGPoint tapPointInWindow = [self.view convertPoint:tapPointInView toView:nil];
        [self addOutlineViewAtTapPoint:tapPointInWindow];
        
    }
    
}

// 遍历整个 UIApplication 得到包含所有 window 和 subviews 的数组
- (NSMutableArray *)ergodicAllWindowsAndSubViewsInApplication {
    NSMutableArray *allWindowsAndSubViews = [NSMutableArray array];
    NSArray *allWindows = [UIWindow allWindowsIncludingInternalWindows:YES onlyVisibleWindows:NO];
    for (UIWindow *window in allWindows) {
        [allWindowsAndSubViews addObject:window];
        [allWindowsAndSubViews addObjectsFromArray:[self recursiveSubviewsInView:window]];
        //        NSLog(@"%@ = %@", NSStringFromClass([window class]), [self recursiveSubviewsInView:window]);
    }
    return allWindowsAndSubViews;
}

// 给相应点击最合适的 hitView 添加 outlineView
- (void)addOutlineViewAtTapPoint:(CGPoint)tapPoint {
    //    [self ergodicAllWindowsAndSubViewsInApplication]; // 调用此方法的目的是打印所有的 window 和 view
    
    // 遍历 UIWindow 下的所有包含点击点的 view
    NSArray *subviewsContainPoint = [self recursiveSubviewsAtPoint:tapPoint inView:(UIView *)[[UIApplication sharedApplication] keyWindow]];
    // 获得点击点最合适的 view
    UIView *hitView = [subviewsContainPoint lastObject];
    // 为 hitView 生成一个边框 view：outlineView
    UIView *outlineView = [self outlineViewForView:hitView];
    // 将 outlineView 添加到 self.view
    [self.view addSubview:outlineView];
    // 把 outlineView 保存起来（key 为 hitView，value 为 outlineView）
    NSValue *key = [NSValue valueWithNonretainedObject:hitView];
    [self.outlineViewsForHitViews setObject:outlineView forKey:key];
}

// 递归遍历某 window 下所有的 subviews
- (NSArray *)recursiveSubviewsInView:(UIView *)view {
    NSMutableArray *subviewsInView = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        if (subview.hidden || subview.alpha < 0.01) continue;
        [subviewsInView addObject:subview];
        [subviewsInView addObjectsFromArray:[self recursiveSubviewsInView:subview]];
    }
    return subviewsInView;
}

// 递归遍历某 window 下"包含 pointInView 点的"所有的 subviews
- (NSArray *)recursiveSubviewsAtPoint:(CGPoint)pointInView inView:(UIView *)view {
    NSMutableArray *subviewsContainPoint = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        if (subview.hidden || subview.alpha < 0.01) continue;
        
        BOOL isSubviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (isSubviewContainsPoint) {
            [subviewsContainPoint addObject:subview];
        }
        // 对于 pointInView 落在超出父 view 的子 view 上的部分且可以显示出来（clipsToBounds == NO）的情况，也要将其遍历出来
        if (isSubviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsContainPoint addObjectsFromArray:[self recursiveSubviewsAtPoint:pointInSubview inView:subview]];
        }
    }
    return subviewsContainPoint;
}

// 给 view 加上边框
- (UIView *)outlineViewForView:(UIView *)view {
    CGRect outlineFrame = [self frameInLocalCoordinatesForView:view];
    UIView *outlineView = [[UIView alloc] initWithFrame:outlineFrame];
    outlineView.backgroundColor = [UIColor clearColor];
    outlineView.layer.borderColor = [[self consistentRandomColorForObject:view] CGColor];
    outlineView.layer.borderWidth = 1.5;
    return outlineView;
}

// 将 view 的 frame 转换到 UIWindow 中
- (CGRect)frameInLocalCoordinatesForView:(UIView *)view {
    // First convert to window coordinates since the view may be in a different window than our view.
    CGRect frameInWindow = [view convertRect:view.bounds toView:nil];
    // Then convert from the window to our view's coordinate space.
    return [self.view convertRect:frameInWindow fromView:nil];
}

// 获取随机色，且该颜色由对象 object 的内存地址唯一确定
- (UIColor *)consistentRandomColorForObject:(id)object {
    // 设置随机颜色
    //    NSUInteger R = (arc4random() % 256) ;
    //    NSUInteger G = (arc4random() % 256) ;
    //    NSUInteger B = (arc4random() % 256) ;
    //    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    
    // 例如 po object: <View1_1: 0x7ff85be01d80; frame = (30 30; 195 183.5); layer = <CALayer: 0x60800023a680>>
    // p object: (View1_1 *) $10 = 0x00007ff85be01d80
    // p (NSUInteger)object: (NSUInteger) $11 = 140704670031232
    // p (NSUInteger)object >> 4: (NSUInteger) $15 = 8794041876952
    // p ((NSUInteger)object >> 4) % 256: (unsigned long) $16 = 216
    // p (((NSUInteger)object >> 4) % 256) / 255.0: (double) $17 = 0.84705882352941175
    // >> 表示二进制整体右移，即小数点左移，即除以2
    CGFloat hue = (((NSUInteger)object >> 4) % 256) / 255.0;
    // 指定HSB，参数是：色调（hue），饱和的（saturation），亮度（brightness）
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

// 移除之前添加的 outlineViews，并清空属性 self.outlineViewsForHitViews
- (void)removeOutlineViews {
    for (id key in self.outlineViewsForHitViews) {
        UIView *outlineView = self.outlineViewsForHitViews[key];
        [outlineView removeFromSuperview];
    }
    [self.outlineViewsForHitViews removeAllObjects];
}

#pragma mark - Toolbar Dragging

- (void)setupToolbarPanGestures {
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleToolbarPanGesture:)];
    [self.explorerToolbar addGestureRecognizer:panGR];
}

- (void)handleToolbarPanGesture:(UIPanGestureRecognizer *)panGR {
    
    CGPoint tapPointInView = [panGR locationInView:self.view];
    CGPoint translation = [panGR translationInView:self.view];
    NSLog(@"panGR = %@, tapPointInView = %@, translation = %@", panGR, NSStringFromCGPoint(tapPointInView), NSStringFromCGPoint(translation));
    
    //    [self updateToolbarPostionWithDragGesture:panGR];
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
            self.toolbarFrameBeforeDragging = self.explorerToolbar.frame;
            [self updateToolbarPostionWithDragGesture:panGR];
            break;
            
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            [self updateToolbarPostionWithDragGesture:panGR];
            break;
            
        default:
            break;
    }
}

- (void)updateToolbarPostionWithDragGesture:(UIPanGestureRecognizer *)panGR {
    CGPoint translation = [panGR translationInView:self.view];
    CGRect newToolbarFrame = self.toolbarFrameBeforeDragging;
    newToolbarFrame.origin.x += translation.x;
    newToolbarFrame.origin.y += translation.y;
    
    CGFloat maxY = CGRectGetMaxY(self.view.bounds) - newToolbarFrame.size.height;
    if (newToolbarFrame.origin.y < 0.0) {
        newToolbarFrame.origin.y = 0.0;
    } else if (newToolbarFrame.origin.y > maxY) {
        newToolbarFrame.origin.y = maxY;
    }
    
    CGFloat maxX = CGRectGetMaxX(self.view.bounds) - newToolbarFrame.size.width;
    if (newToolbarFrame.origin.x < 0) {
        newToolbarFrame.origin.x = 0;
    } else if (newToolbarFrame.origin.x > maxX) {
        newToolbarFrame.origin.x = maxX;
    }
    
    self.explorerToolbar.frame = newToolbarFrame;
}

@end
