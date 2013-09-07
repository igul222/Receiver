//
//  Broadcaster.m
//  Broadcaster
//
//  Created by Ishaan Gulrajani on 9/7/13.
//  Copyright (c) 2013 Estimote, Inc. All rights reserved.
//

#import "Broadcaster.h"

@interface Broadcaster () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (nonatomic, strong) NSMutableArray *centrals;

@end

@implementation Broadcaster

-(void)startBroadcasting {
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    _centrals = [NSMutableArray array];
}

-(void)stopBroadcasting {
    [self.peripheralManager stopAdvertising];
    self.peripheralManager = nil;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"PeripheralManager powered on.");
    
    NSString *characteristicUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:characteristicUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_UUID] primary:YES];
    
    transferService.characteristics = @[self.transferCharacteristic];
    
    [self.peripheralManager addService:transferService];
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:SERVICE_UUID]], CBAdvertisementDataLocalNameKey : @"EstimoteBeacon" }];
    
    NSLog(@"PeripheralManager is broadcasting (%@).", SERVICE_UUID);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    [_centrals addObject:central];
}

@end
