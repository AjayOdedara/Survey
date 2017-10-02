//
//  ViewController.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//

import UIKit
import p2_OAuth2
import SDWebImage

class ViewController: UIViewController, UIScrollViewDelegate{

    
    var clipView = SubView()
    var scrollView: UIScrollView?
    var pageControl: VerticalPageControl?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var button: UIButton!
    
    private let kScrollViewHeight: Int = Int(UIScreen.main.bounds.height)
    private let kScrollViewContentHeight: Int = Int(UIScreen.main.bounds.height-60)
    private let kScrollViewTagBase: Int = 500
    
    var indicator = ViewControllerUtils()
    
    
    var coreRepo = CoreRepository(apiRoot: Constant.apiRoot)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.isHidden = true
        setUpBasicUI()
        getSurveyData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        button.layer.cornerRadius = button.frame.size.height / 2
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            let index = Int((self.scrollView?.contentOffset.y)! / CGFloat(kScrollViewHeight))
            
            titleLabel.text = coreRepo.surveys?.survey?[index].title
            desLabel.text = coreRepo.surveys?.survey?[index].descrit
            
            labelAnimate(label: titleLabel)
            labelAnimate(label: desLabel)
          
            pageControl?.setCurrentPage(currentPage: index)

        }
    }

    //MARK: - IBActions
    @IBAction func buttonSurveyClicked(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        if let vc = self.storyboard!.instantiateViewController(withIdentifier: "SurveyDetailController") as? SurveyDetailController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func buttonRefreshClick(_ sender: Any) {
        setUpBasicUI()
        getSurveyData()
    }
    
    //MARK: - Functions
    func getSurveyData(){
        indicator.showActivityIndicator(uiView: self.view)
        coreRepo.getSurveys(onCompletion: { (data) in
            self.button.isHidden = false
            self.coreRepo.surveys = data
            self.setUpData(surveys: self.coreRepo.surveys!)
            self.indicator.hideActivityIndicator(uiView: self.view)
        }) { (error) in
            self.indicator.hideActivityIndicator(uiView: self.view)
            self.showAlert(alertTitle: Constant.kErrorTitile, alertMessage: (error?.localizedDescription)!, forSuccess: true)
        }
    }
    
    func setUpBasicUI(){
        
        self.navigationController?.navigationBar.isHidden = true
        clipView = SubView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        clipView.clipsToBounds = true
        view.addSubview(clipView)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Int(clipView.bounds.size.width), height: kScrollViewHeight))
        scrollView?.delegate = self
        scrollView?.clipsToBounds = false
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.autoresizingMask = .flexibleWidth
        view.addSubview(scrollView!)
        clipView.scrollView = scrollView!
        
        view.bringSubview(toFront: button)
        view.bringSubview(toFront: titleLabel)
        view.bringSubview(toFront: desLabel)
        view.bringSubview(toFront: navigationView)
        
    }
    
    func setUpData(surveys : Surveys){
        
        guard let pages = coreRepo.surveys?.survey?.count else {
            return
        }
        // Set Pages
        pageControl = VerticalPageControl(numberOfPages: pages)
        var frame: CGRect = pageControl!.frame
        frame.origin.x = view.bounds.size.width - frame.size.width - 10
        frame.origin.y = CGFloat(roundf(Float((view.bounds.size.height - frame.size.height) / 2.0)))
        pageControl?.frame = frame
        pageControl?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        pageControl?.setCurrentPage(currentPage: 0)
        view.addSubview(pageControl!)
        var currentY: CGFloat = 0
        
        
        
        //Set Page Images
        for i in 0..<pages {
            
            let viewFront = UIView(frame:CGRect(x: 0, y: currentY, width: scrollView!.bounds.size.width, height: CGFloat(kScrollViewHeight)))
            viewFront.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            viewFront.isOpaque = false
            
            let sv = UIImageView(frame: CGRect(x: 0, y: currentY, width: scrollView!.bounds.size.width, height: CGFloat(kScrollViewHeight)))
            
            sv.tag = kScrollViewTagBase + i
            sv.contentMode = .scaleAspectFill
            sv.autoresizingMask = .flexibleWidth
            sv.backgroundColor = UIColor.white
            
            sv.sd_setImage(with: URL(string:(surveys.survey?[i].image)!), placeholderImage: #imageLiteral(resourceName: "place"), options: SDWebImageOptions.highPriority, completed: { (image, error, type, url) in
                if (error != nil){
                    sv.contentMode = .scaleAspectFit
                    sv.image = #imageLiteral(resourceName: "imageNotFound")
                }else{
                    sv.image = image
                }
                
            })
            
            scrollView?.addSubview(sv)
            scrollView?.addSubview(viewFront)
            scrollView?.bringSubview(toFront: viewFront)
            currentY += CGFloat(kScrollViewHeight)
            
        }
        
        // Assign ScrollView Content From Pages
        
        scrollView?.contentSize = CGSize(width: (scrollView?.contentSize.width)!, height: currentY)
        titleLabel.text = coreRepo.surveys?.survey?[0].title
        desLabel.text = coreRepo.surveys?.survey?[0].descrit
        
        
        
        
    }
    //MARK: - Simple Animations
    func labelAnimate(label:UILabel){
        label.center.x = view.center.x
        label.center.x -= view.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            label.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

