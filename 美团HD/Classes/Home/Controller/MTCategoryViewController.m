//
//  MTCategoryViewController.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/6.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  分类控制器:显示分类列表

#import "MTCategoryViewController.h"
#import "MTHomeDropdown.h"
#import "UIView+Extension.h"
#import "MTCategory.h"
#import "MJExtension.h"

// iPad中控制器的view的尺寸默认都是1024x768, MTHomeDropdown的尺寸默认是300x340
// MTCategoryViewController显示在popover中,尺寸变为480x320, MTHomeDropdown的尺寸也跟着减小:0x0

@interface MTCategoryViewController ()

@end

@implementation MTCategoryViewController

- (void)loadView {
    MTHomeDropdown *dropdown = [MTHomeDropdown dropdown];
    // 加载分类数据
    dropdown.categories = [MTCategory objectArrayWithFilename:@"categories.plist"];
    self.view = dropdown;
    
    // 设置控制器view在popover中的尺寸
    self.preferredContentSize = dropdown.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

@end
