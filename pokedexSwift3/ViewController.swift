//
//  ViewController.swift
//  pokedexSwift3
//
//  Created by Quinten Simmons on 2/1/17.
//  Copyright © 2017 Quinten Simmons. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]() //will contain array of all pokemon from CSV file
    var filteredPokemon = [Pokemon]() //will contain array of filtered results from search bar
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false //for search bar
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //-1 indicates it will just loop continuously forever
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! //path to pokemon CSV file
        
        do {
            let csv = try CSV(contentsOfURL: path) //using parcer to pull out the rows
            let rows = csv.rows
            print(rows)
            
            for row in rows { // loop through the rows to pull out the name and id of each pokemon
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId) //pass the name and id into our pokemon class to create a new Pokemon object
                pokemon.append(poke) //append that object into our pokemon array
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //dequeues cells and sets them up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    //code in this function will execute when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
        
    }
    
    //sets number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    //number of sections in the collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    //define the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)//make keyboard disappear when seach is clicked.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData() //make sure we revert to original list of pokemon
            view.endEditing(true) //make keyboard disappear when done editing search bar
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil}) //$0 is placeholder for all objets in pokemon array. name is getting the name. range(of: lower) is saying "is what we put in the search bar contained in that name"?
            collection.reloadData() //reloads collectionview with new data
            
        }
        
        
    }
    
    //this sends the poke object created in didSelectItemAt over to the PokemonDetailVC and puts it in that VC's pokemon object.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }

}






































