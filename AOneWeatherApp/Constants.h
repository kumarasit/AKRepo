//
//  Constants.h
//  AOneWeatherApp
//
//  Created by Asit Kumar Mohanty on 13/10/15.
//  Copyright © 2015 Asit Kumar Mohanty. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#define kWEATHER_FORECAST_API_URL @"http://api.openweathermap.org/data/2.5/forecast?q=%@&appid=%@&units=metric&cnt=5"

#define kCURRENT_WEARHER_API_URL @"http://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"

#define kWeatherForecastClouds @"Clouds"
#define kWeatherForecastClear @"Clear"
#define kWeatherForecastRain @"Rain"
#define kWeatherForecastFog @"Fog"
#define kWeatherForecastSnow @"Snow"
#define kWeatherForecastStorm @"Storm"

//Main Screen Dimension
#define kMainScreenBounds [UIScreen mainScreen].bounds
#define kMainScreenSize [UIScreen mainScreen].bounds.size
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define kAPP_ID @"bd82977b86bf27fb59a04b61b657fb6f"

#define kCellIdentifier @"cell"

#endif /* Constants_h */
