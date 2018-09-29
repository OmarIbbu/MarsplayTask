//
//  HomeViewController.swift
//  Marsplay
//
//  Created by thincnext on 28/09/18.
//  Copyright © 2018 thincnext. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var listItems = [DataModel]()
    var placeholderImage = UIImage(named:"loader")!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let items = listItems[indexPath.row]
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.title.text = items.Title
        cell.type.text = items.type
        let splitDate : String = items.Year
        let array = splitDate.components(separatedBy: "–")
        let date1 = array.last
        
        
        let time =   compareDate(date: date1!)
        cell.year.text = time
        
        
        cell.posterImg.sd_setImage(with: URL(string: items.Poster), placeholderImage: UIImage(named: "user"))
        
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = listItems[indexPath.row ]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Detailview") as! DetailViewController
        
        controller.poster = items.Poster
        controller.postertype = items.type
        controller.titleName = items.Title
        let splitDate : String = items.Year
        let array = splitDate.components(separatedBy: "–")
        let date = array.last
        
        controller.yearName = date
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    
    
    func GetData() {
        
        self.activityIndicator.startAnimating()
        var strResponse: String? = nil
        let url = NSURL(string: "http://www.omdbapi.com/?s=Batman&page=1&apikey=eeefc96f")!
        let urlRequest = NSURLRequest(url: url as URL)
        print(urlRequest)
        var rData:Data? = nil
        DispatchQueue.global(qos: .userInteractive).async {
            let semaphore = DispatchSemaphore(value: 0)
            
            
            let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {(data,response,error ) in
                
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    strResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                    
                } else {
                    
                    strResponse = "Oops! something went wrong"
                    
                }
                
                
                rData = data
                semaphore.signal()
                
                return
                
            }
            task.resume()
            semaphore.wait()
            
            
            DispatchQueue.main.async {
                
                do {
                    
                    self.activityIndicator.stopAnimating()
                    
                    let json = try JSONSerialization.jsonObject(with: rData!) as! [String:Any]
                    let result =  json["Search"] as? [[String:Any]]
                    for items in result! {
                        
                        
                        
                        let Title = items["Title"] as! String
                        let Year = items["Year"] as! String
                        let imdbID = items["imdbID"] as! String
                        let type = items["Type"] as! String
                        let Poster = items["Poster"] as! String
                        
                        
                        
                        let itemDetails = DataModel(Title: Title, Year: Year, imdbID: imdbID, type: type, Poster: Poster)
                        
                        self.listItems.append(itemDetails)
                        
                    }
                    
                    
                    self.collectionView.reloadData()
                    
                }
                    
                    
                catch let error {
                    
                    print(error.localizedDescription)
                    
                }
                
            }
            
            
            
        }
    }
    func compareDate(date:String)->String{
        
        
        let dateFormatter = DateFormatter()
        
        var dateS = date.components(separatedBy: ".")
        dateS.removeLast()
        
        
        dateFormatter.dateFormat = "yyyy"
        
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        dateFormatter.locale = Locale.current
        
        let datee = dateFormatter.date(from: date)// create   date from string
        
        
        
        var calan = Calendar(identifier: .gregorian)
        
        calan.locale = NSLocale.current
        
        calan.timeZone = TimeZone.current
        
        
        
        let myDate = Date()
        
        let componets:Set<Calendar.Component> = [.year]
        
        let differenceDate = Calendar.current.dateComponents(componets, from: datee!, to: myDate).year ?? 0
        
        let returnStr:String! = (String(describing: differenceDate) + " Years ago")
        
        
        
        return returnStr
        
        
    }
    
    
    
}
