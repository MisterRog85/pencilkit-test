//
//  ViewController.swift
//  pencilkit-test
//
//  Created by William Tomas on 24/12/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import UIKit
import PencilKit

class ViewController: UIViewController {
    
    let canvasView = PKCanvasView(frame: .zero)
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        //navigationBar.topItem?.title = dateDuJour()
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasView)
        
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func dateDuJour() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd MM yyy HH:mm"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        return formattedDate
    }
    
    func setNavigationBar() {
        if let navItem = navigationBar.topItem{
            let saveItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveImage))
            
            let clearItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
            
            let toggleItem = UIBarButtonItem(title: "Toggle Picker", style: .plain, target: self, action: #selector(togglePicker))

            navItem.title = dateDuJour()
            navItem.rightBarButtonItems?.append(clearItem)
            navItem.rightBarButtonItems?.append(toggleItem)
            navItem.rightBarButtonItems?.append(saveItem)
        }
        
    }

    @objc func saveImage() {
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1.0)
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    
    @objc func clear() {
        canvasView.drawing = PKDrawing()
    }
    
    @objc func togglePicker() {
        if canvasView.isFirstResponder{
            canvasView.resignFirstResponder()
        }else{
            canvasView.becomeFirstResponder()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard
            let window = view.window,
            let toolPicker = PKToolPicker.shared(for: window) else { return }

        toolPicker.setVisible(false, forFirstResponder: canvasView)
        toolPicker.isRulerActive = false   
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}

