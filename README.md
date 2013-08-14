beacons-demo
============

Simple demo apps to simulate Apple iOS7 iBeacon feature on iOS6 devices.

In order to make the Broadcaster and Receiver apps communicate smothly you should generate your own BLE service and characteristic UUIDs:

+ open Terminal app, run «uuidgen» to generate a UUID
+ assign the UUID value to SERVICE_UUID in BluetoothServices.h in *both* projects
+ run «uuidgen» once again to get a new UUID
+ assign the new UUID value to CHARACTERISTIC_UUID in BluetoothServices.h in *both* projects
