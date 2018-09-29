//
//  DetailViewController.swift
//  Marsplay
//
//  Created by thincnext on 28/09/18.
//  Copyright © 2018 thincnext. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var poster, titleName , postertype , yearName : String?

    @IBOutlet weak var typename: UILabel!
    @IBOutlet weak var yearname: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titlename: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlename.text = titleName
        yearname.text = yearName
        typename.text = postertype
        
       
       posterImage.sd_setImage(with: URL(string: poster ?? "abc"), placeholderImage: UIImage(named: "loader"))
      
    }
    

  
}
