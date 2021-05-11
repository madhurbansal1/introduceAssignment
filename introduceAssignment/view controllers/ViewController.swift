//
//  ViewController.swift
//  introduceAssignment
//
//  Created by madhur bansal on 5/11/21.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var enrolButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    private lazy var viewAllVC: viewAllVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewAllVC = storyboard.instantiateViewController(withIdentifier: "viewAllVC") as! viewAllVC
        self.add(asChildViewController: viewAllVC)
        return viewAllVC
    }()
    
    private lazy var registerVC: registerVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var registerVC = storyboard.instantiateViewController(withIdentifier: "registerVC") as! registerVC
        self.add(asChildViewController: registerVC)
        return registerVC
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUP()
    }
    
    func setUP()
    {
        updateView(tag: 0)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeHandler))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeHandler))
        rightSwipe.direction = .right
        
        contentView.addGestureRecognizer(leftSwipe)
        contentView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func leftSwipeHandler()
    {
        updateView(tag: 1)
    }
    
    @objc func rightSwipeHandler()
    {
        updateView(tag: 0)
    }

    @IBAction func usersTapped(_ sender: Any)
    {
        updateView(tag: 0)
    }
    
    @IBAction func enrollTapped(_ sender: Any)
    {
        updateView(tag: 1)
    }
    
    func updateView(tag:Int)
    {
        if tag == 0
        {
            UIView.animate(withDuration: 0.2)
            {
                self.lineView.transform = .identity
            }
            enrolButton.setTitleColor(.lightGray, for: .normal)
            usersButton.setTitleColor(.systemBlue, for: .normal)
            remove(asChildViewController: registerVC)
            add(asChildViewController: viewAllVC)
        }
        else
        {
            UIView.animate(withDuration: 0.2)
            {
                self.lineView.transform = CGAffineTransform(translationX: self.grayView.frame.size.width/2, y: 0)
            }
            usersButton.setTitleColor(.lightGray, for: .normal)
            enrolButton.setTitleColor(.systemBlue, for: .normal)
            remove(asChildViewController: viewAllVC)
            add(asChildViewController: registerVC)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController)
    {
        addChild(viewController)
        self.contentView.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.bindFrameToSuperviewBounds()
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController)
    {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

