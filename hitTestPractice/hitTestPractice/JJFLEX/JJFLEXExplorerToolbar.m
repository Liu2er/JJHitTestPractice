//
//  JJFLEXExplorerToolbar.m
//  hitTestPractice
//
//  Created by 刘佳杰 on 2017/3/8.
//  Copyright © 2017年 Jiajie.Liu. All rights reserved.
//

#import "JJFLEXExplorerToolbar.h"
#import "JJFLEXResources.h"
#import "UIView+Layout.h"

#import "JJFLEXToolbarItem.h"

static const CGFloat itemMargin = 5.f;
static const CGFloat itemPadding = 20.f;

@interface JJFLEXExplorerToolbar ()

@property (strong, nonatomic) UIButton *dragItem;
@property (strong, nonatomic) UIButton *selectItem;
@property (strong, nonatomic) UIButton *closeItem;

@property (nonatomic, strong, readwrite) FLEXToolbarItem *selectItem;
@property (nonatomic, strong, readwrite) FLEXToolbarItem *moveItem;
@property (nonatomic, strong, readwrite) FLEXToolbarItem *globalsItem;

@end

@implementation JJFLEXExplorerToolbar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.backgroundColor = [UIColor magentaColor];
        
        _dragItem = ({
            UIButton *dragItem = [[UIButton alloc] initWithFrame:CGRectZero];
            [dragItem setImage:[JJFLEXResources dragIcon] forState:UIControlStateNormal];
            [dragItem addTarget:self action:@selector(dragToolBar) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:dragItem];
            dragItem;
        });
        
        _selectItem = ({
            UIButton *selectItem = [[UIButton alloc] initWithFrame:CGRectZero];
            [selectItem setImage:[JJFLEXResources selectIcon] forState:UIControlStateNormal];
            //            if (selectItem.highlighted) {
            //                selectItem.backgroundColor = [[self class] highlightedBackgroundColor];
            //            }
            [selectItem addTarget:self action:@selector(selectToolBar) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:selectItem];
            selectItem;
        });
        
        _closeItem = ({
            UIButton *closeItem = [[UIButton alloc] initWithFrame:CGRectZero];
            [closeItem setImage:[JJFLEXResources closeIcon] forState:UIControlStateNormal];
            closeItem setImageEdgeInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
            [closeItem addTarget:self action:@selector(closeToolBar) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:closeItem];
            closeItem;
        });
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dragItem sizeToFit];
    self.dragItem.left = itemMargin;
    self.dragItem.top = 0;
    
    [self.selectItem sizeToFit];
    self.selectItem.left = self.dragItem.right + itemPadding;
    self.selectItem.centerY = self.dragItem.centerY;
    
    [self.closeItem sizeToFit];
    self.closeItem.left = self.selectItem.right + itemPadding;
    self.closeItem.centerY = self.dragItem.centerY;
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
        //        self.selectItem.highlighted
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
    return CGSizeMake(itemMargin + [JJFLEXResources dragIcon].size.width + itemPadding + [JJFLEXResources selectIcon].size.width + itemPadding + [JJFLEXResources closeIcon].size.width + itemMargin, [JJFLEXResources dragIcon].size.height);
}

//- (void)updateBackgroundColor
//{
//    if (self.highlighted) {
//        self.backgroundColor = [[self class] highlightedBackgroundColor];
//    } else if (self.selected) {
//        self.backgroundColor = [[self class] selectedBackgroundColor];
//    } else {
//        self.backgroundColor = [[self class] defaultBackgroundColor];
//    }
//}

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
