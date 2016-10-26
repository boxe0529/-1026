//
//  ViewController.m
//  地图导航线
//
//  Created by Apple on 16/10/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic,strong) CLGeocoder * geocoder;
@end

@implementation ViewController

-(CLGeocoder *)geocoder//创建编码
{
    if (_geocoder == nil){
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(void)PredrawLine
{
    [self.geocoder geocodeAddressString:@"北京" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * bjplacemark = [placemarks firstObject];//地理标注
        MKPlacemark * bjmkplacemark = [[MKPlacemark alloc]initWithPlacemark:bjplacemark];//地图标注
   
    
    [self.geocoder geocodeAddressString:@"济南" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *jnplacemark = [placemarks firstObject];
        MKPlacemark * jnmkplacemark = [[MKPlacemark alloc]initWithPlacemark:jnplacemark];
        
        
        [self drawLineWith:bjmkplacemark to:jnmkplacemark];
    }];
    }];
}

-(void)drawLineWith:(MKPlacemark *)bjmkplacemark to:(MKPlacemark *)jnmkplacemark
{
    MKMapItem * bjItem = [[MKMapItem alloc]initWithPlacemark:bjmkplacemark];
    MKMapItem * jnItem = [[MKMapItem alloc]initWithPlacemark:jnmkplacemark];//地图向
    
    MKDirectionsRequest * request = [[MKDirectionsRequest alloc]init];//方向请求
    request.source = bjItem;
    request.destination = jnItem;
    MKDirections * directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
       if (error!=nil)
       {
           NSLog(@"%@",error.localizedDescription);
           return ;
       }
        //遍历所有线路
        for (MKRoute * route in response.routes)
        {
            MKPolyline * lin = route.polyline;
            [self.map addOverlay:lin];
        }
        
    }];
}

#pragma mark mapviewDelegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    //创建线路的渲染器
    MKPolylineRenderer * render = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    render.lineWidth = 1;
    render.strokeColor = [UIColor redColor];
    return render;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.delegate = self;
    [self geocoder];
    [self PredrawLine];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
