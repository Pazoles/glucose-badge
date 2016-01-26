//
//  xDripG5Receiver.swift
//  glucose-badge
//
//  Created by Dennis Gove on 1/21/16.
//  Copyright © 2016 gove. All rights reserved.
//

import Foundation
import CoreBluetooth
import xDripG5

class xDripG5Receiver: NSObject, Receiver, TransmitterDelegate {

    private var transmitter: Transmitter!
    private var notifier: ReceiverNotificationDelegate?

    internal init(transmitterId: String) {
        super.init()
        
        transmitter = Transmitter(
            ID: transmitterId,
            startTimeInterval: nil,
            passiveModeEnabled: true
        )
        transmitter?.stayConnected = true
        transmitter?.delegate = self
    }

    var readingNotifier: ReceiverNotificationDelegate? {
        get{ return self.notifier }
        set{ self.notifier = newValue }
    }

    func connect() -> Bool {
        transmitter.resumeScanning()
        return true
    }

    func disconnect() -> Bool {
        transmitter.stopScanning()
        return true
    }

    func transmitter(transmitter: Transmitter, didReadGlucose glucose: GlucoseRxMessage){
        if(nil != notifier){
            let reading = Reading(value:glucose.glucose, timestamp:NSDate())
            notifier!.receiver(self, didReceiveReading: reading)
        }
    }

    func transmitter(transmitter: Transmitter, didError error: ErrorType){
        if(nil != notifier){
            notifier!.receiver(self, didExperienceError: error)
        }
    }
}