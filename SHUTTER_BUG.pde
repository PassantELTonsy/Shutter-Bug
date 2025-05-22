import ddf.minim.*;
Minim minim;

// Global variables
ArrayList<Bug> bugs = new ArrayList<Bug>();
ArrayList<Cloud> clouds = new ArrayList<Cloud>();
ArrayList<SickBug> sickBugs = new ArrayList<SickBug>(); // Sick bugs for Level 2

int score = 0;
int timer = 30;      // Timer for each level
int startTime;
int level = 1;       // Current level

float bugX = 0;  // X position for bug  movement
float bugY = 0;  // Y position for bug  movement

float startTextY = 0;    // Y position for "Press any key to Start" text
float startTextSpeed = 2; // Speed of vertical movement for "press any key to Start"
float titleY = 0;        // Y position for "SHUTTER BUG" title
float titleSpeed = 1.5;  // Speed of vertical movement for "SHUTTER BUG"
float bugMovementSpeed = 2; // Speed of bug movement


PImage bugImage;     // Bug image
PImage sickBugImage; // Sick bug image
PImage backgroundImage; // Background image for level 1
PImage background2; // Background image for level 2
PImage bgImage;    //welcome screen background 
PFont gameFont;

boolean levelTransition = false; // Track if transitioning between levels 1 and 2
boolean showGuideScreen = true;  // Flag to control guide screen display
boolean showWelcomeScreen = true;  // Flag to control welcome screen display
boolean gameStarted = false; // Flag to control game start
boolean timerStarted = false;

AudioPlayer backgroundMusic;   // Declare audio variables



// Setup function
void setup() {
  size(1000, 600);    // Window size W*H
  startTime = millis(); // built in function returns the number of milliseconds that have passed
  
  // Initialize Minim which is audio library and new inistance 
  minim = new Minim(this);
  // Load background music
  backgroundMusic = minim.loadFile("funny-bgm-240795.mp3");
  backgroundMusic.loop(); // Loop the background music
  
  
  // Load custom font (We've downloaded it from google fonts)
  gameFont = createFont("YujiMai-Regular.ttf", 20); // Replace with downloaded font file
  textFont(gameFont); // Apply font to text
  
  // Load images from sketch folder whith their paths
  bugImage = loadImage("ladybird-297875_1280.png");              
  sickBugImage = loadImage("pngtree-illustration-of-a-cartoon-bug-png-image_11455019.png");     
  backgroundImage = loadImage("flowers-5181243_1280-ezgif.com-webp-to-jpg-converter (1).jpg"); 
  background2 = loadImage("flower-field-green-grass-with-mountain-backdrop-sunset-time_1308-64114.jpg");
  bgImage = loadImage("background.jpg");
  
  // Initialize the positions of the text 
  startTextY = 500;  // Set the starting Y position of "press any key to Start" text
  titleY = 200;        // Set the starting Y position of the "SHUTTER BUG" title
  
  
  
  // Create clouds 
  for (int i = 0; i < 5; i++) {
    clouds.add(new Cloud(width + random(100, 300), random(height / 2)));
  }
  
  // Create initial bugs randomly
  for (int i = 0; i < 10; i++) {
    bugs.add(new Bug(random(width), random(height)));
  }
  
  
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Main game loop
void draw() {
  
  if (showWelcomeScreen) {
    showWelcomeScreen();
    return;
  }
  
  else if (showGuideScreen) {
    showGuideScreen();
    return;
  }
  else if (gameStarted) {
  if (level == 2 && score == 15) {
    showCompletionMessage(); // Display completion message for Level 2
  } else {
    gameStarted();
    // Start the timer when the game starts
    if (!timerStarted) {
      startTime = millis();
      timerStarted = true;
    }
  }
}

  
   
}


//Game Logic
void gameStarted() {
  
  
  if (level == 1) {
    image(backgroundImage, 0, 0, width, height); // Level 1 background full screen
  } else if (level == 2) {
    image(background2, 0, 0, width, height); // Level 2 background
  }
  
  if (levelTransition) {
    showLevelTransition();
    return;
  }
  
  // Timer countdown and remaining time conditions
  int remainingTime = timer - (millis() - startTime) / 1000;
  if (remainingTime <= 0) {
    gameOver();
    return;
  }
  
  if (level == 1 && score == 10) {
    startLevelTransition(); // Transition to Level 2
    return;
  }
  
  if (level == 2 && score == 15) {
    showCompletionMessage(); // Display completion message for Level 2
    return;
  }
  
  
  // Display timer and score
  fill(0);
  textSize(20); // Font size for text
  textAlign(LEFT, TOP); // Align text to the top left corner so that it didn't cropped out of the screen

  // Display Level
   text("Level: " + level, 10, 10);

  // Display Score
  text("Score: " + score, 10, 40);
  
  // Display Remaining Time
  textAlign(RIGHT, TOP); // Align text to the top right corner
  text("Time: " + remainingTime, 990, 10);

  
  // Draw and update bugs
  for (int i = 0; i < bugs.size(); i++) { 
  Bug b = bugs.get(i); // Retrieve the Bug at index i
  b.move();
  b.display();
}
  
  // Draw clouds
  for (int i=0; i<clouds.size(); ++i) {
    Cloud c = clouds.get(i);
    c.move();
    c.display();
  }
  
  // Draw sick bugs in Level 2
  if (level == 2) {
    for (int i=0; i<sickBugs.size(); ++i ) {
      SickBug sb =sickBugs.get(i);
      sb.move();
      sb.display();
    }
  }
  
  
  // Draw the camera viewfinder
  noFill();
  stroke(0);
  rect(mouseX - 30, mouseY - 30, 60, 60); // viewfinder (60x60)
  
  // Handle capturing bugs
  if (mousePressed) {
    captureBugs();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void showGuideScreen() {
  // Light green background
  noStroke();
  fill(144, 238, 144); // Light green
  rect(0, 0, 1000,600);
  fill(255, 255, 255, 200); // Semi-transparent white to show the text
  rect(50, 50,  900, 500, 20); //20 for rounded angle
  
  // display instructions
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Welcome to Shutter Bug!", 500, 200);
  text("Click on bugs to capture them and earn points!", 500, 300);
  text("Avoid clicking on sick bugs !", 500, 400);
  
 // Click to start the game (button)
  fill(0, 100, 0); // Semi-transparent green
  rect(400, 450, 200, 50); // Rectangle to click on
  fill(255);
  textSize(20);
  text("Click to Start", 500, 475);
  

  // Check if the mouse is clicked on the start button
  if (mousePressed && mouseX > 400 && mouseX <600 &&
      mouseY > 450 && mouseY < 500) {
    showGuideScreen = false;
    gameStarted = true;
  
}


}



// Show welcome screen
void showWelcomeScreen() {
  image(bgImage, 0, 0, 1000, 600);

  // Draw moving bug
  PImage bugImage = loadImage("ladybird-297875_1280.png"); 
   bugX += bugMovementSpeed; // Bug moves to the right
   bugY = height / 2 + sin(bugX * 0.05) * 20; // Vertical movement of the bug for a bouncing effect
   
   if (bugX > 1000) { 
   bugX = -50;
 } // Reset bug position once it goes off screen
 
  image(bugImage, bugX, bugY, 50, 50); // Display bug image
  
  fill(255, 255, 255); // White color for the text
  textAlign(CENTER, CENTER);
  textSize(80); // Set text size larger for better visibility
  text("SHUTTER BUG", 500, titleY); // Draw game title

  //  movement "SHUTTER BUG" title
  titleY += titleSpeed;
  if (titleY > 210 || titleY < 190) {
    titleSpeed *= -1; // Reverse direction when reaching borders
  }

  //  press to start 
  textSize(48);
  text("Press any key to start!", 500, startTextY);
  
  startTextY += startTextSpeed;
  
  if (startTextY > height - 80 || startTextY < height - 120) {
    startTextSpeed *= -1; // Reverse direction when reaching the top or bottom
  }

  // Check for key press to start the game
  if (keyPressed) {
    showWelcomeScreen = false;
    showGuideScreen = true;  }
}



// Handle capturing bugs when the mouse is pressed
void captureBugs() {
  for (int i = bugs.size() - 1; i >= 0; i--) {
    Bug b = bugs.get(i);
    // Check if bug is inside the viewfinder
    if (mouseX - 30 < b.x && b.x < mouseX + 30 &&
        mouseY - 30 < b.y && b.y < mouseY + 30) {
      bugs.remove(i);  // Remove the bug
      score++;         // Increment score
    }
  }
  
  if (level == 2) {
    for (int i = sickBugs.size() - 1; i >= 0; i--) {
      SickBug sb = sickBugs.get(i);
      // Check if sick bug is inside the viewfinder to be catched
      if (mouseX - 30 < sb.x && sb.x < mouseX + 30 &&
          mouseY - 30 < sb.y && sb.y < mouseY + 30) {
        gameOver(); // Game over if a sick bug is clicked
        return;
      }
    }
  }
}


// Start level transition
void startLevelTransition() {
  levelTransition = true;
  startTime = millis();
}



// Show level transition screen
void showLevelTransition() {
  
   // Half light blue and half light green background
  noStroke();
  fill(173, 216, 230); // Light blue
  rect(0, 0, 1000, 300); // Top half
  fill(144, 238, 144); // Light green
  rect(0, 300, 1000, 300); // Bottom half
  textSize(32);
  textAlign(CENTER, CENTER);
  fill(0);
  
  if (level == 1) {
    
    text("Hurray! You've completed Level 1!", 500, 280);
    text("Get ready for Level 2!", 500, 320);
    if (millis() - startTime > 3000) { // Show message for 3 seconds
      level = 2;
      levelTransition = false;
      startLevelTwo();
    }
  }
}

float angle = 0; // Initialize rotation angle

void showCompletionMessage() {
  noStroke();
  
  fill(173, 216, 230); // Light blue
  rect(0, 0, 1000, 300); // Top half
  fill(144, 238, 144); // Light green
  rect(0, 300, 1000, 300); // Bottom half

  // Static text
  textSize(32);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Hurray! You've completed Level 2!", 500, 180);
  
  // Rotating final score
  pushMatrix(); // Save current transformations
  translate(500, 380); // Move rotation origin to the center of the text
  rotate(angle); // Rotate around the origin
  fill(0);
  text("Final Score: " + score, 0, 0); // Draw rotated text
  popMatrix(); // Restore transformations

  angle += radians(2); // Increment the rotation angle
  
}


// Start Level 2
void startLevelTwo() {
  image(background2, 0, 0, 1000, 600); // Stretch background to fit the screen
  startTime = millis(); // Reset the timer
  score = 0;            // Reset score for Level 2

  // Add more bugs
  for (int i = 0; i < 15; i++) { // Add 20 additional bugs
    bugs.add(new Bug(random(width), random(height)));
  }
  
  // Add sick bugs
  for (int i = 0; i < 5; i++) { // Add 5 sick bugs
    sickBugs.add(new SickBug(random(width), random(height)));
  }
}

// Game over screen
void gameOver() {
  textSize(32);
  textAlign(CENTER, CENTER);
  
  fill(255, 0, 0);  // Red color
  text("Game Over!", 500, 280);
  text("Final Score: " + score, 500, 320);
  
  noLoop(); // Stop the game loop
}

// Bug class
class Bug {
  float x, y;       // Position
  float speedX, speedY; // Speed in x and y directions
  
  // Constructor
  Bug(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-3, 3);
    this.speedY = random(-3, 3);
  }
  
  // Move the bug
  void move() {
    x += speedX;
    y += speedY;
    
    // Bounce off the edges by reversing speed when you reach any of the edges
    if (x < 0 || x > width) speedX *= -1;
    if (y < 0 || y > height) speedY *= -1;
  }
  
  // Display the bug
  void display() {
    image(bugImage, x-15 , y-15 , 30, 30); // Draw the bug image
   }
}

// SickBug class inherits from Bug class
class SickBug extends Bug {
  SickBug(float x, float y) {
    super(x, y);
  }
  
  @Override
  void display() {
    image(sickBugImage, x - 15, y - 15, 30, 30); // Draw the sick bug image
   }
}

// Cloud class
class Cloud {
  float x, y;       // Position
  float speedX;     // Speed in x direction
  
  // Constructor
  Cloud(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-3, -1); // Clouds move left negative values for controlling direction
  }
  
  // Move the cloud
  void move() {
    x += speedX;  //controls horizontally speed
    if (x < -100) {
      x = width + random(100, 300); // when cloud went away from the left side it comes again from the right side
      y = random(300);       // Random vertical position
    }
  }
  
 // Draw and Display the cloud with explicit translation 
void display() {
  pushMatrix(); 
  translate(x, y); // Move the origin to (x, y)
  // Draw the cloud relative to the new origin
  fill(255, 255, 255, 150); // Semi-transparent to see the bugs
  noStroke();
  ellipse(0, 0, 80, 50); // Main body of the cloud
  ellipse(-30, 10, 60, 40); // Left puff
  ellipse(30, 10, 60, 40);  // Right puff

  popMatrix(); // Restoring
}

}
