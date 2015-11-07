//
//  MTHomeViewController.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/6.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTConst.h"
#import "MTHomeTopItem.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "MTCategoryViewController.h"

@interface MTHomeViewController ()
/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 地区item */
@property (nonatomic, weak) UIBarButtonItem *districtItem;
/** 排序item */
@property (nonatomic, weak) UIBarButtonItem *sortItem;

@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation MTHomeViewController

static NSString *const reuseIdentifier = @"Cell";

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.collectionView.backgroundColor = MTGlobalBg;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
}

#pragma mark - 设置导航栏内容
- (void)setupLeftNav {
    
    // 1.logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    
    // 2.类别
    MTHomeTopItem *categoryTopItem = [MTHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    // 3.地区
    MTHomeTopItem *districtTopItem = [MTHomeTopItem item];
    [districtTopItem addTarget:self action:@selector(districtClick)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = districtItem;
    
    // 4.排序
    MTHomeTopItem *sortTopItem = [MTHomeTopItem item];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];

}

- (void)setupRightNav {

    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - 顶部item点击方法
- (void)categoryClick
{
    // 显示分类菜单
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popover = popover;
}

- (void)districtClick
{
    MTLog(@"districtClick");
}

- (void)sortClick
{
    MTLog(@"sortClick");
}


@end
