/*
class circleAnimation{
  
}
circleAnimation(){
  
}

let theta = [];
let dir = [];
let r = [];
let c = []
let n = 100

function setup() {
  createCanvas(800, 800)
  background(220)
  strokeWeight(3)
  stroke('orange')
  for (let i = 0; i < n; i++) {
    theta.push(random(0, 2 * PI))
    dir.push([-1, 1][round(random(1))])
    r.push(random(30, 380))
    c.push(createVector(400, 400))
  }
}

function draw() {
    fill(0, 0, 0, 5)
    rect(0, 0, width, height)
    for (let i = 0; i < n; i++) {
      theta[i] = theta[i] + PI / 100 * dir[i]
      x = c[i].x + r[i] * cos(theta[i])
      y = c[i].y + r[i] * sin(theta[i])
      point(x, y)
    }
    */
