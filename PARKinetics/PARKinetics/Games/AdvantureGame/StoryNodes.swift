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
    var rightChild: StoryNode?
    var leftChild: StoryNode?
    
    init(storyPlot: String, rightStory: String, leftStory: String, key: Int, gameOver: Bool, gameOverStory: String) {
      self.storyPlot = storyPlot
      self.rightStory = rightStory
      self.leftStory = leftStory
      self.key = key
      self.gameOver = gameOver
      self.gameOverStory = gameOverStory
    }
    
}

public class StoryList{
    fileprivate var head: StoryNode?
    public var currentNode: StoryNode?
    public var currentStory: StoryNode?

    public var isEmpty: Bool {
      return head == nil
    }

    public var first: StoryNode? {
      return head
    }
    
    //Description: Adds a story node to the tree
    //Pre: Parameters exist
    //Post: Story node is added to the tree
    public func addNode(storyPlot: String, rightStory: String, leftStory: String, key: Int, gameOver: Bool, gameOverStory: String){
        let newStory = StoryNode(storyPlot: storyPlot, rightStory: rightStory, leftStory: leftStory, key: key, gameOver: gameOver, gameOverStory: gameOverStory)
        newStory.leftChild = nil
        newStory.rightChild = nil
        if isEmpty{
            head = newStory
            currentNode = head
           // print("here")
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
    
    //Description: Indicates the story node given by the key
    //Pre: Key integer is given
    //Post: Returns currentStory node
    public func StoryIsHere(key: Int) -> StoryNode? {
        currentNode = head
        while (currentNode!.key != key){
            if (currentNode!.key > key){
                currentNode = currentNode!.rightChild
            }
            else {
                currentNode = currentNode!.leftChild
            }
        }
        currentStory = currentNode
        return currentStory
    }
    
}

let AdventureStory1 = StoryList()

//Description: Creation of entire story tree
//Pre: StoryList() is defined
//Post: All story nodes added to tree
func createStory(){
    AdventureStory1.addNode(storyPlot: "Your eyes slowly open to a lush forest scene. You are hungry and appear to be lost", rightStory: "Get to a high view", leftStory: "Search for food", key: 1000, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You hear the chirps and cries of wild animals throughout the forest. There also seems to be lots of edible plant life", rightStory: "Go hunting", leftStory: "Eat some wild berries", key: 500, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "After a short walk through the brush you arrive at the bottom of a steep hill with a rocky face", rightStory: "Climb the rocks", leftStory: "Go around the long way", key: 2000, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "The berries were not very filling, but satisfy your immediate hunger. After wandering around aimlessly for a time, you hear a shout in the distance. Someone is screaming for help!", rightStory: "Race toward the sound", leftStory: "Run the other way", key: 400, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "After some searching you come across a stream rife with leaping fish", rightStory: "Prepare a trap", leftStory: "Try to catch a fish", key: 900, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "Your bravery pays off and you reach the top of the hill in no time. The hill offers you a view of the entire forest. You see a thick plume of smoke rising from the trees to the north, but a winding river to the south", rightStory: "Follow the smoke", leftStory: "Follow the river", key: 2500, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You walk the trail around the hill for a long time but seem no nearer to the top", rightStory: "Continue walking", leftStory: "Turn around", key: 1900, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You dash away from the sound hoping to avoid whatever danger was ahead. You run so far that you find yourself in front of a cave with a bright glow coming from within", rightStory: "Enter boldly", leftStory: "Enter carefully", key: 300, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You sprint through the trees and arrive at the source of the sound. Sprawled before you is the wreckage of an airplane. You don't hear the voice anymore", rightStory: "Explore the plane", leftStory: "Call out to help", key: 450, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You recklessly plunge your hands into the stream, missing the fish and falling in. The stream starts carrying you off faster and faster", rightStory: "Wait for the stream to slow", leftStory: "Try to swim away", key: 800, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "There are lots of reeds along the stream that can be woven into a net, but the only fallen tree branch in sight is on the other side of the stream", rightStory: "Make the trap as is", leftStory: "Swim across the stream", key: 950, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You turn around to walk back but suddenly lose your footing. You tumble down the side of the path until a tree breaks your fall. You're dazed but unharmed", rightStory: "Climb back up", leftStory: "Continue sliding down", key: 1800, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "After almost giving up you finally arrive at the top of the hill. The hill offers you a view of the entire forest. You see a thick plume of smoke rising from the trees to the north, but a winding river to the south", rightStory: "Follow the smoke", leftStory: "Follow the river", key: 1950, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You make your way carefully down the hill after quite a bit of time", rightStory: "Still follow the smoke", leftStory: "Follow the river instead", key: 2600, gameOver: false, gameOverStory: "")
    AdventureStory1.addNode(storyPlot: "You make your way carefully down the hill after quite a bit of time", rightStory: "Still follow the river", leftStory: "Follow the smoke insteadd", key: 2450, gameOver: false, gameOverStory: "")
}
