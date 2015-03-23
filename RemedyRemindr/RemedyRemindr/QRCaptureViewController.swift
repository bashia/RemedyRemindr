//
//  QRCaptureViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-03-18.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit
import AVFoundation

class QRCaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "Please focus on a QR code"
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        //captureSession.
        
        captureSession?.addInput(input as AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        setOrientation(view.layer.bounds.size)
        
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        setOrientation(size)
    }
    
    /*
     * Sets the screen orientation of the video capture
     */
    func setOrientation(size: CGSize) {
        if (videoPreviewLayer?.connection.supportsVideoOrientation == true) {
            let deviceOrientation: UIDeviceOrientation  = UIDevice.currentDevice().orientation
            
            
            var newOrientation: AVCaptureVideoOrientation
            
            if (deviceOrientation == UIDeviceOrientation.Portrait){
                newOrientation = AVCaptureVideoOrientation.Portrait;
            }
            else if (deviceOrientation == UIDeviceOrientation.PortraitUpsideDown){
                newOrientation = AVCaptureVideoOrientation.PortraitUpsideDown;
            }
            else if (deviceOrientation == UIDeviceOrientation.LandscapeLeft){
                newOrientation = AVCaptureVideoOrientation.LandscapeRight;
            }
            else if (deviceOrientation == UIDeviceOrientation.LandscapeRight){
                newOrientation = AVCaptureVideoOrientation.LandscapeLeft;
            }
                
            else if (deviceOrientation == UIDeviceOrientation.Unknown){
                newOrientation = AVCaptureVideoOrientation.Portrait;
            }
                
            else{
                newOrientation = AVCaptureVideoOrientation.Portrait;
            }
            
            videoPreviewLayer?.connection.videoOrientation = newOrientation
            
            videoPreviewLayer?.frame = CGRectMake(view.layer.bounds.origin.x, view.layer.bounds.origin.y , size.width, size.height)
        }
    }
    
    func addMedicationConfirmed(newMed: Medication, sender: AnyObject) {
     
        if let insertMed = MedicationDAO.insertMedication(newMed) {
            
            if insertMed {
                captureSession?.stopRunning()
                
                // This is kinda dumb to have to do this. Might what to fix the way the DAO handles dupicate reminders
                var reminders = [Reminder](newMed.reminders)
                newMed.reminders = []
                
                for reminder in reminders
                {
                    if let insertRem = MedicationDAO.insertReminder(newMed, reminder: reminder) {
                        if insertRem {
                            NotificationManager.getInstance.scheduleReminder(newMed, reminder: reminder)
                        }
                        else {
                            var alert : UIAlertView = UIAlertView(title: "Duplicate Reminder", message: "A reminder already exists with the same date and time settings. Please go back and change some settings.", delegate: nil, cancelButtonTitle: "OK")
                            alert.show()
                        }
                    } else {
                        var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred, please try again.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                
                performSegueWithIdentifier("AddMedFromQR", sender: sender)
            }
            else {
                newAlert("Medication Already Exists", "A medication with name " + newMed.name + " has already been added, please choose another name.")
            }
            
        } else {
            newAlert("Unexpected Error", "An unexpected error has occurred, please try again.")
        }
    }
    
    func resumeCapture() {
        captureSession?.startRunning()
        qrCodeFrameView?.frame = CGRectZero
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                
                let json = JSON(data: (metadataObj.stringValue as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
                
                var invalidQRAlert = UIAlertController(title: "Invalid QR Code", message: "The scanned QR was not a valid medication.", preferredStyle: UIAlertControllerStyle.Alert)
                
                invalidQRAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.resumeCapture()
                }))

                
                // Check name
                let name = json["medication"]["name"].stringValue
                if countElements(name) < 1 {
                    presentViewController(invalidQRAlert, animated: true, completion: nil)
                    return
                }
                
                if countElements(name) > 128 {
                    presentViewController(invalidQRAlert, animated: true, completion: nil)
                    return
                }
                
                if !checkValidCharacters(name) {
                    presentViewController(invalidQRAlert, animated: true, completion: nil)
                    return
                }
                
                var medication : Medication = Medication(name: name)
                
                // Check the reminder count
                if let remCount = json["medication"]["remCount"].stringValue.toInt()
                {
                    for(var i = 0; i < remCount; i++)
                    {
                        var reminder = Reminder()
                        
                        
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        // Check start date
                        if let startDate = dateFormatter.dateFromString(json["medication"]["reminders"][i]["startDate"].stringValue) {
                            reminder.setStartDate(startDate)
                        
                        }
                        else {
                            presentViewController(invalidQRAlert, animated: true, completion: nil)
                            return
                        }
                        
                        // Check end date
                        if let endDate = dateFormatter.dateFromString(json["medication"]["reminders"][i]["endDate"].stringValue) {
                            if endDate.compare(reminder.getStartDate())  == .OrderedAscending || reminder.getStartDate().compare(endDate)  == .OrderedSame {
                                presentViewController(invalidQRAlert, animated: true, completion: nil)
                                return
                            }
                            else
                            {
                                reminder.setEndDate(endDate)
                            }
                        }
                        else {
                            presentViewController(invalidQRAlert, animated: true, completion: nil)
                            return
                        }
                        
                        // Check repeat
                        if let repeat = Repeat(rawValue: json["medication"]["reminders"][i]["repeat"].stringValue) {
                            reminder.setRepeat(repeat)
                        }
                        else
                        {
                            presentViewController(invalidQRAlert, animated: true, completion: nil)
                            return
                        }
                        
                        // Check days
                        if let days = json["medication"]["reminders"][i]["days"].stringValue.toInt() {
                            reminder.setDays(Int16(days))
                        }
                        else
                        {
                            if reminder.getRepeat() != .NO {
                                presentViewController(invalidQRAlert, animated: true, completion: nil)
                                return
                            }
                            else
                            {
                                reminder.setDays(0)
                            }
                        }
                        
                        // Check time count
                        var times:[Int16] = []
                        
                        if let timesCount = json["medication"]["reminders"][i]["timesCount"].stringValue.toInt()
                        {
                            
                            if timesCount > 0 {
                                
                                for(var j = 0; j < timesCount; j++) {
                                    
                                    // Check time
                                    if let time = json["medication"]["reminders"][i]["times"][j]["time"].stringValue.toInt() {
                                        if time < 0 || time >= 1440 { // Maximum minutes from midnight
                                            presentViewController(invalidQRAlert, animated: true, completion: nil)
                                            return
                                        }
                                        else
                                        {
                                            times.append(Int16(time))
                                        }
                                    }
                                    else
                                    {
                                        presentViewController(invalidQRAlert, animated: true, completion: nil)
                                        return
                                    }
                                }
                                
                                reminder.setTimes(times)
                            }
                            else
                            {
                                presentViewController(invalidQRAlert, animated: true, completion: nil)
                                return
                            
                            }
                        }
                        else
                        {
                            presentViewController(invalidQRAlert, animated: true, completion: nil)
                            return
                        }
                        
                        // Do notes
                        let notes: String = json["medication"]["reminders"][i]["notes"].stringValue
                        reminder.setNotes(notes)
                        
                        medication.reminders.append(reminder)
                    }
                }
                else
                {
                    presentViewController(invalidQRAlert, animated: true, completion: nil)
                    return
                }
                

                var addConfirmationAlert = UIAlertController(title: "QR Code Detected", message: "Would you like to add the medication " + json["medication"]["name"].stringValue + "?", preferredStyle: UIAlertControllerStyle.Alert)
                
                addConfirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.addMedicationConfirmed(medication, sender: self)
                    self.resumeCapture()
                }))
                
                addConfirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    self.resumeCapture()
                }))
                
                presentViewController(addConfirmationAlert, animated: true, completion: nil)
            }
        }
    }
}
