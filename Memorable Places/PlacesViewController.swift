//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by VX on 27/10/2016.
//  Copyright © 2016 VXette. All rights reserved.
//

import UIKit

var places = [Dictionary<String, String>()]

class PlacesViewController: UITableViewController {
	
	var activePlace = -1
	
	@IBOutlet var table: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
			places = tempPlaces
		}
		
		if places.count == 1 && places[0].count == 0 {
			places.remove(at: 0)
			places.append(["name":"Taj Mahal", "lat":"27.175277", "lon":"78.042128"])
			
			UserDefaults.standard.set(places, forKey: "places")
		}
		
		activePlace = -1
		
		table.reloadData()
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return places.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
		
		if places[indexPath.row]["name"] != nil {
			cell.textLabel?.text = places[indexPath.row]["name"]
		}
		
		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		activePlace = indexPath.row
		
		performSegue(withIdentifier: "toMap", sender: activePlace)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? ViewController {
			if let place = sender as? Int {
				destination.place = places[place]
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete {
			places.remove(at: indexPath.row)
			
			UserDefaults.standard.set(places, forKey: "places")
			
			table.reloadData()
		}
	}

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
