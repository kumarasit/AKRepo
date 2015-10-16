//
//  ViewController.h
//  AOneWeatherApp
//
//  Created by Asit Kumar Mohanty on 07/10/15.
//  Copyright © 2015 Asit Kumar Mohanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowCurrentWeatherVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    NSMutableDictionary *currentWeatherResponseDict;
    
    NSMutableDictionary *weatherForecastResponseDict;
    
    NSMutableArray *weatherHourForecastArr;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;

@property (weak, nonatomic) IBOutlet UITableView *hourlyForecastTableView;


@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImgView;

@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabbarRefreshBtn;

@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabbarBackBtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


#pragma mark ---
#pragma mark API_CALL_METHODS
-(void)getWeatherDataForLocation:(NSString *)cityName;
-(void)getWeatherHourlyForecastData:(NSString *)cityName;

-(void)setupPageUI;

-(NSString *)getImageNameAsDescription:(NSString *)weatherDesc;

@end

