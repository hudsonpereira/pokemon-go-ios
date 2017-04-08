//
//  CoreDataPokemon.swift
//  Pokemon Go
//
//  Created by Hudson Pereira on 08/04/17.
//  Copyright © 2017 Hudson Pereira. All rights reserved.
//

import CoreData
import UIKit

class CoreDataPokemon {
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
    }
    
    func addPokemons() {
        let context = self.getContext()
        
        self.createPokemons(name: "Pikachu", image: "pikachu-2", captured: true)
        self.createPokemons(name: "Charmander", image: "charmander", captured: false)
        self.createPokemons(name: "Squirtle", image: "squirtle", captured: false)
        self.createPokemons(name: "Caterpie", image: "caterpie", captured: false)
        self.createPokemons(name: "Bulbasaur", image: "bullbasaur", captured: false)
        self.createPokemons(name: "Psyduck", image: "psyduck", captured: false)
        self.createPokemons(name: "Zubat", image: "zubat", captured: false)
        self.createPokemons(name: "Snorlax", image: "snorlax", captured: false)
        self.createPokemons(name: "Dratini", image: "dratini", captured: false)
        self.createPokemons(name: "Eve", image: "eevee", captured: false)
        
        do {
            try context.save()
        } catch {
            print("Something went wrong")
        }
    }
    
    func createPokemons(name: String, image: String, captured: Bool) {
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        
        pokemon.name = name
        pokemon.image = image
        pokemon.captured = captured
    }
    
    func getAll() -> [Pokemon] {
        let context = self.getContext()
        
        do {
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.addPokemons()
                
                return self.getAll()
            }
            
            
            return pokemons
        } catch {
            print("something went wrong")
        }
        
        return []
    }
    
    func getPokemons(captured: Bool) -> [Pokemon] {
        let context = self.getContext()
        
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        
        request.predicate = NSPredicate(format: "captured = %@", captured as CVarArg)
        
        do {
            return try context.fetch(request)
        } catch {
            
        }
        
        return []
    }
    
    func catchPokemon(pokemon: Pokemon) {
        let context = self.getContext()
        
        pokemon.captured = true
        
        do {
            try context.save()
        } catch  {
            
        }
    }
}
