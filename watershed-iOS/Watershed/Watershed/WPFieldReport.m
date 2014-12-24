//
//  WPFieldReport.m
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReport.h"

@implementation WPFieldReport

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fieldReportId" : @"id",
             @"info" : @"description",
             @"rating" : @"health_rating",
             @"creationDate" : @"created_at"
             };
}

+ (NSValueTransformer *)creationDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    return dateFormatter;
}

- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *date = [dateFormatter stringFromDate:self.creationDate];
    
    return date;
}

- (NSMutableArray *)imageURLs {
    if (!_imageURLs) {
        _imageURLs = [[NSMutableArray alloc] init];
    }
    return _imageURLs;
}

@end
