//
//  ViewController.swift
//  3-RealTimeObjectDetection
//
//  Created by yusuf_kildan on 2.03.2018.
//  Copyright © 2018 yusuf_kildan. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            captureSession.startRunning()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            view.layer.addSublayer(previewLayer)
            previewLayer.frame = view.bounds
            
            view.layer.sublayers?.append(resultLabel.layer)
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "queue"))
            captureSession.addOutput(dataOutput)
        } catch {
            print(error)
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // Download Resnet50 model from this website and add to project! : https://developer.apple.com/machine-learning/
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation],
                let result = results.first else {
                return
            }
            
            DispatchQueue.main.async {
                self.resultLabel.text = "\(result.identifier)"
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
