//
//  MTSortViewController.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/9.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTSortViewController.h"
#import "MTMetaTool.h"
#import "MTSort.h"
#import "UIView+Extension.h"
#import "MTConst.h"

@interface MTSortButton : UIButton
@property (nonatomic, strong) MTSort *sort;
@end

@implementation MTSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setSort:(MTSort *)sort {
    _sort = sort;
    
    [self setTitle:_sort.label forState:UIControlStateNormal];
}

@end

@interface MTSortViewController ()

@end

@implementation MTSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [MTMetaTool sorts];
    NSUInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i < count; i++) {
        
        MTSortButton *button = [[MTSortButton alloc] init];
        button.sort = sorts[i];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    // 设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}

- (void)buttonClick:(UIButton *)button
{
    [MTNotificationCenter postNotificationName:MTSortDidChangeNotification object:nil userInfo:@{MTSelectSort : [MTMetaTool sorts][button.tag]}];
}

@end
