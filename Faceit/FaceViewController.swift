//
//  FaceViewController.swift
//  Faceit
//
//  Created by miyatsu-imac on 9/21/17.
//  Copyright © 2017 miyatsu-imac. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecongnizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecongnizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
        
            updateUI()
        }
    }
    
    @objc func increaseHappiness(){
        expression = expression.happier
    }
    
    @objc func decreaseHappiness(){
        expression = expression.sadder
    }
    
    @objc func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer){
        if tapRecognizer.state == .ended{
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown){
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin:0.5, .frown:-1.0, .smile:1.0, .neutral:0.0, .smirk:-0.5]
}

