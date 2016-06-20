//
//  YHSelectAddressElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSelectAddressElement.h"

#import "YHLocationCellElement.h"
@interface YHSelectAddressElement ()
{

}

@end

@implementation YHSelectAddressElement

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHLocationCellElement* ele = (YHLocationCellElement*)[_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
    if ([self.delegate respondsToSelector:@selector(selectAddressElement:didSelected:)]) {
        [self.delegate selectAddressElement:self didSelected:ele.location];
    }
    [self.env.navigationController popViewControllerAnimated:YES];
}
@end
