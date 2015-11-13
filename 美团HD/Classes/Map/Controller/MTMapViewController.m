//
//  MTMapViewController.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/13.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "UIBarButtonItem+Extension.h"
#import "MTHomeTopItem.h"
#import "MTConst.h"
#import "MTCategoryViewController.h"
#import "MTCategory.h"
#import "MTDealAnnotation.h"
#import "MTDeal.h"
#import "MJExtension.h"
#import "MTMetaTool.h"
#import "MTBusiness.h"

@interface MTMapViewController () <MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, strong) DPRequest *lastRequest;
@property (nonatomic, strong) CLLocationManager *mgr;
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *city;
@end

@implementation MTMapViewController

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 标题
    self.title = @"地图";
    
    // 设置地图跟踪用户的位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    // 注意:在iOS8中, 如果想要追踪用户的位置, 必须自己主动请求隐私权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
    }
    
    // 左边的返回
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    // 设置左上角的分类菜单
    MTHomeTopItem *categoryTopItem = [MTHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    // 监听分类改变
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
}

- (void)dealloc {
    [MTNotificationCenter removeObserver:self];
}

- (void)categoryClick {
    // 显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)categoryDidChange:(NSNotification *)notification {
    // 1.关闭Popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 2.获得要发送给服务器的类型名称
    MTCategory *category = notification.userInfo[MTSelectCategory];
    NSString *subcategoryName = notification.userInfo[MTSelectSubcategoryName];
    if (!subcategoryName || [subcategoryName isEqualToString:@"全部"]) {
        // 点击的数据没有子分类
        self.selectedCategoryName = category.name;
    } else {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 3.删除之前的所以大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 4.重新发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
    // 5.更换顶部item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subcategoryName];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    // 让地图显示到用户所在的位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    // 经纬度 --> 城市名 : 反地理编码
    // 城市名 --> 经纬度 : 地理编码
    // 根据经纬度推断城市名
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        // 如果是直辖市pm.locality为nil，则获取pm.addressDictionary[@"State"]的值
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        // 去掉“市”字
        self.city = [city substringToIndex:city.length - 1];
        
        // 发送请求给服务器
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!self.city) return;
    
    // 发送请求给服务器
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.city;
    // 类别
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 经纬度
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MTDealAnnotation *)annotation {
    // 返回nil,意味着交给系统处理
    if (![annotation isKindOfClass:[MTDealAnnotation class]]) return nil;
    
    // 创建大头针控件
    static NSString *ID = @"dealAnnotation";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annotationView.canShowCallout = YES;
    }
    
    // 设置模型(位置\标题\子标题)
    annotationView.annotation = annotation;
    
    // 设置图片
    if (annotation.icon) {
        annotationView.image = [UIImage imageNamed:annotation.icon];
    }

    return annotationView;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    if (request != self.lastRequest) return;
    
    NSLog(@"请求失败 - %@", error);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (request != self.lastRequest) return;
    
    NSArray *deals = [MTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (MTDeal *deal in deals) {
        
        // 获得团购所属的类型
        MTCategory *category = [MTMetaTool categoryWithDeal:deal];
        
        for (MTBusiness *business in deal.businesses) {
            MTDealAnnotation *anno = [[MTDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            
            // 判断大头针是否已经存在，若存在就不再放入
            if ([self.mapView.annotations containsObject:anno]) break;
            
            [self.mapView addAnnotation:anno];
        }
    }
}

@end
