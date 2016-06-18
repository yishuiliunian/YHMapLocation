//
//  YHSelectAddressViewController.m
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSelectAddressViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <DZGeometryTools/DZGeometryTools.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "YHLocation.h"
#import "YHLocationCellElement.h"
#import "DZImageCache.h"
@interface YHSelectAddressViewController () <BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;
    BMKPinAnnotationView *newAnnotation;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    BMKLocationService *_locService;
}
@property (nonatomic, strong) UIButton* mapPin;
@end

@implementation YHSelectAddressViewController

#pragma mark 初始化地图，定位
-(void)initLocationService
{
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    [_mapView bringSubviewToFront:_mapPin];
    if (_locService==nil) {
        _locService = [[BMKLocationService alloc]init];
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
- (void) loadView
{
    self.view =[UIView new];
}
- (void) viewDidLoad
{
    UITableView* tableView = [_tableElement createResponser];
    self.tableView = tableView;
    _mapView = [BMKMapView new];
    _mapPin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapPin setImage:DZCachedImageByName(@"serach_Map") forState:UIControlStateNormal];
    

    [self.view addSubview:_mapView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:_mapPin];
    [self initLocationService];
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
    _mapPin.frame = CGRectCenter(mapRect, size);
}
#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
        
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        NSMutableArray* array = [NSMutableArray new];
        for (BMKPoiInfo* info  in result.poiList) {
            YHLocation* location = [[YHLocation alloc] init];
            location.name = info.name;
            location.latitude = info.pt.latitude;
            location.longtitude = info.pt.longitude;
            
            
            YHLocationCellElement* ele = [[YHLocationCellElement alloc] initWithLocation:location];
            [array addObject:ele];
        }
        [_tableElement.dataController clean];
        [_tableElement.dataController updateObjects:array];
        [self.tableView reloadData];
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
}
@end
