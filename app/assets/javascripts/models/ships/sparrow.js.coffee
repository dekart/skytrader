#= require models/ship

window.Ship.Sparrow = class extends Ship
  type: 'sparrow'
  maxSpeed: 4
  maxCargo: 10
  maxHealth: 100
  maxFuel: 5

  roundsPerSecond: 2
