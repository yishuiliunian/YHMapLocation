//
//  YHSelectAddressViewController.m
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSelectAddressViewController.h"
#import <DZGeometryTools/DZGeometryTools.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YHLocation.h"
#import "YHLocationCellElement.h"
#import "DZImageCache.h"
#import "DZAlertPool.h"
@interface YHSelectAddressViewController () <MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView* _mapView;
    MAPinAnnotationView* newAnnotation;
    AMapSearchAPI* _searchAPI;
    AMapReGeocodeSearchRequest* _geoSearchAPI;
    BOOL _isFirst;
}
@property (nonatomic, strong) UIButton* mapPin;
@end

@implementation YHSelectAddressViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return self;
    }
    self.hidesBottomBarWhenPushed = YES;
    return self;
}
#pragma mark 初始化地图，定位
-(void)initLocationService
{
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    [_mapView bringSubviewToFront:_mapPin];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = MAUserTrackingModeFollow;//设置定位的状态
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (_isFirst) {
        MACoordinateSpan span = {0.05, 0.05};
        MACoordinateRegion region = MACoordinateRegionMake(userLocation.location.coordinate, span);
        [_mapView setCenterCoordinate:userLocation.location.coordinate];
        _isFirst = NO;
        [self searchPOI:userLocation.location.coordinate];
        [_mapView setRegion:region];
    }
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    _isFirst = YES;
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    UITableView* tableView = [_tableElement createResponser];
    self.tableView = tableView;
    _mapView = [MAMapView new];
    _mapPin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapPin setImage:DZCachedImageByName(@"serach_Map") forState:UIControlStateNormal];
    

    [self.view addSubview:_mapView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:_mapPin];
    [self initLocationService];
    self.title = @"选择地址";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _mapView.showsUserLocation = YES;//显示定位图层

}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat mapHeight = CGRectGetHeight(self.view.bounds)/2;
    CGRect mapRect;
    CGRect tableRect;
    
    CGRectDivide(self.view.bounds, &mapRect, &tableRect, mapHeight, CGRectMinYEdge);
    _mapView.frame = mapRect;
    self.tableView.frame = tableRect;
    
    CGSize size= CGSizeMake(40, 40);
    
    CGRect pinRect = CGRectCenter(mapRect, size);
    _mapPin.frame = CGRectOffset(pinRect, 0, -15);
    
}
#pragma mark BMKLocationServiceDelegate

- (void) mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void) searchPOI:(CLLocationCoordinate2D)MapCoordinate
{
    //屏幕坐标转地图经纬度
    
    if (_geoSearchAPI==nil) {
        _geoSearchAPI = [[AMapReGeocodeSearchRequest alloc] init];
    }
    _geoSearchAPI.location = [AMapGeoPoint locationWithLatitude:MapCoordinate.latitude longitude:MapCoordinate.longitude];
    _geoSearchAPI.radius = 10000;
    _geoSearchAPI.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:_geoSearchAPI];
    DZAlertShowLoading(@"努力搜索中....");
}
- (void) mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    [self searchPOI:MapCoordinate];

}


#pragma mark BMKGeoCodeSearchDelegate

- (void) onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil) {
       
        NSMutableArray* array = [NSMutableArray new];
        
        for (AMapAOI* aoi in response.regeocode.aois) {
            YHLocation* location = [[YHLocation alloc] init];
            location.name = aoi.name;
            location.latitude = aoi.location.latitude;
            location.longtitude = aoi.location.longitude;
            YHLocationCellElement* ele = [[YHLocationCellElement alloc] initWithLocation:location];
            [array addObject:ele];
        }
        
        for (AMapRoad* road in response.regeocode.roads) {
            YHLocation* location = [[YHLocation alloc] init];
            location.name = road.name;
            location.latitude = road.location.latitude;
            location.longtitude = road.location.longitude;
            YHLocationCellElement* ele = [[YHLocationCellElement alloc] initWithLocation:location];
            [array addObject:ele];
        }
        
        for (AMapPOI* poi in response.regeocode.pois) {
            YHLocation* location = [[YHLocation alloc] init];
            location.name = poi.name;
            location.latitude = poi.location.latitude;
            location.longtitude = poi.location.longitude;
            YHLocationCellElement* ele = [[YHLocationCellElement alloc] initWithLocation:location];
            [array addObject:ele];
        }
        
        [_tableElement.dataController clean];
        [_tableElement.dataController updateObjects:array];
        [self.tableView reloadData];
    }else{
        
    }
    DZAlertHideLoading;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DZAlertHideLoading;
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
@end
