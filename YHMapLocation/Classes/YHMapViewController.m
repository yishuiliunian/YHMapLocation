//
//  YHMapViewController.m
//  YaoHe
//
//  Created by stonedong on 16/4/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface YHMapViewController () <BMKMapViewDelegate, BMKPoiSearchDelegate>
{
    BMKPoiSearch* _searcher;
}
@property (nonatomic, strong) YHLocation* location;
@property (nonatomic, strong) BMKMapView* mapView;
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
    return self;
}
- (void) loadView
{
    
    _mapView =[BMKMapView new];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.showMapPoi = YES;
    self.view = _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   
    BMKPointAnnotation* point  = [BMKPointAnnotation new];
    CLLocationCoordinate2D coor;
    coor.latitude = _location.latitude;
    coor.longitude = _location.longtitude;
    point.coordinate = coor;
    point.title = _location.name;
    [_mapView addAnnotation:point];
    
    

    
    

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D coor;
    coor.latitude = _location.latitude;
    coor.longitude = _location.longtitude;
    
    BMKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta =0.1;
    BMKCoordinateRegion region;
    region.center = coor;
    region.span = span;
    
    CGRect fitRect = [_mapView convertRegion:region toRectToView:_mapView];
    BMKMapRect fitMapRect = [_mapView convertRect:fitRect toMapRectFromView:_mapView];
    [_mapView setVisibleMapRect:fitMapRect animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.canShowCallout = YES;
        [newAnnotationView setSelected:YES];
        return newAnnotationView;
    }
    return nil;
}

@end
