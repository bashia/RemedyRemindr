//
//  QRCaptureViewController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-03-18.
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
    
    func addMedicationConfirmed(newMed: Medication, reminders: [Reminder], sender: AnyObject) -> Bool {
     
        if let insertMed = MedicationDAO.insertMedication(newMed) {
            
            if insertMed {
                
                for reminder in reminders
                {
                    if let insertRem = MedicationDAO.insertReminder(newMed, reminder: reminder) {
                        if !insertRem {
                            var alert : UIAlertView = UIAlertView(title: "Duplicate Reminder", message: "A reminder already exists with the same date and time settings. Please go back and change some settings.", delegate: nil, cancelButtonTitle: "OK")
                            alert.show()
                        }
                    } else {
                        var alert : UIAlertView = UIAlertView(title: "Unexpected Error", message: "An unexpected error has occurred, please try again.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                
                performSegueWithIdentifier("AddMedFromQR", sender: sender)
                return true
            }
            else {
                newAlert("Medication Already Exists", "A medication with name " + newMed.name + " has already been added, please choose another name.")
            }
            
        } else {
            newAlert("Unexpected Error", "An unexpected error has occurred, please try again.")
        }
        
        return false
    }
    
    func resumeCapture() {
        captureSession?.startRunning()
        qrCodeFrameView?.frame = CGRectZero
    }
    
    func qrJSONParse(rawJSON: String) -> Medication? {
        
        let json = JSON(data: (rawJSON as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // Check name
        let name = json["n"].stringValue
        if countElements(name) < 1 {
            return nil
        }
        
        if countElements(name) > 128 {
            print("error")
            return nil
        }
        
        if !checkValidCharacters(name) {
            return nil
        }
        
        var medication : Medication = Medication(name: name)
        var reminders : [Reminder] = []
        
        // Check the reminders. A medication can be added with no reminders
        for(var i = 0;; i++)
        {
            var reminder = Reminder()
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Check start date
            if let startDate = dateFormatter.dateFromString(json["r"][i]["s"].stringValue) {
                
                if startDate.compare(NSDate())  == .OrderedAscending {
                    reminder.setStartDate(NSDate())
                }
                else {
                    reminder.setStartDate(startDate)
                }
            }
            else {
                // If there are no more reminders then stop looking for more
                break
            }
            
            // Check repeat
            let repeat: String = json["r"][i]["r"].stringValue
            switch repeat {
            case "n":
                reminder.setRepeat(Repeat.NO)
            case "w":
                reminder.setRepeat(Repeat.YES_WEEKLY)
            case "c":
                reminder.setRepeat(Repeat.YES_CUSTOM)
            default:
                return nil
            }
            
            // Check end date
            if let endDate = dateFormatter.dateFromString(json["r"][i]["e"].stringValue) {
                
                // One time reminders do no have end dates
                if reminder.getRepeat() == .NO || endDate.compare(reminder.getStartDate())  == .OrderedAscending || reminder.getStartDate().compare(endDate)  == .OrderedSame {
                    return nil
                }
                else {
                    reminder.setEndDate(endDate)
                }
            }
                // If no enddate was specfied then the enddate should equal the startdate
            else {
                reminder.setEndDate(reminder.getStartDate())
            }
            
            // Check days
            if let days = json["r"][i]["d"].stringValue.toInt() {
                
                // One time reminders do not have a days field
                if reminder.getRepeat() == .YES_CUSTOM && Int16(days) < 1 || reminder.getRepeat() == .NO {
                    return nil
                }
                
                reminder.setDays(Int16(days))
            }
            else
            {
                // Any repeating reminder must have a days field
                if reminder.getRepeat() != .NO {
                    return nil
                }
                else
                {
                    reminder.setDays(0)
                }
            }
            
            // Check for times
            let timesAsStrings = split(json["r"][i]["t"].stringValue) {$0 == ","}
            var timesAsInts:[Int16] = []
            
            
            // There must be at least one valid time specified
            if timesAsStrings.count > 0 {
                for(var j = 0; j < timesAsStrings.count; j++) {
                    
                    // Check time
                    if let time = timesAsStrings[j].toInt() {
                        if time < 0 || time >= 1440 { // Maximum minutes from midnight
                            return nil
                        }
                        else
                        {
                            timesAsInts.append(Int16(time))
                        }
                    }
                    else
                    {
                        return nil
                    }
                }
            }
            else {
                return nil
            }
            
            reminder.setTimes(timesAsInts)
            
            // Do notes
            let notes: String = json["r"][i]["n"].stringValue
            reminder.setNotes(notes)
            
            reminders.append(reminder)
        }
        
        medication.reminders = reminders
        return medication
        
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
                
                var invalidQRAlert = UIAlertController(title: "Invalid QR Code", message: "The scanned QR was not a valid medication.", preferredStyle: UIAlertControllerStyle.Alert)
                
                invalidQRAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.resumeCapture()
                }))
                
                if let medication = qrJSONParse(metadataObj.stringValue) {
                    
                    let reminders = medication.reminders
                    medication.reminders = []
                    
                    var addConfirmationAlert = UIAlertController(title: "QR Code Detected", message: "Would you like to add the medication " + medication.name + "?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    addConfirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        if !self.addMedicationConfirmed(medication, reminders: reminders, sender: self)
                        {
                            self.resumeCapture()
                        }
                        
                    }))
                    
                    addConfirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                        self.resumeCapture()
                    }))
                    
                    presentViewController(addConfirmationAlert, animated: true, completion: nil)
                }
                else {
                    presentViewController(invalidQRAlert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
}
