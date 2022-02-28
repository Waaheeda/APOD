//
//  ViewController.swift
//  APOD
//
//  Created by Vahida on 25/02/22.
//

import UIKit
import ExpandableLabel
import CoreLocation


class ViewController: UIViewController , ExpandableLabelDelegate {
   
    @IBOutlet weak var refreshAPODButton: UIButton!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    @IBOutlet weak var apodimageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ExpandableLabel!
    var apodViewModel : APODViewModel?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
  
    let activityIndicator =  UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)

    fileprivate func InitialiseUI()
    {
        SetDarKMode()
        
        activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        activityIndicator.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin,.flexibleBottomMargin]
        activityIndicator.color = UIColor.white
        self.view.addSubview(activityIndicator)
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        self.descriptionLabel.numberOfLines = 2
     //   self.descriptionLabel.collapsed = true
        self.descriptionLabel.expandedAttributedLink = NSAttributedString(string: "Read Less")
        self.descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Read More..", attributes: [NSAttributedString.Key.foregroundColor:UIColor.systemBlue])
        
        descriptionLabel.setLessLinkWith(lessLink: "Read Less", attributes: [NSAttributedString.Key.foregroundColor:UIColor.systemBlue], position: nil)
        self.descriptionLabel.delegate = self
       
        
        self.view.bringSubviewToFront(self.descriptionLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        InitialiseUI()
        
        callToViewModelForUIUpdate()

    }

    fileprivate func refreshUI() {
        if let data =  self.apodViewModel?.apodData
        {
            self.titleLabel.text = data.title
            self.descriptionLabel.text = data.explanation
            if let isFavourite = data.isFavourite
            {
                if isFavourite
                {
                    self.addToFavouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                else
                {
                    self.addToFavouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
                
            }
            else
            {
                self.addToFavouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
      
    }
    
    func callToViewModelForUIUpdate()
    {
        
        apodViewModel = APODViewModel.init()
        
        apodViewModel?.bindAPODViewModelToController = { 
            DispatchQueue.main.async{
 
                        self.refreshUI()
                        
                        do {
                          
                            if let data =  self.apodViewModel?.apodData
                            {
                                if let imagedata = data.img
                                {
                                    self.apodimageView.image = UIImage.init(data: imagedata)
                                }
                                else
                                {
                                    self.apodimageView.image = UIImage.init(data: try Data.init(contentsOf: URL.init(string: (data.hdurl!))!))
                                }
                            }
                           
                            

                            self.activityIndicator.stopAnimating()

                        } catch
                        {
                            print("exception thrown")
                        }
                    }
                   

                }
        
        apodViewModel?.completion = {
            DispatchQueue.main.async{
                print("Something went wrong")
                self.refreshUI()

                self.activityIndicator.stopAnimating()
            }
        }
    }
    // MARK: Date Picker action

    
    @IBAction func datePicker(_ sender: UIDatePicker)
    {
      
        presentedViewController?.dismiss(animated: true, completion: nil)
        
        self.refreshAPODButton.isEnabled = (Date.init() != sender.date)
        self.activityIndicator.startAnimating()
        ApiManager.shared.SelectedDate = sender.date
        
        callToViewModelForUIUpdate()
   
    }
    
    
    @IBAction func didTapOutSide(_ sender: Any) {
    }
    
    // MARK: addToFavourites

    @IBAction func addToFavourites(_ sender: Any)
    {
        self.apodViewModel?.apodData.isFavourite = !(self.apodViewModel?.apodData.isFavourite ?? false)
        refreshUI()
       
       // self.apodViewModel?.resetAllFavourites()
        
    }
    
    // MARK: refresh APOD

    @IBAction func refresh(_ sender: Any)
    {
        self.activityIndicator.startAnimating()
        self.datePicker.date = Date.init()
        ApiManager.shared.SelectedDate =  self.datePicker.date
        callToViewModelForUIUpdate()
    }
    

    // MARK: ExpandableLabelDelegate
    func willExpandLabel(_ label: ExpandableLabel) {
        
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.descriptionLabel.shouldCollapse = true
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
  
}

