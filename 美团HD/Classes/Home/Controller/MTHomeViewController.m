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
#import "MTRegionViewController.h"
#import "MTCity.h"
#import "MTMetaTool.h"
#import "MTSortViewController.h"
#import "MTSort.h"
#import "MTCategory.h"
#import "MTRegion.h"
#import "DPAPI.h"
#import "MTDeal.h"
#import "MJExtension.h"
#import "MTDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"

@interface MTHomeViewController ()<DPRequestDelegate>
/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 地区item */
@property (nonatomic, weak) UIBarButtonItem *regionItem;
/** 排序item */
@property (nonatomic, weak) UIBarButtonItem *sortItem;

/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的分类名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的区域名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 当前选中的排序 */
@property (nonatomic, strong) MTSort *selectedSort;

/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
/** 区域popover */
@property (nonatomic, strong) UIPopoverController *regionPopover;
/** 排序popover */
@property (nonatomic, strong) UIPopoverController *sortPopover;

/** 所有的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;
/** 记录当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 最后一个请求 */
@property (nonatomic, weak) DPRequest *lastRequest;

@property (nonatomic, weak) UIImageView *noDataView;

/** 总数 */
@property (nonatomic, assign) NSInteger totalCount;


@end

@implementation MTHomeViewController

- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIImageView *)noDataView {
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
        }];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

static NSString *const reuseIdentifier = @"deal";

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.collectionView.backgroundColor = MTGlobalBg;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    // 添加上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    
    // 监听城市改变
    [MTNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:MTCityDidChangeNotification object:nil];
    // 监听排序改变
    [MTNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:MTSortDidChangeNotification object:nil];
    // 监听分类改变
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
    // 监听区域改变
    [MTNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:MTRegionDidChangeNotification object:nil];
    
    // 设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];

}

- (void)dealloc {
    [MTNotificationCenter removeObserver:self];
}

/**
 当屏幕旋转,控制器view的尺寸发生改变调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024) ? 3 : 2;
    
    // 根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    // 设置每一行之前的间距
    layout.minimumLineSpacing = inset;
}

#pragma mark - 监听通知
- (void)cityDidChange:(NSNotification *)notification
{
    self.selectedCityName = notification.userInfo[MTSelectCityName];
    
    // 1.更换顶部区域item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectedCityName]];
    [topItem setSubtitle:nil];
    
    // 2.刷新表格数据
    [self.collectionView headerBeginRefreshing];
    
}

- (void)categoryDidChange:(NSNotification *)notification {
    MTCategory *category = notification.userInfo[MTSelectCategory];
    NSString *subcategoryName = notification.userInfo[MTSelectSubcategoryName];
    
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) { // 点击的数据没有子分类
        self.selectedCategoryName = category.name;
    } else {
        self.selectedCategoryName = subcategoryName;
    }
    
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 1.更换顶部item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subcategoryName];
    
    // 2.关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 3.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}

- (void)regionDidChange:(NSNotification *)notification {
    MTRegion *region = notification.userInfo[MTSelectRegion];
    NSString *subregionName = notification.userInfo[MTSelectSubregionName];
    
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    } else {
        self.selectedRegionName = subregionName;
    }
    
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }

    // 1.更换顶部item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@", self.selectedCityName, region.name]];
    [topItem setSubtitle:subregionName];
    
    // 2.关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    // 3.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}

- (void)sortDidChange:(NSNotification *)notification {
    self.selectedSort = notification.userInfo[MTSelectSort];
    
    // 1.更换顶部排序item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.sortItem.customView;
    [topItem setSubtitle:self.selectedSort.label];
    
    // 2.关闭Popover
    [self.sortPopover dismissPopoverAnimated:YES];
    
    // 3.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 跟服务器交互
- (void)loadDeals {
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.selectedCityName;
    // 每页的条数
    params[@"limit"] = @5;
    // 分类(类别)
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    // 排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    
    // 页码
    params[@"page"] = @(self.currentPage);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    
}

- (void)loadMoreDeals {
    self.currentPage++;
    
    [self loadDeals];
}

- (void)loadNewDeals {
    self.currentPage = 1;
    
    [self loadDeals];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    self.totalCount = [result[@"total_count"] integerValue];
    
    // 1.取出团购的字典数组
    NSArray *newDeals = [MTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.currentPage == 1) { // 清除之前的旧数据
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newDeals];
    
    // 2.刷新表格
    [self.collectionView reloadData];
    
    // 3.结束上拉加载
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    
    // 1.提醒失败
    [MBProgressHUD showError:@"网络繁忙,请稍后再试" toView:self.view];
    
    // 2.结束刷新
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
    // 3.如果是上拉加载失败了
    if (self.currentPage > 1) {
        self.currentPage--;
    }
}

#pragma mark - 设置导航栏内容
- (void)setupLeftNav {
    
    // 1.logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    // 2.类别
    MTHomeTopItem *categoryTopItem = [MTHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    // 3.地区
    MTHomeTopItem *regionTopItem = [MTHomeTopItem item];
    [regionTopItem setTitle:@"深圳 - 全部"];
    [regionTopItem setSubtitle:nil];
    self.selectedCityName = @"深圳";
    [regionTopItem addTarget:self action:@selector(districtClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionTopItem];
    self.regionItem = regionItem;
    
    // 4.排序
    MTHomeTopItem *sortTopItem = [MTHomeTopItem item];
    [sortTopItem setTitle:@"排序"];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];

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
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)districtClick
{
    MTRegionViewController *region = [[MTRegionViewController alloc] init];
    if (self.selectedCityName) {
        // 获得当前选中城市
        MTCity *city = [[[MTMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName]] firstObject];
        region.regions = city.regions;
    }
    
    // 显示区域菜单
    self.regionPopover = [[UIPopoverController alloc] initWithContentViewController:region];
    [self.regionPopover presentPopoverFromBarButtonItem:self.regionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    region.popover = self.regionPopover;

}

- (void)sortClick
{
    // 显示排序菜单
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[MTSortViewController alloc] init]];
    [popover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.sortPopover = popover;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // 更新cell就计算一遍内边距
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    // 控制尾部刷新控件的显示和隐藏
    self.collectionView.footerHidden = (self.totalCount == self.deals.count);
    
    // 控制"没有数据"的提醒
    self.noDataView.hidden = (self.deals.count != 0);
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}


@end
