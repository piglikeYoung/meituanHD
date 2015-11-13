//
//  MTMetaTool.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/8.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  

#import "MTMetaTool.h"
#import "MTCity.h"
#import "MJExtension.h"
#import "MTCategory.h"
#import "MTSort.h"
#import "MTDeal.h"

@implementation MTMetaTool

static NSArray *_cities;
+ (NSArray *)cities {
    if (!_cities) {
        _cities = [MTCity objectArrayWithFilename:@"cities.plist"];;
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [MTCategory objectArrayWithFilename:@"categories.plist"];;
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [MTSort objectArrayWithFilename:@"sorts.plist"];;
    }
    return _sorts;
}

+ (MTCategory *)categoryWithDeal:(MTDeal *)deal {
    // 加载所以类别
    NSArray *cs = [self categories];
    // 需要判断的deal的第一个类别
    NSString *cname = [deal.categories firstObject];
    for (MTCategory *c in cs) {
        // 属于某个大类别返回
        if ([cname isEqualToString:c.name]) return c;
        // 属于大类别的小类别返回
        if ([c.subcategories containsObject:cname]) return c;
    }
    
    return nil;
}

@end
