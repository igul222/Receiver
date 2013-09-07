//
//  ViewController.m
//  Receiver
//
//  Created by Grzegorz Krukiewicz-Gacek on 8/1/13.
//  Copyright (c) 2013 Estimote, Inc. All rights reserved.
//

#import "ViewController.h"
#import "Broadcaster.h"
#import <socket.IO/SocketIO.h>

@interface ViewController () <CoreBluetoothDelegate, SocketIODelegate>

@property (nonatomic, strong) CoreBluetoothController *bluetoothController;
@property (nonatomic, strong) Broadcaster *broadcaster;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) SocketIO *socketIO;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"shrouded-harbor-6320.herokuapp.com" onPort:80];

    _bluetoothController = [CoreBluetoothController sharedInstance];
    _bluetoothController.delegate = self;
    /*if (!_bluetoothController.isConnected)
        [_bluetoothController findPeripherals];*/
    
    [_bluetoothController startReadingRSSI];
    
    _broadcaster = [[Broadcaster alloc] init];
    [_broadcaster startBroadcasting];
    
    [self switchValueChanged:_stationary];
}

- (void)didUpdateRSSI:(int)RSSI UUID:(NSString *)UUID {
    NSLog(@"RSSI: %i for UUID: %@", RSSI, UUID);
    
    [_socketIO sendEvent:@"updatePairwiseDistance" withData:@{@"d1": [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"d2": UUID, @"signal": @(RSSI)}];
}

- (IBAction)switchValueChanged:(id)sender {
    NSLog(@"Stationary: %i", [(UISwitch *)sender isOn]);
    
    [_socketIO sendEvent:@"updateStationaryDevice" withData:@{@"id": [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"stationary": @([(UISwitch *)sender isOn])}];
}


@end
