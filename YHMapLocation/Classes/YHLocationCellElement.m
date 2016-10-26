//
//  YHLocationCellElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHLocationCellElement.h"
#import "DZImageCache.h"
@implementation YHLocationCellElement

- (instancetype) initWithLocation:(YHLocation *)location
{
    self = [super init];
    if (!self) {
        return self;
    }
    _location = location;
    return self;
}


- (void) willBeginHandleResponser:(UITableViewCell*)view
{
    [super willBeginHandleResponser:view];
    view.textLabel.text = _location.name;
    view.imageView.image = DZCachedImageByName(@"ic_small_location");
}
- (void) didBeginHandleResponser:(UIResponder *)view
{
    [super didBeginHandleResponser:view];
}

- (void) willRegsinHandleResponser:(UIResponder *)view
{
    [super willRegsinHandleResponser:view];
}

- (void) didRegsinHandleResponser:(UIResponder *)view
{
    [super didRegsinHandleResponser:view];
}

@end
