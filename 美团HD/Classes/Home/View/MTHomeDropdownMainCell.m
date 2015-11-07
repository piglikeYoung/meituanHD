//
//  MTHomeDropdownMainCell.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/6.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTHomeDropdownMainCell.h"

@implementation MTHomeDropdownMainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"main";
    MTHomeDropdownMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MTHomeDropdownMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = selectedBg;

    }
    return self;
}

@end
