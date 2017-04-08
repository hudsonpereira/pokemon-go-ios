//
//  PokedexViewController.swift
//  Pokemon Go
//
//  Created by Hudson Pereira on 08/04/17.
//  Copyright © 2017 Hudson Pereira. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var capturedPokemons: [Pokemon] = []
    var uncapturedPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPokemon = CoreDataPokemon()
        
        self.capturedPokemons = coreDataPokemon.getPokemons(captured: true)
        self.uncapturedPokemons = coreDataPokemon.getPokemons(captured: false)
        
        print(capturedPokemons)
        print(uncapturedPokemons)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Captured" : "Uncaptured"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.capturedPokemons.count : self.uncapturedPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellProto")
        
        
        let pokemon = indexPath.section == 0 ? self.capturedPokemons[indexPath.row] : self.uncapturedPokemons[indexPath.row]
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.image!)
        
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backtoMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
