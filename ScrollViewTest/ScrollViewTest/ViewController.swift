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
        
        // Skapa scrollView
//        createScrollView()
        
        // Lyssa på notiser från tangentbordet!
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        // Lägg till tap gesture för att stänga
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        
        // Sätt min och max zoom
        myScrollView.minimumZoomScale = 0.5
        myScrollView.maximumZoomScale = 2.0
        
        // Skapa "gräs"
        createGrass(count: 20, size: 20)
    }
    
    func createScrollView() {
        
        // Skapa vy med samma storlek som huvudvy
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.green
        
        // Om vi inte använder auto layout constraints, så måste vi ställa in "gammal typ av skalning"
        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Variabel att öka avstånd Y-led
        var offset:CGFloat = 0
        
        // Skapa 5 vyer och placera jämnt fördelat i scrollView
        for i in 0...5 {
            let place = CGRect(x: 100, y: 50+i*200, width: Int(view.frame.size.width-200), height: 100)
            offset += 200
            let butt = UIView(frame: place)
            butt.backgroundColor = UIColor.white
            scrollView.addSubview(butt)
        }
        
        // Ställ in storleken för din "Content View"
        scrollView.contentSize = CGSize(width: view.bounds.size.width*1.5, height:offset)
        
        // Lägg till den i din "container view"
        view.addSubview(scrollView)
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
    
    // MARK: Populate "grass" views
    
    func createGrass(count: Int, size: CGFloat) {
        let step = view.frame.size.width / CGFloat(count)
        var offset:CGFloat = 0
        for _ in 0...count {
            let rect = CGRect(x: offset, y: contentView.frame.size.height-size/2, width: size, height: size)
            let grassView = UIView(frame: rect)
            grassView.layer.transform = CATransform3DMakeRotation(.pi/4, 0, 0, 1)
            grassView.backgroundColor = UIColor.green
            contentView.addSubview(grassView)
            offset += step
        }
    }
}

