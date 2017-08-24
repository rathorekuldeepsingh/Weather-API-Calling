import UIKit
import CoreLocation

class TableViewController: UITableViewController, UISearchBarDelegate {

    var forecastData = [Weather]()
    
// Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
//MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        updateWeatherForLocation(location: "New York")
    }
    
//MARK:- Search Bar Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
//MARK:-  Location Method
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
//MARK:- Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date!)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let weatherObject = forecastData[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °F"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }
}
