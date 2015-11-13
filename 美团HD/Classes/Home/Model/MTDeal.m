//
//  MTDeal.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/9.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTDeal.h"
#import "MJExtension.h"
#import "MTBusiness.h"

@implementation MTDeal
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [MTBusiness class]};
}

- (BOOL)isEqual:(MTDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

MJCodingImplementation
@end
