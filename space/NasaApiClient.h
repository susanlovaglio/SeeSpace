//
//  EarthApiClient.h
//  Inspired By
//
//  Created by Susan on 4/1/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NasaApiClient : NSObject

+(void)imagesFromApiWithCompletionBlock: (void (^)(NSDictionary *imageDictionaries))completionBlock;

@end
