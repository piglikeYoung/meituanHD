//
//  MTRegionViewController.h
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTRegionViewController.h"
#import "MTHomeDropdown.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "MTCityViewController.h"
#import "MTNavigationController.h"
#import "MTRegion.h"

@interface MTRegionViewController ()<MTHomeDropdownDataSource>
- (IBAction)changeCity;

@end

@implementation MTRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建下拉菜单
    UIView *title = [self.view.subviews firstObject];
    MTHomeDropdown *dropdown = [MTHomeDropdown dropdown];
    dropdown.y = title.height;
    dropdown.dataSource = self;
    [self.view addSubview:dropdown];
    
    // 设置控制器在popover中的尺寸
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
}

/**
 *  切换城市
 */
- (IBAction)changeCity {
    [self.popover dismissPopoverAnimated:YES];
    
    MTCityViewController *city = [[MTCityViewController alloc] init];
    MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MTHomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropdown *)homeDropdown
{
    return self.regions.count;
}

- (NSString *)homeDropdown:(MTHomeDropdown *)homeDropdown titleForRowInMainTable:(int)row
{
    MTRegion *region = self.regions[row];
    return region.name;
}

- (NSArray *)homeDropdown:(MTHomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row
{
    MTRegion *region = self.regions[row];
    return region.subregions;
}
@end
