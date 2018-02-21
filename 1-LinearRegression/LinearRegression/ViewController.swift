//
//  ViewController.swift
//  LinearRegression
//
//  Created by yusuf_kildan on 20.02.2018.
//  Copyright © 2018 yusuf_kildan. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    @IBOutlet private var tvSlider: UISlider!
    @IBOutlet private var radioSlider: UISlider!
    @IBOutlet private var newspaperSlider: UISlider!
    @IBOutlet private var tvLabel: UILabel!
    @IBOutlet private var radioLabel: UILabel!
    @IBOutlet private var newspaperLabel: UILabel!
    @IBOutlet private var salesLabel: UILabel!
    private let numberFormatter = NumberFormatter()
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        sliderValueChanged()
    }
    
    // MARK: - Actions
    
    @IBAction func sliderValueChanged(_ sender: UISlider? = nil) {
        let tv = Double(tvSlider.value)
        let radio = Double(radioSlider.value)
        let newspaper = Double(newspaperSlider.value)
        
        let advertising = Advertising()
        let input = AdvertisingInput(tv: tv, radio: radio, newspaper: newspaper)
        
        guard let output = try? advertising.prediction(input: input) else {
            return
        }
        
        let sales = output.sales
        
        tvLabel.text = numberFormatter.string(from: tv as NSNumber)
        radioLabel.text = numberFormatter.string(from: radio as NSNumber)
        newspaperLabel.text = numberFormatter.string(from: newspaper as NSNumber)
        salesLabel.text = numberFormatter.string(from: sales as NSNumber)
    }
}

