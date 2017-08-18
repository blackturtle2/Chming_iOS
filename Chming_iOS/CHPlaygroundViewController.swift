//
//  CHPlaygroundViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 17/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import AVFoundation

class CHPlaygroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // background AV
        self.setupVideoBackground()
        videoURL = Bundle.main.url(forResource: "PolarBear", withExtension: "mov")! as NSURL
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // 하늘이형 제공.
    public var videoURL: NSURL? {
        didSet {
            setupVideoBackground()
        }
    }
    
    // 로그인 페이지 백그라운드 설정
    func setupVideoBackground() {
        
        var theURL = NSURL()
        if let url = videoURL {
            
            let shade = UIView(frame: self.view.frame)
            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            view.addSubview(shade)
            view.sendSubview(toBack: shade)
            
            theURL = url
            
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(url: theURL as URL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
            
            avPlayerLayer.frame = view.layer.bounds
            
            let layer = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.clear
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            view.addSubview(layer)
            view.sendSubview(toBack: layer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
            
            avPlayer.play()
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        if let p = notification.object as? AVPlayerItem {
            p.seek(to: kCMTimeZero)
        }
    }
}
