#= require models/pirate

window.Pirate.Base = class extends Pirate
  type: 'base'
  maxSpeed: 0.5
  detectionDistance: 350
  roundsPerSecond: 5
  maxHealth: 100
  hitDistance: 40