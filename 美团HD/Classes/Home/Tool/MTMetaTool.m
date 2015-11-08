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
@end
