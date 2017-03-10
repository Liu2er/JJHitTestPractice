//
//  JJFLEXExplorerToolbar.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "JJFLEXExplorerToolbar.h"
#import "JJFLEXToolbarItem.h"
#import "JJFLEXResources.h"
#import "UIView+Layout.h"

static const CGFloat toolBarHeight = 44.0;
static const CGFloat toolBarItemWidth = 50.0;
static const CGFloat toolBarDragHandleWidth = 30.0;

@interface JJFLEXExplorerToolbar ()

@property (nonatomic, strong, readwrite) UIView *dragHandle;
@property (nonatomic, strong) UIImageView *dragHandleImageView;
@property (nonatomic, strong, readwrite) JJFLEXToolbarItem *selectItem;
@property (nonatomic, strong, readwrite) JJFLEXToolbarItem *closeItem;

@end

@implementation JJFLEXExplorerToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _dragHandle = ({
            UIView *dragHandle = [[UIView alloc] initWithFrame:CGRectZero];
            dragHandle.backgroundColor = [JJFLEXToolbarItem defaultBackgroundColor];
            [self addSubview:dragHandle];
            dragHandle;
        });
        
        _dragHandleImageView = ({
            UIImageView *dragHandleImageView = [[UIImageView alloc] initWithImage:[JJFLEXResources dragIcon]];
            [_dragHandle addSubview:dragHandleImageView];
            dragHandleImageView;
        });
        
        _selectItem = ({
            JJFLEXToolbarItem *selectItem = [JJFLEXToolbarItem toolbarItemWithTitle:@"Select" image:[JJFLEXResources selectIcon]];
            [selectItem addTarget:self action:@selector(selectToolBar) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:selectItem];
            selectItem;
        });
        
        _closeItem = ({
            JJFLEXToolbarItem *closeItem = [JJFLEXToolbarItem toolbarItemWithTitle:@"Close" image:[JJFLEXResources closeIcon]];
            [closeItem addTarget:self action:@selector(closeToolBar) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:closeItem];
            closeItem;
        });
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1、self.bounds.origin.x = 0;self.bounds.origin.y = 0;
    // 先 size 后 point，否则会有问题
    self.dragHandle.size = CGSizeMake(toolBarDragHandleWidth, toolBarHeight);
    self.dragHandle.left = 0;
    self.dragHandle.top = 0;
    
    self.dragHandleImageView.centerX = self.dragHandle.centerX;
    self.dragHandleImageView.centerY = self.dragHandle.centerY;
    
    self.selectItem.size = CGSizeMake(toolBarItemWidth, toolBarHeight);
    self.selectItem.left = self.dragHandle.right;
    self.selectItem.centerY = self.dragHandle.centerY;
    
    self.closeItem.size = CGSizeMake(toolBarItemWidth, toolBarHeight);
    self.closeItem.left = self.selectItem.right;
    self.closeItem.centerY = self.dragHandle.centerY;
}

- (void)dragToolBar {
    NSLog(@"拖动");
    if (_dragButtonAction) {
        self.dragButtonAction();
    }
}

- (void)selectToolBar {
    NSLog(@"选择");
    if (_selectButtonAction) {
        if (self.selectItem.highlighted) {
            self.selectItem.backgroundColor = [[self class] highlightedBackgroundColor];
        }
        self.selectButtonAction();
    }
}

- (void)closeToolBar {
    NSLog(@"关闭");
    if (_closeButtonAction) {
        self.closeButtonAction();
    }
}

+ (CGSize)toolBarSize {
    CGFloat toolBarWidth = toolBarDragHandleWidth + toolBarItemWidth * 2;
    return CGSizeMake(toolBarWidth, toolBarHeight);
}

+ (CGFloat)toolbarItemHeight {
    return 44.0;
}

+ (CGFloat)dragHandleWidth {
    return 30.0;
}

+ (UIColor *)highlightedBackgroundColor {
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

+ (UIColor *)selectedBackgroundColor {
    return [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)defaultBackgroundColor {
    return [UIColor colorWithWhite:1.0 alpha:0.95];
}

@end
