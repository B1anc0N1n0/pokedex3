//
//  PokemonDetailVC.swift
//  pokedexSwift3
//
//  Created by Quinten Simmons on 2/2/17.
//  Copyright © 2017 Quinten Simmons. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        
    }

    

    

}
