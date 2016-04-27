//
//  EarthApiClient.m
//  Inspired By
//
//  Created by Susan on 4/1/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "NasaApiClient.h"
#import "Constants.h"

@implementation NasaApiClient

NSString *const NASA_API_URL = @"https://api.nasa.gov/planetary/apod?api_key=";

-(void)imagesFromApiWithCompletionBlock:(void (^)(NSDictionary *))completionBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", NASA_API_URL, NASA_KEY];
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest: request completionHandler:^(NSData *data,
                                                                                   NSURLResponse *response,
                                                                                   NSError *error) {
    
        NSDictionary *images = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        completionBlock(images);
    }];
    [task resume];
}

@end
