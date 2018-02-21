//
//  ViewController.swift
//  MNISTClassifier
//
//  Created by yusuf_kildan on 20.02.2018.
//  Copyright © 2018 yusuf_kildan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var drawView: DrawView!

    lazy var request: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MNISTClassifier().model)
            
            return VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
        } catch {
            fatalError("Can't load Vision ML model: \(error).")
        }
    }()
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Handle Classification
    
    func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation] else {
            fatalError("Unexpected result type from VNCoreMLRequest.")
        }
        
        print(observations)
        
        guard let best = observations.first else {
            fatalError("Can't get best result.")
        }
        
        DispatchQueue.main.async {
            self.resultLabel.text = best.identifier
        }
    }

    // MARK: - Actions
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        drawView.lines = []
        drawView.setNeedsDisplay()
        resultLabel.text = ""
    }
    
    @IBAction func predictButtonTapped(_ sender: UIButton) {
        guard let context = drawView.getViewContext(), let inputImage = context.makeImage() else {
            fatalError("Get context or make image failed.")
        }

        let ciImage = CIImage(cgImage: inputImage)
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

