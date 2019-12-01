//
//  StoryNodes.swift
//  PARKinetics
//
//  Created by TANKER on 2019-11-16.
//  Copyright © 2019 TANKER. All rights reserved.
//
//Description: This file contains the entire story to be used for the Adventure Story game. The story consists of nodes stored in a binary search tree using a linked list
//Contributors:
//      Armaan Bandali: All

import Foundation

public class StoryNode{
    
    var key: Int
    var storyPlot: String
    var rightStory: String
    var leftStory: String
    var gameOver: Bool
    var gameOverStory: String
    var pictureFile: String
    var rightChild: StoryNode?
    var leftChild: StoryNode?
    
    
    init(storyPlot: String, rightStory: String, leftStory: String, key: Int, gameOver: Bool, gameOverStory: String, pictureFile: String) {
      self.storyPlot = storyPlot
      self.rightStory = rightStory
      self.leftStory = leftStory
      self.key = key
      self.gameOver = gameOver
      self.gameOverStory = gameOverStory
      self.pictureFile = pictureFile
    }
    
}

public class StoryList{
    fileprivate var head: StoryNode?
    public weak var currentNode: StoryNode?
    public weak var currentStory: StoryNode?

    public var isEmpty: Bool {
      return head == nil
    }

    public var first: StoryNode? {
      return head
    }
    
    //Description: Adds a story node to the tree
    //Pre: Parameters exist
    //Post: Story node is added to the tree
    public func addNode(storyPlot: String, rightStory: String, leftStory: String, key: Int, gameOver: Bool, gameOverStory: String, pictureFile: String){
        let newStory = StoryNode(storyPlot: storyPlot, rightStory: rightStory, leftStory: leftStory, key: key, gameOver: gameOver, gameOverStory: gameOverStory, pictureFile: pictureFile)
        newStory.leftChild = nil
        newStory.rightChild = nil
        if isEmpty{
            head = newStory
            currentNode = head
        }
        else{
            currentNode = head
            while (true){
                if (currentNode!.key < newStory.key){
                    if (currentNode!.rightChild==nil){
                        currentNode!.rightChild = newStory
                        break
                    }
                    else{
                        currentNode=currentNode!.rightChild
                        continue
                    }
                }
                else {
                    if (currentNode!.leftChild==nil){
                        currentNode!.leftChild = newStory
                        break
                    }
                    else{
                        currentNode=currentNode!.leftChild
                        continue
                    }
                }
            }
        }
    }
    
    public func setChildren(key: Int, targetKey: Int){
        StoryIsHere(key: key)?.rightChild = StoryIsHere(key: targetKey)?.rightChild
        StoryIsHere(key: key)?.leftChild = StoryIsHere(key: targetKey)?.leftChild
    }
    
    
    //Description: Indicates the story node given by the key
    //Pre: Key integer is given
    //Post: Returns currentStory node
    public func StoryIsHere(key: Int) -> StoryNode? {
        currentNode = head
        while (currentNode!.key != key){
            if (currentNode!.key < key){
                currentNode = currentNode!.rightChild
            }
            else {
                currentNode = currentNode!.leftChild
            }
        }
        //currentStory = currentNode
        return currentNode
    }
}

//Description: Creation of entire story tree
//Pre: StoryList() is defined
//Post: All story nodes added to tree
func createStory(adventureStoryList: StoryList){
    adventureStoryList.addNode(storyPlot: "Your eyes slowly open to a lush jungle scene. You are hungry and appear to be lost.", rightStory: "Get to a high view", leftStory: "Search for food", key: 1000, gameOver: false, gameOverStory: "", pictureFile: "jungle")
    adventureStoryList.addNode(storyPlot: "You hear the chirps and cries of wild animals throughout the forest. There also seems to be lots of edible plant life.", rightStory: "Go hunting", leftStory: "Eat some wild berries", key: 500, gameOver: false, gameOverStory: "", pictureFile: "jungle")
    adventureStoryList.addNode(storyPlot: "After a short walk through the brush you arrive at the bottom of a steep hill with a rocky face.", rightStory: "Climb the rocks", leftStory: "Go around the long way", key: 2000, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "The berries were not very filling, but satisfy your immediate hunger. After wandering around aimlessly for a time, you hear a shout in the distance. Someone is screaming for help!", rightStory: "Race toward the sound", leftStory: "Run the other way", key: 400, gameOver: false, gameOverStory: "", pictureFile: "jungle")
    adventureStoryList.addNode(storyPlot: "After some searching you come across a roaring river rife with leaping fish!", rightStory: "Prepare a trap", leftStory: "Try to catch a fish", key: 900, gameOver: false, gameOverStory: "", pictureFile: "river")
    adventureStoryList.addNode(storyPlot: "Your bravery pays off and you reach the top of the hill in no time. The hill offers you a view of the entire forest. You see a thick plume of smoke rising from the trees to the north, but a winding river to the south.", rightStory: "Follow the smoke", leftStory: "Follow the river", key: 2500, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "You walk the trail around the hill for a long time but seem no nearer to the top.", rightStory: "Continue walking", leftStory: "Turn around", key: 1900, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "You dash away from the sound hoping to avoid whatever danger was ahead. You run so far that you find yourself in front of a cave with a bright glow coming from within.", rightStory: "Enter boldly", leftStory: "Enter carefully", key: 300, gameOver: false, gameOverStory: "", pictureFile: "cave")
    adventureStoryList.addNode(storyPlot: "You sprint through the trees and arrive at the source of the sound. Sprawled before you is the wreckage of an airplane teetering on a cliff. You don't hear the voice anymore.", rightStory: "Explore the plane", leftStory: "Call out to help", key: 450, gameOver: false, gameOverStory: "", pictureFile: "wreck")
    adventureStoryList.addNode(storyPlot: "You recklessly plunge your hands into the river, missing the fish and falling in! The stream starts carrying you off faster and faster!", rightStory: "Wait for the river to slow", leftStory: "Try to swim away", key: 800, gameOver: false, gameOverStory: "", pictureFile: "river")
    adventureStoryList.addNode(storyPlot: "There are lots of reeds along the stream that can be woven into a net, but the only fallen tree branch in sight is on the other side of the stream.", rightStory: "Make the trap as is", leftStory: "Swim across the river", key: 950, gameOver: false, gameOverStory: "", pictureFile: "river")
    adventureStoryList.addNode(storyPlot: "You turn around to walk back but suddenly lose your footing. You tumble down the side of the path until a tree breaks your fall. You're dazed but unharmed.", rightStory: "Climb back up", leftStory: "Continue sliding down", key: 1800, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "After almost giving up you finally arrive at the top of the hill. The hill offers you a view of the entire forest. You see a thick plume of smoke rising from the trees to the north, but a winding river to the south.", rightStory: "Follow the smoke", leftStory: "Follow the river", key: 1950, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "You make your way carefully down the hill after quite a bit of time, but begin to have doubts...", rightStory: "Still follow the smoke", leftStory: "Follow the river instead", key: 2600, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "You make your way carefully down the hill after quite a bit of time, but begin to have doubts...", rightStory: "Still follow the river", leftStory: "Follow the smoke instead", key: 2450, gameOver: false, gameOverStory: "", pictureFile: "hill")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 100, gameOver: true, gameOverStory: "You cling to the walls of the cave as you creep forward. The glow you saw is coming from a strange moss. You wander deeper and deeper. You wander forever...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 350, gameOver: true, gameOverStory: "You recklessly enter the cave, trip, and fall down a crevice...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "No one replies.", rightStory: "Explore the plane", leftStory: "Call out to help", key: 425, gameOver: false, gameOverStory: "", pictureFile: "wreck")
    adventureStoryList.addNode(storyPlot: "The plane creaks under your weight. You see a map a few feet away and a radio on the other end of the fuselage.", rightStory: "Reach for the map", leftStory: "Crawl to the radio", key: 475, gameOver: false, gameOverStory: "", pictureFile: "plane")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 600, gameOver: true, gameOverStory: "The current is too strong and you simply cannot keep fighting it. Tired, you sink under water...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "You save energy treading water. Luckily, the river slows. Lost and tired, you walk until your feet are sore but suddenly the scene of a village reveals itself from the foliage. A primitive looking man approaches from a hut and offers you a large cooked insect!", rightStory: "Take the insect", leftStory: "Refuse the insect", key: 850, gameOver: false, gameOverStory: "", pictureFile: "hut")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 925, gameOver: true, gameOverStory: "The current is too strong and you simply cannot keep fighting it. Tired, you sink under water...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "The trap falls apart easily in the river. Back to square one.", rightStory: "Prepare a trap", leftStory: "Try to catch a fish", key: 975, gameOver: false, gameOverStory: "", pictureFile: "river")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 1100, gameOver: true, gameOverStory: "You begin sliding slowly, but you pick up uncontrollable speed quickly. You can't stop yourself from crashing head first into a tree...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 1850, gameOver: true, gameOverStory: "You quickly lose footing and continue tumbling down faster and faster. You can't stop yourself from crashing head first into a tree...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "You trudge determinedly toward the smoke. You walk until your feet are sore but suddenly the scene of a village reveals itself from the foliage. A primitive looking man approaches from a hut and offers you a large cooked insect!", rightStory: "Take the insect", leftStory: "Refuse the insect", key: 2100, gameOver: false, gameOverStory: "", pictureFile: "hut")
    adventureStoryList.addNode(storyPlot: "You trudge determinedly in the direction of the water. After some searching you come across a roaring river rife with leaping fish! Your stomach growls hungrily.", rightStory: "Prepare a trap", leftStory: "Try to catch a fish", key: 2475, gameOver: false, gameOverStory: "", pictureFile: "river")
    adventureStoryList.addNode(storyPlot: "You trudge determinedly in the direction of the water. After some searching you come across a roaring river rife with leaping fish! Your stomach growls hungrily.", rightStory: "Prepare a trap", leftStory: "Try to catch a fish", key: 2550, gameOver: false, gameOverStory: "", pictureFile: "river")
    adventureStoryList.addNode(storyPlot: "You trudge determinedly toward the smoke. You walk until your feet are sore but suddenly the scene of a village reveals itself from the foliage. A primitive looking man approaches from a hut and offers you a large cooked insect!", rightStory: "Take the insect", leftStory: "Refuse the insect", key: 2700, gameOver: false, gameOverStory: "", pictureFile: "hut")
     adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 460, gameOver: true, gameOverStory: "After just a few feet the plane cannot handle your weight. It plunges over the side of the cliff, taking you with it...", pictureFile: "")
    adventureStoryList.addNode(storyPlot: "The map reveals the location of a village. You follow the map until your feet are sore but suddenly the scene of a village reveals itself from the foliage. A primitive looking man approaches from a hut and offers you a large cooked insect!", rightStory: "Take the insect", leftStory: "Refuse the insect", key: 490, gameOver: false, gameOverStory: "", pictureFile: "hut")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 2650, gameOver: true, gameOverStory: "The man reacts angrily to your refusal. Before you know it you're grabbed by a huge villager and thrown in a cage. Who knows when they'll let you out...", pictureFile: "hut")
    adventureStoryList.addNode(storyPlot: "The insect is delicious! You meet the other villagers and quickly settle. You have never known happiness like this before, but you still remember your old life...", rightStory: "Leave forever", leftStory: "Stay in the village", key: 2800, gameOver: false, gameOverStory: "", pictureFile: "hut")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 2750, gameOver: true, gameOverStory: "The villagers are overjoyed that you decide to stay! You live out the rest of your days peacefully among the villagers...", pictureFile: "hut")
    adventureStoryList.addNode(storyPlot: "", rightStory: "Game over", leftStory: "Game over", key: 2900, gameOver: true, gameOverStory: "The villagers react angrily when you explain that you have to leave.Before you know it you're grabbed by a huge villager and thrown in a cage. Who knows when they'll let you out...", pictureFile: "hut")
    adventureStoryList.setChildren(key: 490, targetKey: 2700)
    adventureStoryList.setChildren(key: 850, targetKey: 2700)
    adventureStoryList.setChildren(key: 2100, targetKey: 2700)
    adventureStoryList.setChildren(key: 2550, targetKey: 900)
    adventureStoryList.setChildren(key: 2475, targetKey: 900)
    adventureStoryList.setChildren(key: 975, targetKey: 900)
    adventureStoryList.setChildren(key: 425, targetKey: 450)
    adventureStoryList.setChildren(key: 1950, targetKey: 2500)
}
