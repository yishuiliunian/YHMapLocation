//
//  YHMapViewController.m
//  YaoHe
//
//  Created by stonedong on 16/4/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>



@interface YHMapViewController () <MAMapViewDelegate>
{
    BOOL _firstShow;
}
@property (nonatomic, strong) YHLocation* location;
@property (nonatomic, strong) MAMapView* mapView;
@end

@implementation YHMapViewController
@synthesize location = _location;
- (instancetype) initWithLocation:(YHLocation *)location
{
    self = [super init];
    if (!self) {
        return self;
    }
    _location = location;
    _firstShow = YES;
    return self;
}
- (void) loadView
{
    _mapView =[[MAMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.delegate = self;
    self.view = _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationCoordinate2D coor;
    coor.latitude = _location.latitude;
    coor.longitude = _location.longtitude;
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = _location.name;
    pointAnnotation.subtitle = _location.address;
    
    [_mapView addAnnotation:pointAnnotation];
    
    
    MACoordinateSpan span = {0.05, 0.05};
    MACoordinateRegion region = MACoordinateRegionMake(coor, span);
    _mapView.centerCoordinate = coor;
    [_mapView setRegion:region];
    [_mapView setSelectedAnnotations:@[pointAnnotation]];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = _location.name;
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
