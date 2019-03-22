//
//  ViewController.swift
//  Purga Time
//
//  Created by L Daniel De San Pedro on 3/22/19.
//  Copyright © 2019 L Daniel De San Pedro. All rights reserved.
//

import UIKit
import CircleProgressView

class ViewController: UIViewController {

    lazy var purgeProgress : CircleProgressView = {
        let view = CircleProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = .clear
        if self.currentMode! == .countingMinutes{
            
            view.trackFillColor = .red
            
        }
        
    
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Purge Timer!!! 🤙"
        label.textAlignment = .center
        return label
        
    }()
    
    lazy var remainingTimeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        let units = self.currentMode == .countingMinutes ? "Minutos" : "Horas"
        let sentence = self.currentMode == .countingMinutes ? "Quedan " : "Faltan "
        label.text = sentence + "\(Int(self.remaining)) " + units
        return label
    }()
    
    var percentage : Double!
    var remaining : Double!
    enum Mode{
        case countingHours
        case countingMinutes
    }
    var currentMode : Mode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        let hourString = formatter.string(from: Date())
        
        guard let hourInt = Double(hourString) else {return}
    
        if hourInt == 11.0{
            self.currentMode = .countingMinutes
            formatter.dateFormat = "mm"
            let minuteString = formatter.string(from: Date())
            guard let minutes = Double(minuteString) else {return}
            self.remaining = 60.0 - minutes
            self.percentage = 1 - (remaining / 60)
            
            
        } else if hourInt == 12.0 {
            self.currentMode = .countingHours
            self.remaining = 11
            self.percentage = 1 - Double(remaining / 12.0)
        }
        else {
            self.currentMode = .countingHours
            self.remaining = 11.0 - hourInt
            self.percentage = 1 - Double(remaining / 12.0)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(purgeProgress)
        self.view.addSubview(titleLabel)
        self.view.addSubview(remainingTimeLabel)
        purgeProgress.centerAxisWithSizes(width: 300, height: 300, centerXTo: self.view.centerXAnchor, centerYTo: self.view.centerYAnchor)
        remainingTimeLabel.centerAxis(centerXto: self.view.centerXAnchor, centerYto: nil)
        remainingTimeLabel.setConstraintsToBordersAndSizes(topAnchor: nil, bottomAnchor: self.view.bottomAnchor, leftAnchor: nil, rightAnchor: nil, width: 200, height: 30, padding: UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0))
        
        titleLabel.centerAxis(centerXto: self.view.centerXAnchor, centerYto: nil)
        titleLabel.setConstraintsToBordersAndSizes(topAnchor: nil, bottomAnchor: self.purgeProgress.contentView.bottomAnchor, leftAnchor: nil, rightAnchor: nil, width: 200, height:30,padding: UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0))
    }
    override func viewDidLayoutSubviews() {
        
        self.purgeProgress.setProgress(percentage, animated: true)
    }


}

