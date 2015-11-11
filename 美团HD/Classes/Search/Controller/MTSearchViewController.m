//
//  MTSearchViewController.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/10.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTConst.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

@interface MTSearchViewController ()<UISearchBarDelegate>

@end

@implementation MTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左边的返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    /*
     *  直接把搜索框添加到导航栏作为titleView，系统会把搜索框拉得很长，撑满导航栏，设置frame或Autolayout都没法改变它的长度
     *  如果想把搜索框固定长度，需要在外面套一层View，把外层View作为titleView，设置外层View的frame就可以间接设置搜索框的长度
     */
    //    UIView *titleView = [[UIView alloc] init];
    //    titleView.width = 300;
    //    titleView.height = 35;
    //    titleView.backgroundColor = [UIColor redColor];
    //    self.navigationItem.titleView = titleView;
    
    // 中间的搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    //    searchBar.frame = titleView.bounds;
    //    [titleView addSubview:searchBar];
    
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 搜索框代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 进入下拉刷新状态, 发送请求给服务器
    [self.collectionView headerBeginRefreshing];
    
    // 退出键盘
    [searchBar resignFirstResponder];
}

#pragma mark - 实现父类提供的方法
- (void)setupParams:(NSMutableDictionary *)params {
    params[@"city"] = self.selectedCityName;
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}

@end
