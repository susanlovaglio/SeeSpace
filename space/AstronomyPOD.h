//
//  EarthImages.h
//  Inspired By
//
//  Created by Susan on 4/1/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AstronomyPOD : NSObject
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *imageTitle;
@property (nonatomic, strong) NSString *imageExplanation;

+(AstronomyPOD *) imagesFromDictionary: (NSDictionary *) dictionary;

@end
