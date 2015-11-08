//
//  MTDistrictViewController.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDistrictViewController.h"
#import "MTHomeDropdown.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "MTCityViewController.h"
#import "MTNavigationController.h"

@interface MTDistrictViewController ()
- (IBAction)changeCity;
@end

@implementation MTDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建下拉菜单
    UIView *title = [self.view.subviews firstObject];
    MTHomeDropdown *dropdown = [MTHomeDropdown dropdown];
    dropdown.y = title.height;
    [self.view addSubview:dropdown];
    
    // 设置控制器在popover中的尺寸
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
}

/**
 *  切换城市
 */
- (IBAction)changeCity {
    MTCityViewController *city = [[MTCityViewController alloc] init];
    MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
