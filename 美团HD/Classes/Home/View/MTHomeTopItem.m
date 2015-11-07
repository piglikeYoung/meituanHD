//
//  MTHomeTopItem.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTHomeTopItem.h"

@interface MTHomeTopItem()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@end

@implementation MTHomeTopItem

+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MTHomeTopItem" owner:nil options:nil] firstObject];
}


- (void)addTarget:(id)target action:(SEL)action
{
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
