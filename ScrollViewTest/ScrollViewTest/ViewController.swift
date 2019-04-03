//
//  ViewController.swift
//  ScrollViewTest
//
//  Created by Markus on 2019-04-03.
//  Copyright © 2019 The App Factory AB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    
    var keyboardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Skapa plats/storlek
//        let rect = CGRect(x: 50, y: 50, width: 100, height: 100)
//        
//        // Skapa vy
//        let square = UIView(frame: rect)
//        
//        // Konfigurera vy
//        square.backgroundColor = UIColor.red
//        
//        let block = UIView(frame:rect)
//        
//        block.backgroundColor = UIColor.blue
//        
//        square.clipsToBounds = true
//        square.addSubview(block)
//        
//        // Lägg till i din "container view"
//        view.addSubview(square)
//        
//        // Skapa scrollView
//        let scrollView = UIScrollView(frame: view.bounds)
//        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//        scrollView.backgroundColor = UIColor.green
//        
//        var offset:CGFloat = 0
//        
//        for i in 0...5 {
//            let place = CGRect(x: 100, y: 50+i*200, width: Int(view.frame.size.width-200), height: 100)
//            offset += 200
//            let butt = UIView(frame: place)
//            butt.backgroundColor = UIColor.white
//            scrollView.addSubview(butt)
//        }
//        
//        scrollView.contentSize = CGSize(width: view.bounds.size.width*1.5, height:offset)
//        
//        view.addSubview(scrollView)
        
        
        // Lyssa på notiser från tangentbordet!
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        // Lägg till tap gesture för att stänga
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        
        // Sätt min och max zoom
        myScrollView.minimumZoomScale = 0.5
        myScrollView.maximumZoomScale = 2.0
    }
    
    @objc func didTap(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print("Tangentbordet kommer att visa sig!")
        var keyboardHeight:CGFloat = 216.0 // Sätt en default höjd för tangentbordet
        // Försök att ta reda på höjden på tangentbordet (skiljer sig för större telefoner och iPad)
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue { // Inte lätt att komma ihåg... ;)
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        myScrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        print("Tangentbordet kommer att gömma sig!")
        myScrollView.contentInset = UIEdgeInsets.zero
        myScrollView.contentOffset = CGPoint.zero
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.contentOffset.x går från 0 till 750 (+375 för varje sida)
        let pageNumber = Int(round(scrollView.contentOffset.x/view.frame.size.width))
        pageControl.currentPage = pageNumber
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}

