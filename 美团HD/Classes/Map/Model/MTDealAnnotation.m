//
//  MTDealAnnotation.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/13.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTDealAnnotation.h"

@implementation MTDealAnnotation

/**
 *  根据title判断大头针是否相同
 *
 */
- (BOOL)isEqual:(MTDealAnnotation *)other {
    return [self.title isEqualToString:other.title];
}
@end
