//
//  CBUUID+StringExtraction.h
//  Receiver
//
//  Created by Ishaan Gulrajani on 9/7/13.
//  Copyright (c) 2013 Estimote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CBUUID (StringExtraction)

- (NSString *)representativeString;

@end