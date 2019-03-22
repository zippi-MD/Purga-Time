//
//  ViewController.swift
//  Purga Time
//
//  Created by L Daniel De San Pedro on 3/22/19.
//  Copyright © 2019 L Daniel De San Pedro. All rights reserved.
//

import UIKit
import CircleProgressView
import UserNotifications

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
    
    let center = UNUserNotificationCenter.current()
    
    let defaults = UserDefaults.standard
    
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
        
        
        
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: ({ (granted, error) in
            if(granted){
                if !self.defaults.bool(forKey: "Notifications") {
                    self.scheduleNotifications()
                }
            }
            else {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Por favor activa las notificaciones", preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
                
            }
        }))
        
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
    
    func scheduleNotifications(){
        
        defaults.set(true, forKey: "Notifications")
        
        let content = UNMutableNotificationContent()
        content.title = "Purga-Inicio"
        content.body =
        """
            Esto no es un simulacro.
            Este es su sistema de alerta anunciando el inicio de La Purga Diaria.
            Bullying de clase 4 o menos serán autorizadas para usarse durante La Purga. Otras clases de bullying están restringidas.
            Al sonar la sirena, todo bullying, incluído el uso de apodos, será legal por una hora continua. Policía, bomberos y servicios de emergencia estarán desactivados hasta después de 1 horas cuando La Purga concluya.
            El iOS Development Lab les agradece su participación
            Un nuevo laboratorio está surgiendo.
            Que Dios esté con todos ustedes.
        
        """
        content.sound = UNNotificationSound.default
        
        var morningDateComponents = DateComponents()
        morningDateComponents.hour = 11
        morningDateComponents.minute = 0
        
        let trigger_morning = UNCalendarNotificationTrigger(dateMatching: morningDateComponents, repeats: true)
        
        let request_morning = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger_morning)
        
        center.add(request_morning)
        
        
        var nightDateComponents = DateComponents()
        nightDateComponents.hour = 23
        nightDateComponents.minute = 0
        
        let trigger_night = UNCalendarNotificationTrigger(dateMatching: nightDateComponents, repeats: true)
        let request_night = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger_night)
        
        center.add(request_night)
        
        

    }


}

