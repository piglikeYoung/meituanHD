//
//  MTHomeDropdown.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTHomeDropdown.h"
#import "MTCategory.h"
#import "MTConst.h"
#import "MTHomeDropdownMainCell.h"
#import "MTHomeDropdownSubCell.h"

@interface MTHomeDropdown() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (nonatomic, strong) MTCategory *seledtedCategory;
@end

@implementation MTHomeDropdown

+ (instancetype)dropdown
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MTHomeDropdown" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // 不需要跟随父控件的尺寸变化而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return self.categories.count;
    } else {
        return self.seledtedCategory.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView) {
        cell = [MTHomeDropdownMainCell cellWithTableView:tableView];
        
        // 显示文字
        MTCategory *category = self.categories[indexPath.row];
        cell.textLabel.text = category.name;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        if (category.subcategories.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { // 从表
        cell = [MTHomeDropdownSubCell cellWithTableView:tableView];
        
        cell.textLabel.text = self.seledtedCategory.subcategories[indexPath.row];
    }
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        // 被点击的分类
        self.seledtedCategory = self.categories[indexPath.row];
        // 刷新右边的数据
        [self.subTableView reloadData];
    }
}


@end
