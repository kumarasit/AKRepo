//
//  ViewController.m
//  AOneWeatherApp
//
//  Created by Asit Kumar Mohanty on 07/10/15.
//  Copyright © 2015 Asit Kumar Mohanty. All rights reserved.
//

#import "ShowCurrentWeatherVC.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ShowCurrentWeatherVC ()

@end

@implementation ShowCurrentWeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"stored_cur_weather_response"]== nil && [userDefaults objectForKey:@"weather_forecast_arr"]==nil)
    {
        [self getWeatherDataForLocation:@"banglore"];
    }
    else
    {
        currentWeatherResponseDict = [userDefaults objectForKey:@"stored_cur_weather_response"];
        
        weatherHourForecastArr = [userDefaults objectForKey:@"weather_forecast_arr"];
        
        [self setupPageUI];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [weatherHourForecastArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    UIImageView *cellHourWeatherImgView = (UIImageView *)[cell viewWithTag:201];
    
    NSString *weatherType = [[[[weatherHourForecastArr objectAtIndex:indexPath.row]objectForKey:@"weather"]objectAtIndex:0]objectForKey:@"main"];
    
    NSString *imgStr = [self getImageNameAsDescription:weatherType];
    
    cellHourWeatherImgView.image = [UIImage imageNamed:imgStr];
    
    
    
    UILabel *cellHourlyTempForecastLabel = (UILabel *)[cell viewWithTag:202];
    
    int tempInCelcius = round([[[[weatherHourForecastArr objectAtIndex:indexPath.row]objectForKey:@"main"]objectForKey:@"temp"]doubleValue]);
    
    NSString *tempString = [NSString stringWithFormat:@"%d%@",tempInCelcius,@"\u00B0"];
    
    cellHourlyTempForecastLabel.text = tempString;
    
    
    UILabel *weatherTypeLabel = (UILabel *)[cell viewWithTag:204];
    weatherTypeLabel.text = weatherType;
    
    UILabel *cellTimeForecastLabel = (UILabel *)[cell viewWithTag:203];
    
    NSString *timeText = [[weatherHourForecastArr objectAtIndex:indexPath.row]objectForKey:@"dt_txt"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:timeText];
    
    [dateFormatter setDateFormat:@"EEE hh:mm a"];
    
    timeText = [dateFormatter stringFromDate:date];
    
    cellTimeForecastLabel.text = timeText;
    
    return cell;
}


- (IBAction)tabbarRefreshBtnTapped:(id)sender {
    
    [self getWeatherDataForLocation:@"banglore"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self getWeatherDataForLocation:@"banglore"];
        
    } else {
        
        if(currentWeatherResponseDict == nil)
        {
            exit(1);
        }
    }
}

#pragma mark ---
#pragma mark Api_Call_Methods

-(void)getWeatherDataForLocation:(NSString *)cityName
{
    NSString *urlString = [NSString stringWithFormat:kCURRENT_WEARHER_API_URL,cityName,kAPP_ID];
   
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.timeoutInterval = 30.0f;
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.activityIndicator startAnimating];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self getWeatherHourlyForecastData:cityName];
        
        [self.activityIndicator stopAnimating];
        
        currentWeatherResponseDict = [[NSMutableDictionary alloc]init];
        
        [currentWeatherResponseDict setDictionary:responseObject];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setValue:currentWeatherResponseDict forKey:@"stored_cur_weather_response"];
        
        [userDefaults synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"OOPS !!" message:@"Error Occured Fetching Current Weather Data. May be No Connectivity." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel",nil];
        errorAlert.tag = 101;
        [errorAlert show];
    }];
    
    [requestOperation start];
}

-(void)getWeatherHourlyForecastData:(NSString *)cityName
{
    NSString *urlString = [NSString stringWithFormat:kWEATHER_FORECAST_API_URL,cityName,kAPP_ID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.timeoutInterval = 30.0f;
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.activityIndicator startAnimating];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.activityIndicator stopAnimating];
        
        weatherForecastResponseDict = [[NSMutableDictionary alloc]init];
        
        [weatherForecastResponseDict setDictionary:responseObject];
        
        weatherHourForecastArr = [[NSMutableArray alloc]init];
        
        [weatherHourForecastArr setArray:[weatherForecastResponseDict objectForKey:@"list"]];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:weatherHourForecastArr forKey:@"weather_forecast_arr"];
        
        [userDefaults synchronize];
        
        [self.hourlyForecastTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"OOPS !!" message:@"Error Occured Fetching Weather Forecast Data. May be No Connectivity." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel",nil];
        
        errorAlert.tag = 102;
        
        [errorAlert show];
    }];
    
    [requestOperation start];
}


#pragma mark ---
#pragma mark Methods

-(void)setupPageUI
{
    int tempInCelcius = round([[[currentWeatherResponseDict objectForKey:@"main"]objectForKey:@"temp"]doubleValue]);
    
    NSString *tempString = [NSString stringWithFormat:@"%d%@",tempInCelcius,@"\u00B0"];
    
    self.tempLabel.text =tempString;
    
    NSString *curWeatherType = [[[currentWeatherResponseDict objectForKey:@"weather"]objectAtIndex:0]objectForKey:@"main"];
    
    //Set Weather Image.
    
    NSString *imgStr = [self getImageNameAsDescription:curWeatherType];
    
    [self.weatherImgView setImage:[UIImage imageNamed:imgStr]];
    
    
    //Setting up Max & Min temp Labels.
    int minTemp = round([[[currentWeatherResponseDict objectForKey:@"main"]objectForKey:@"temp_min"]doubleValue]);
    
    int maxTemp = round([[[currentWeatherResponseDict objectForKey:@"main"]objectForKey:@"temp_max"]doubleValue]);
    
    NSString *minTempString = [NSString stringWithFormat:@"Min: %d%@",minTemp,@"\u00B0"];
    
    NSString *maxTempString = [NSString stringWithFormat:@"Max: %d%@",maxTemp,@"\u00B0"];
    
    self.minTempLabel.text = minTempString;
    self.maxTempLabel.text = maxTempString;
    
    
    //Setting up humidity & windspeed Label.
    int humidity = round([[[currentWeatherResponseDict objectForKey:@"main"]objectForKey:@"humidity"]doubleValue]);
    
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity : %d%%",humidity];
    
    double windSpeed = [[[currentWeatherResponseDict objectForKey:@"wind"]objectForKey:@"speed"]doubleValue];
    
    NSString *windSpeedString = [NSString stringWithFormat:@"W.Speed : %.2f Km/h",windSpeed];
    
    self.windSpeedLabel.text = windSpeedString;
}

-(NSString *)getImageNameAsDescription:(NSString *)weatherDesc
{
    NSString *imgStr = nil;
    
    if([weatherDesc isEqualToString:kWeatherForecastClear])
    {
        imgStr = @"ClearSun.png";
    }
    else if ([weatherDesc isEqualToString:kWeatherForecastClouds])
    {
        imgStr = @"partly_cloudy.png";
    }
    else if ([weatherDesc isEqualToString:kWeatherForecastRain])
    {
        imgStr = @"rainy.png";
    }
    else if ([weatherDesc isEqualToString:kWeatherForecastFog])
    {
        
    }
    else if ([weatherDesc isEqualToString:kWeatherForecastSnow])
    {
        
    }
    
    return imgStr;
}

@end
