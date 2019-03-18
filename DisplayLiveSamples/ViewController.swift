//
//  ViewController.swift
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import UIKit
import Skafos
import AVFoundation

class ViewController: UIViewController {
    // set the name of the asset we want skafos to load
    private let assetName:String = "facefile"
    let sessionHandler = SessionHandler()
    
    @IBOutlet weak var preview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Skafos load cached model
        // OR Add- tag: "<your tag>" to load if you want the Skafos to make a network call for a model
        Skafos.load(asset: assetName) { (error, asset) in
            // Log the asset object in the console
            console.info(asset)
            guard error == nil else {
              console.error("Skafos load asset error: \(String(describing: error))")
                return
            }
            self.loadAsset(asset)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadModel(_:)), name: Skafos.Notifications.assetUpdateNotification(assetName), object: nil)
    }
    
    @objc func reloadModel(_ notification:Notification) {
        Skafos.load(asset: assetName) { (error, asset) in
            guard error == nil else {
              console.error("Skafos reload asset error: \(String(describing: error))")
                return
            }
            // loop through files in asset bundle
            self.loadAsset(asset)
        }
    }

  func loadAsset(_ asset:Asset) {
    for file in asset.files {
      // if we get a .dat file, load it up
      if file.name.hasSuffix(".dat") {
        if let url = URL(string: file.path) {
          // swap out the DLib model for the newly downloaded one
          self.sessionHandler.wrapper?.prepare(url.path)
        }
      }
    }
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sessionHandler.openSession()
        

        let layer = sessionHandler.layer
        layer.frame = preview.bounds

        preview.layer.addSublayer(layer)
        
        view.layoutIfNeeded()

    }
}
