//
//  EarthImages.m
//  Inspired By
//
//  Created by Susan on 4/1/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "AstronomyPOD.h"

@implementation AstronomyPOD

+(AstronomyPOD *)imagesFromDictionary:(NSDictionary *)dictionary{
    
    AstronomyPOD *image = [[AstronomyPOD alloc]init];
    
    image.imageURL = [NSURL URLWithString:dictionary[@"hdurl"]];
    image.imageTitle = dictionary[@"title"];
    image.imageExplanation = dictionary[@"explanation"];
    
    return image;
}

@end
