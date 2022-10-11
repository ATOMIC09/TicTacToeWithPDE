PFont font;
PrintWriter output;

char PlayerTurn = 'X'; // สร้างตัวแปรเก็บรอบของผู้เล่น (Create a variable to store the round of the player)
char[][] default_board = {{'a','b','c'},{'d','e','f'},{'g','h','i'}}; // สร้าง Array ของ board ดั้งเดิม (Create Array of default board)
char[][] board = {{' ',' ',' '},{' ',' ',' '},{' ',' ',' '}}; // สร้าง Array ของ board (Create Array of board)
boolean isEnd = false; // สร้างตัวแปรเก็บสถานะว่าเกมจบหรือยัง (Create a variable to store the status of whether the game is over or not)
boolean isClicking = false; // สร้างตัวแปรเก็บว่ากำลังคลิกอยู่หรือไม่ (Create a variable to store whether you are clicking or not)ุ
boolean drawLoadArrayToGame = false; // เก็บเงื่อนไนว่ากำลังโหลดเกมอยู่หรือไม่ เพื่อทำ Animation (Store the condition that the game is loading or not to do Animation)
int gameState = 0; // 0 = In Game, 1 = Player X Wins, 2 = Player O Wins, 3 = Tie
int clicked = 0; // กำหนดตัวแปรเพื่อนับจำนวนครั้งที่คลิก (Click counter)

// Hint
int[][] hint_default = {{0,0,0},{0,0,0},{0,0,0}}; // สร้าง Array ของ hint ดั้งเดิม (Create Array of default hint)
int[][] hintBoardX = {{0,0,0},{0,0,0},{0,0,0}}; // 0 = Null, 3 = Danger
int[][] hintBoardO = {{0,0,0},{0,0,0},{0,0,0}}; // 0 = Null, 3 = Danger

boolean isHint = false; // สร้างตัวแปรเก็บสถานะว่าเปิด Hint หรือปิด (Create a variable to store the status of whether the Hint is on or off)

// สร้าง Obejct ที่จะวาดในแต่ละช่อง (Create Obejct that will be drawn in each box)
DrawAnimation x1 = new DrawAnimation(150, 150);
DrawAnimation x2 = new DrawAnimation(300, 150);
DrawAnimation x3 = new DrawAnimation(450, 150);

DrawAnimation x4 = new DrawAnimation(150, 300);
DrawAnimation x5 = new DrawAnimation(300, 300);
DrawAnimation x6 = new DrawAnimation(450, 300);

DrawAnimation x7 = new DrawAnimation(150, 450);
DrawAnimation x8 = new DrawAnimation(300, 450);
DrawAnimation x9 = new DrawAnimation(450, 450);

DrawAnimation o1 = new DrawAnimation(150, 150);
DrawAnimation o2 = new DrawAnimation(300, 150);
DrawAnimation o3 = new DrawAnimation(450, 150);

DrawAnimation o4 = new DrawAnimation(150, 300);
DrawAnimation o5 = new DrawAnimation(300, 300);
DrawAnimation o6 = new DrawAnimation(450, 300);

DrawAnimation o7 = new DrawAnimation(150, 450);
DrawAnimation o8 = new DrawAnimation(300, 450);
DrawAnimation o9 = new DrawAnimation(450, 450);

// View
// สร้างคลาสวาดรูปแบบ Animation (Create a class to draw Animation)
class DrawAnimation{
    int posX;
    int posY;

    // Size for X
    int frameX = 0;
    int frameY = 0;

    // Size for O
    int rad = 0;
    
    DrawAnimation(int posX, int posY){
        this.posX = posX;
        this.posY = posY;
    }

    void drawX(){ // วาด X
        if (frameX < 50){ 
            frameX = frameX + 8; 
            frameY = frameY + 8;

            strokeWeight(7); 
            fill(0, 0, 255);
            line(posX - frameX, posY - frameY, posX + frameX, posY + frameY);
            line(posX - frameX, posY + frameY, posX + frameX, posY - frameY);
        } 
        if (frameX >= 50){ // เมื่อวาดเสร็จแล้ว (If the drawing is complete)
            printBoard();
            checkWin();
            checkTie();
            playerFlip();
            isClicking = false;
            drawLoadArrayToGame = false;
            frameX = 0;
            frameY = 0;
            checkHint();
        }
    }

    void drawO(){ // วาด O
        if (rad < 100){
            rad = rad + 16;
        }
        strokeWeight(7);
        fill(255);
        circle(posX, posY, rad);

        if (rad >= 100){ // เมื่อวาดเสร็จแล้ว (If the drawing is complete)
            printBoard();
            checkWin();
            checkTie();
            playerFlip();
            isClicking = false;
            drawLoadArrayToGame = false;
            rad = 0;
            checkHint();
        }
    }
}


// Controller
void setup(){
    frameRate(144); // Set framerate to 144
    size(600, 700); // Set size to 600x700
    font = loadFont("supermarket-48.vlw"); // Load font
    background(255); // Set background to white
    drawGrid(); // Draw grid
    drawSaveButton(); // Draw save button
    drawLoadButton(); // Draw load button
    drawResetButton(); // Draw reset button
    drawHintDisableButton(); // Draw hint disable button
    resetArray(); // Reset array to default
}

void cleanUpScreen(){ // ล้างหน้าจอ (Clean up screen)
    background(255);
    drawGrid();
    drawSaveButton();
    drawLoadButton();
    drawResetButton();
    drawHintDisableButton();
}

void resetArray(){ //สร้างไว้ดึงตัวอักษรจาก Array ของ default_board ไว้ใน board (Create a board using default_board as a reference)
    int i = 0;
    int j = 0;
    while (j < 3){ // วนลูปตามคอลัมน์ (Looping in columns)
        while (i < 3){ // วนลูปตามแถว (Looping in rows)
            board[i][j] = default_board[i][j]; // นำตัวอักษรจาก default_board ไปใส่ใน board
            hintBoardO[i][j] = hint_default[i][j]; // นำตัวอักษรจาก hint_default ไปใส่ใน hintBoardO
            hintBoardX[i][j] = hint_default[i][j]; // นำตัวอักษรจาก hint_default ไปใส่ใน hintBoardX
            i = i + 1;
        }
        i = 0;
        j = j + 1;
    }
    j = 0;
    isEnd = false; // กำหนดว่าเกมยังไม่จบ (Set game ended as not)
} 

void mousePressed() {
    isClicking = true;
}

void playerFlip(){ // สลับผู้เล่น (Flip player)
    if (PlayerTurn == 'X'){
        PlayerTurn = 'O';
    } else {
        PlayerTurn = 'X';
    }
}

void checkWin(){ // ตรวจสอบว่ามีผู้ชนะหรือไม่ โดยใช้ Array เป็นตัวอ้างอิงตำแหน่ง (Check if someone wins by referring to an array.)
    // แนวนอน (Horizontal)
    if (board[0][0] == board[1][0] && board[1][0] == board[2][0]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }
    if (board[0][1] == board[1][1] && board[1][1] == board[2][1]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }
    if (board[0][2] == board[1][2] && board[1][2] == board[2][2]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }

    // แนวตั้ง (Vertical)
    if (board[0][0] == board[0][1] && board[0][1] == board[0][2]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }
    if (board[1][0] == board[1][1] && board[1][1] == board[1][2]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }
    if (board[2][0] == board[2][1] && board[2][1] == board[2][2]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }

    // แนวทแยง (Diagonal)
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0]){
        if (PlayerTurn == 'X'){
            gameState = 1;
        } else {
            gameState = 2;
        }
    }
}

void checkClicked(){ // เช็คว่าเล่นไปแล้วกี่ช่อง (Count how many channels have been used)
    int i = 0;
    int j = 0;
    clicked = 0; // กำหนดให้เป็น 0 ทุกครั้งที่เรียก (ไม่งั้นค่ามันจะบวกกันไปเรื่อย ๆ) (Set zero every time it is called (otherwise the value will be added))
    while (j < 3){
        while (i < 3){
            if (board[i][j] == 'X' || board[i][j] == 'O'){ // ตรวจว่าในแต่ละช่องมี X หรือ O หรือไม่ (เพราะตอนแรกจะใส่เป็น a,b,c,d,e,f,g,h,i เพื่อให้แต่ละช่องไม่ซ้ำกันเลย) (Check if there is X or O in each cell (because at first it will be a, b, c, d, e, f, g, h, i so that each cell is not the same))
                clicked = clicked + 1;
            }
            i = i + 1;
        }
        i = 0;
        j = j + 1;
    }
    j = 0;
}

void checkTie(){ // ตรวจสอบว่าเสมอหรือไม่ (Check if it is a tie)
    checkClicked(); // เรียกใช้งานฟังก์ชัน checkClicked (Call checkClicked function)

    if (clicked == 9){ // ถ้าใช้แล้ว 9 ช่อง (ครบทุกช่อง) (If game end without any player winning)
        gameState = 3; // กำหนดเป็นเกมเสมอ (Set game state as tie)
    }
}

void checkHint(){ // ตรวจสอบว่าสามารถใบ้ได้หรือไม่ (Check if it can be hinted)
    if (isHint == true){ // ถ้า isHint เป็น true (ถ้าเปิดใช้ Hint แล้ว) 
        // Check to block
        // Vertical 4-7
        if (board[0][1] == board[0][2] && board[0][0] != 'X' && board[0][0] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[0][0] = 3;
            } else {
                hintBoardX[0][0] = 3;
            }
        }
        else{
            // Diagonal 5-9
            if (board[1][1] == board[2][2] && board[0][0] != 'X' && board[0][0] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[0][0] = 3;
                } else {
                    hintBoardX[0][0] = 3;
                }
            }
            else{
                // Horizontal 2-3
                if (board[1][0] == board[2][0] && board[0][0] != 'X' && board[0][0] != 'O'){
                    if (PlayerTurn == 'X'){
                        hintBoardO[0][0] = 3;
                    } else {
                        hintBoardX[0][0] = 3;
                    }
                }
                else{
                    hintBoardO[0][0] = 0;
                    hintBoardX[0][0] = 0;
                }
            }
        }

        // Vertical 1-7
        if (board[0][0] == board[0][2] && board[0][1] != 'X' && board[0][1] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[0][1] = 3;
            } else {
                hintBoardX[0][1] = 3;
            }
        }
        else{
            // Horizontal 5-6
            if (board[1][1] == board[2][1] && board[0][1] != 'X' && board[0][1] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[0][1] = 3;
                } else {
                    hintBoardX[0][1] = 3;
                }
            }
            else{
                hintBoardO[0][1] = 0;
                hintBoardX[0][1] = 0;
            }
        }

        // Vertical 1-4
        if (board[0][0] == board[0][1] && board[0][2] != 'X' && board[0][2] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[0][2] = 3;
            } else {
                hintBoardX[0][2] = 3;
            }
        }
        else{
            // Diagonal 5-7
            if (board[1][1] == board[2][0] && board[0][2] != 'X' && board[0][2] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[0][2] = 3;
                } else {
                    hintBoardX[0][2] = 3;
                }
            }
            else{
                // Horizontal 8-9
                if (board[1][2] == board[2][2] && board[0][2] != 'X' && board[0][2] != 'O'){
                    if (PlayerTurn == 'X'){
                        hintBoardO[0][2] = 3;
                    } else {
                        hintBoardX[0][2] = 3;
                    }
                }
                else{
                    hintBoardO[0][2] = 0;
                    hintBoardX[0][2] = 0;
                }
            }
        }

        // Vertical 5-8
        if (board[1][1] == board[1][2] && board[1][0] != 'X' && board[1][0] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[1][0] = 3;
            } else {
                hintBoardX[1][0] = 3;
            }
        }
        else{
            // Horizontal 1-3
            if (board[0][0] == board[2][0] && board[1][0] != 'X' && board[1][0] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[1][0] = 3;
                } else {
                    hintBoardX[1][0] = 3;
                }
            }
            else{
                hintBoardO[1][0] = 0;
                hintBoardX[1][0] = 0;
            }
        }

        // Vertical 2-8
        if (board[1][0] == board[1][2] && board[1][1] != 'X' && board[1][1] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[1][1] = 3;
            } else {
                hintBoardX[1][1] = 3;
            }
        }
        else{
            // Diagonal 1-9
            if (board[0][0] == board[2][2] && board[1][1] != 'X' && board[1][1] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[1][1] = 3;
                } else {
                    hintBoardX[1][1] = 3;
                }
            }
            else{
                // Diagonal 3-7
                if (board[0][2] == board[2][0] && board[1][1] != 'X' && board[1][1] != 'O'){
                    if (PlayerTurn == 'X'){
                        hintBoardO[1][1] = 3;
                    } else {
                        hintBoardX[1][1] = 3;
                    }
                }
                else{
                    // Horizontal 4-6
                    if (board[0][1] == board[2][1] && board[1][1] != 'X' && board[1][1] != 'O'){
                        if (PlayerTurn == 'X'){
                            hintBoardO[1][1] = 3;
                        } else {
                            hintBoardX[1][1] = 3;
                        }
                    }
                    else{
                        hintBoardO[1][1] = 0;
                        hintBoardX[1][1] = 0;
                    }
                }
            }
        }

        // Vertical 2-5
        if (board[1][0] == board[1][1] && board[1][2] != 'X' && board[1][2] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[1][2] = 3;
            } else {
                hintBoardX[1][2] = 3;
            }
        }
        else{
            // Horizontal 7-9
            if (board[0][2] == board[2][2] && board[1][2] != 'X' && board[1][2] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[1][2] = 3;
                } else {
                    hintBoardX[1][2] = 3;
                }
            }
            else{
                hintBoardO[1][2] = 0;
                hintBoardX[1][2] = 0;
            }
        }

        // Vertical 6-9
        if (board[2][1] == board[2][2] && board[2][0] != 'X' && board[2][0] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[2][0] = 3;
            } else {
                hintBoardX[2][0] = 3;
            }
        }
        else{
            // Diagonal 3-5
            if (board[0][2] == board[1][1] && board[2][0] != 'X' && board[2][0] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[2][0] = 3;
                } else {
                    hintBoardX[2][0] = 3;
                }
            }
            else{
                // Horizontal 1-2
                if (board[0][0] == board[1][0] && board[2][0] != 'X' && board[2][0] != 'O'){
                    if (PlayerTurn == 'X'){
                        hintBoardO[2][0] = 3;
                    } else {
                        hintBoardX[2][0] = 3;
                    }
                }
                else{
                    hintBoardO[2][0] = 0;
                    hintBoardX[2][0] = 0;
                }
            }
        }

        // Vertical 3-9
        if (board[2][0] == board[2][2] && board[2][1] != 'X' && board[2][1] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[2][1] = 3;
            } else {
                hintBoardX[2][1] = 3;
            }
        }
        else{
            // Horizontal 4-5
            if (board[0][1] == board[1][1] && board[2][1] != 'X' && board[2][1] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[2][1] = 3;
                } else {
                    hintBoardX[2][1] = 3;
                }
            }
            else{
                hintBoardO[2][1] = 0;
                hintBoardX[2][1] = 0;
            }
        }

        // Vertical 3-6
        if (board[2][0] == board[2][1] && board[2][2] != 'X' && board[2][2] != 'O'){
            if (PlayerTurn == 'X'){
                hintBoardO[2][2] = 3;
            } else {
                hintBoardX[2][2] = 3;
            }
        }
        else{
            // Diagonal 1-5
            if (board[0][0] == board[1][1] && board[2][2] != 'X' && board[2][2] != 'O'){
                if (PlayerTurn == 'X'){
                    hintBoardO[2][2] = 3;
                } else {
                    hintBoardX[2][2] = 3;
                }
            }
            else{
                // Horizontal 7-8
                if (board[0][2] == board[1][2] && board[2][2] != 'X' && board[2][2] != 'O'){
                    if (PlayerTurn == 'X'){
                        hintBoardO[2][2] = 3;
                    } else {
                        hintBoardX[2][2] = 3;
                    }
                }
                else{
                    hintBoardO[2][2] = 0;
                    hintBoardX[2][2] = 0;
                }
            }
        }

        displayHint();
        printHintO();
        printHintX();
    }
}
    

// View
void draw(){
    // Load Animation
    if (drawLoadArrayToGame == true){
        if (board[0][0] == 'X'){
            x1.drawX();
        }
        if (board[1][0] == 'X'){
            x2.drawX();
        }
        if (board[2][0] == 'X'){
            x3.drawX();
        }
        if (board[0][1] == 'X'){
            x4.drawX();
        }
        if (board[1][1] == 'X'){
            x5.drawX();
        }
        if (board[2][1] == 'X'){
            x6.drawX();
        }
        if (board[0][2] == 'X'){
            x7.drawX();
        }
        if (board[1][2] == 'X'){
            x8.drawX();
        }
        if (board[2][2] == 'X'){
            x9.drawX();
        }
        if (board[0][0] == 'O'){
            o1.drawO();
        }
        if (board[1][0] == 'O'){
            o2.drawO();
        }
        if (board[2][0] == 'O'){
            o3.drawO();
        }
        if (board[0][1] == 'O'){
            o4.drawO();
        }
        if (board[1][1] == 'O'){
            o5.drawO();
        }
        if (board[2][1] == 'O'){
            o6.drawO();
        }
        if (board[0][2] == 'O'){
            o7.drawO();
        }
        if (board[1][2] == 'O'){
            o8.drawO();
        }
        if (board[2][2] == 'O'){
            o9.drawO();
        }
    }

    // Check game state
    if (gameState == 0){
        fill(0);
        noStroke();
        rect(0,0,600,65);
        stroke(0);

        fill(255);
        textFont(font);
        textSize(30);
        textAlign(CENTER);
        text("Player : " + PlayerTurn + "", width/2, 45);

        if (isClicking == true){
            // Check if mouse is in the play area
            if (mouseX > 75 && mouseX < 525 && mouseY > 75 && mouseY < 525){
                removeHint();
                // Check if mouse is in the grid
                if (mouseX > 75 && mouseX < 225 && mouseY > 75 && mouseY < 225){
                    if (PlayerTurn == 'X'){
                        board[0][0] = 'X';
                        x1.drawX();
                    } else {
                        board[0][0] = 'O';
                        o1.drawO();
                    }
                }

                if (mouseX > 225 && mouseX < 375 && mouseY > 75 && mouseY < 225){
                    if (PlayerTurn == 'X'){
                        board[1][0] = 'X';
                        x2.drawX();
                    } else {
                        board[1][0] = 'O';
                        o2.drawO();
                    }
                }

                if (mouseX > 375 && mouseX < 525 && mouseY > 75 && mouseY < 225){
                    if (PlayerTurn == 'X'){
                        board[2][0] = 'X';
                        x3.drawX();
                    } else {
                        board[2][0] = 'O';
                        o3.drawO();
                    }
                }

                if (mouseX > 75 && mouseX < 225 && mouseY > 225 && mouseY < 375){
                    if (PlayerTurn == 'X'){
                        board[0][1] = 'X';
                        x4.drawX();
                    } else {
                        board[0][1] = 'O';
                        o4.drawO();
                    }
                }

                if (mouseX > 225 && mouseX < 375 && mouseY > 225 && mouseY < 375){
                    if (PlayerTurn == 'X'){
                        board[1][1] = 'X';
                        x5.drawX();
                    } else {
                        board[1][1] = 'O';
                        o5.drawO();
                    }
                }

                if (mouseX > 375 && mouseX < 525 && mouseY > 225 && mouseY < 375){
                    if (PlayerTurn == 'X'){
                        board[2][1] = 'X';
                        x6.drawX();
                    } else {
                        board[2][1] = 'O';
                        o6.drawO();
                    }
                }

                if (mouseX > 75 && mouseX < 225 && mouseY > 375 && mouseY < 525){
                    if (PlayerTurn == 'X'){
                        board[0][2] = 'X';
                        x7.drawX();
                    } else {
                        board[0][2] = 'O';
                        o7.drawO();
                    }
                }

                if (mouseX > 225 && mouseX < 375 && mouseY > 375 && mouseY < 525){
                    if (PlayerTurn == 'X'){
                        board[1][2] = 'X';
                        x8.drawX();
                    } else {
                        board[1][2] = 'O';
                        o8.drawO();
                    }
                }

                if (mouseX > 375 && mouseX < 525 && mouseY > 375 && mouseY < 525){
                    if (PlayerTurn == 'X'){
                        board[2][2] = 'X';
                        x9.drawX();
                    } else {
                        board[2][2] = 'O';
                        o9.drawO();
                    }
                }
            }
            else{
                println("Out of play area");
                isClicking = false;
            }
            // Check if mouse in the save button
            if (mouseX > 0 && mouseX < 200 && mouseY > 630 && mouseY < 700){
                println("Save");
                fill(194,71,62);
                rect(2, 630, 200, 68);

                saveGame();
                isClicking = false;
            }
            // Check if mouse in the reset button
            if (mouseX > 200 && mouseX < 400 && mouseY > 630 && mouseY < 700){
                println("Reset");
                fill(207,207,0);
                rect(200, 630, 200, 68);

                isHint = false;
                cleanUpScreen();
                resetArray();
                isClicking = false;
            }
            // Check if mouse in the load button
            if (mouseX > 400 && mouseX < 600 && mouseY > 630 && mouseY < 700){
                println("Load");
                fill(82,219,121);
                rect(398, 630, 200, 68);

                isHint = false;
                loadLastGame();
                isClicking = false;
            }
            // Check if mouse in the hint button
            if (mouseX > 250 && mouseX < 350 && mouseY > 543 && mouseY < 611){
                println("Hint");

                if (isHint == false){
                    drawHintEnableButton();
                    isHint = true;
                }
                else{
                    drawHintDisableButton();
                    isHint = false;
                }

                isClicking = false;
            }
        }
    }

    if (gameState == 1){ // Player X win
        background(230,71,62);

        fill(255);
        textFont(font);
        textSize(50);
        textAlign(CENTER);

        text("Player X Wins!", width/2, height/2);

        if (isClicking == true){
            cleanUpScreen();
            resetArray();
            isClicking = false;
            gameState = 0;
        }
    }

    if (gameState == 2){ // Player O win
        background(82,210,121);

        fill(255);
        textFont(font);
        textSize(50);
        textAlign(CENTER);

        text("Player O Wins!", width/2, height/2);

        if (isClicking == true){
            cleanUpScreen();
            resetArray();
            isClicking = false;
            gameState = 0;
        }
    }

    if (gameState == 3){ // Tie
        background(185,185,185);

        fill(255);
        textFont(font);
        textSize(50);
        textAlign(CENTER);

        text("It's a Tie!", width/2, height/2);

        if (isClicking == true){
            cleanUpScreen();
            resetArray();
            isClicking = false;
            gameState = 0;
        }
    }
}

void drawGrid(){ // วาดตาราง (Draw grid)
    background(255);
    fill(0);
    strokeWeight(7);
    // Outer lines
    line(75, 75, 75, 525);
    line(75, 525, 525, 525);
    line(75, 75, 525, 75);
    line(525, 75, 525, 525);
    // Inner lines
    line(225, 75, 225, 525);
    line(375, 75, 375, 525);
    line(75, 225, 525, 225);
    line(75, 375, 525, 375);
}

void drawSaveButton(){ // วาดปุ่ม Save (Draw save button)
    fill(72,170,255);
    stroke(0);
    strokeWeight(5);
    rect(2, 630, 200, 68);
    fill(0);
    textFont(font);
    textSize(30);
    textAlign(CENTER);
    text("Save", 100, 675);
}

void drawLoadButton(){ // วาดปุ่ม Load (Draw load button)
    fill(255,93,193);
    stroke(0);
    strokeWeight(5);
    rect(398, 630, 200, 68);
    fill(0);
    textFont(font);
    textSize(30);
    textAlign(CENTER);
    text("Load", 500, 675);
}   

void drawResetButton(){ // วาดปุ่ม Reset (Draw reset button)
    fill(255,255,0);
    stroke(0);
    strokeWeight(5);
    rect(200, 630, 200, 68);
    fill(0);
    textFont(font);
    textSize(30);
    textAlign(CENTER);
    text("Reset", 300, 675);
}

void drawHintDisableButton(){ // วาดปุ่ม Hint แบบปิด (Draw hint disable button)
    fill(255,71,62);
    stroke(0);
    strokeWeight(5);
    rect(250, 543, 100, 68, 10);
    fill(0);
    textFont(font);
    textSize(30);
    textAlign(CENTER);
    text("Hint", 300, 587);
}

void drawHintEnableButton(){ // วาดปุ่ม Hint แบบเปิด (Draw hint enable button)
    fill(82,255,121);
    stroke(0);
    strokeWeight(5);
    rect(250, 543, 100, 68, 10);
    fill(0);
    textFont(font);
    textSize(30);
    textAlign(CENTER);
    text("Hint", 300, 587);
}

void displayHint(){ // แสดงผล Hint (Show Hint)
    // Hint to block
    if (PlayerTurn == 'X'){
        fill(254,97,101);
        if (hintBoardO[0][0] == 3 && board[0][0] != 'X' && board[0][0] != 'O'){
            rect(75,75,150,150);
        }
        if (hintBoardO[1][0] == 3 && board[1][0] != 'X' && board[1][0] != 'O'){
            rect(225,75,150,150);
        }
        if (hintBoardO[2][0] == 3 && board[2][0] != 'X' && board[2][0] != 'O'){
            rect(375,75,150,150);
        }
        if (hintBoardO[0][1] == 3 && board[0][1] != 'X' && board[0][1] != 'O'){
            rect(75,225,150,150);
        }
        if (hintBoardO[1][1] == 3 && board[1][1] != 'X' && board[1][1] != 'O'){
            rect(225,225,150,150);
        }
        if (hintBoardO[2][1] == 3 && board[2][1] != 'X' && board[2][1] != 'O'){
            rect(375,225,150,150);
        }
        if (hintBoardO[0][2] == 3 && board[0][2] != 'X' && board[0][2] != 'O'){
            rect(75,375,150,150);
        }
        if (hintBoardO[1][2] == 3 && board[1][2] != 'X' && board[1][2] != 'O'){
            rect(225,375,150,150);
        }
        if (hintBoardO[2][2] == 3 && board[2][2] != 'X' && board[2][2] != 'O'){
            rect(375,375,150,150);
        }
    }
    else{
        fill(254,97,101);
        if (hintBoardX[0][0] == 3 && board[0][0] != 'X' && board[0][0] != 'O'){
            rect(75,75,150,150);
        }
        if (hintBoardX[1][0] == 3 && board[1][0] != 'X' && board[1][0] != 'O'){
            rect(225,75,150,150);
        }
        if (hintBoardX[2][0] == 3 && board[2][0] != 'X' && board[2][0] != 'O'){
            rect(375,75,150,150);
        }
        if (hintBoardX[0][1] == 3 && board[0][1] != 'X' && board[0][1] != 'O'){
            rect(75,225,150,150);
        }
        if (hintBoardX[1][1] == 3 && board[1][1] != 'X' && board[1][1] != 'O'){
            rect(225,225,150,150);
        }
        if (hintBoardX[2][1] == 3 && board[2][1] != 'X' && board[2][1] != 'O'){
            rect(375,225,150,150);
        }
        if (hintBoardX[0][2] == 3 && board[0][2] != 'X' && board[0][2] != 'O'){
            rect(75,375,150,150);
        }
        if (hintBoardX[1][2] == 3 && board[1][2] != 'X' && board[1][2] != 'O'){
            rect(225,375,150,150);
        }
        if (hintBoardX[2][2] == 3 && board[2][2] != 'X' && board[2][2] != 'O'){
            rect(375,375,150,150);
        }
    }
}

void removeHint(){ // ลบ Hint (Remove Hint)
    fill(255);

    if (hintBoardX[0][0] == 3 || hintBoardO[0][0] == 3 && board[0][0] != 'X' && board[0][0] != 'O'){
        rect(75,75,150,150);
    }
    if (hintBoardX[1][0] == 3 || hintBoardO[1][0] == 3 && board[1][0] != 'X' && board[1][0] != 'O'){
        rect(225,75,150,150);
    }
    if (hintBoardX[2][0] == 3 || hintBoardO[2][0] == 3 && board[2][0] != 'X' && board[2][0] != 'O'){
        rect(375,75,150,150);
    }
    if (hintBoardX[0][1] == 3 || hintBoardO[0][1] == 3 && board[0][1] != 'X' && board[0][1] != 'O'){
        rect(75,225,150,150);
    }
    if (hintBoardX[1][1] == 3 || hintBoardO[1][1] == 3 && board[1][1] != 'X' && board[1][1] != 'O'){
        rect(225,225,150,150);
    }
    if (hintBoardX[2][1] == 3 || hintBoardO[2][1] == 3 && board[2][1] != 'X' && board[2][1] != 'O'){
        rect(375,225,150,150);
    }
    if (hintBoardX[0][2] == 3 || hintBoardO[0][2] == 3 && board[0][2] != 'X' && board[0][2] != 'O'){
        rect(75,375,150,150);
    }
    if (hintBoardX[1][2] == 3 || hintBoardO[1][2] == 3 && board[1][2] != 'X' && board[1][2] != 'O'){
        rect(225,375,150,150);
    }
    if (hintBoardX[2][2] == 3 || hintBoardO[2][2] == 3 && board[2][2] != 'X' && board[2][2] != 'O'){
        rect(375,375,150,150);
    }
    fill(0);
}


// Model
void saveGame(){ // บันทึกเกม (Save game)
    output = createWriter("save.txt");

    int i = 0;
    int j = 0;
    println("File Saved");
    while (j < 3){
        while (i < 3){
            output.print(board[i][j]); // บันทึกสมาชิก Array ของ board ลงในไฟล์ (Save array board to file)
            print(board[i][j]);
            
            if (i < 2){
                output.print(","); // ถ้าไม่ใช่สมาชิกสุดท้ายในแถว ให้ใส่เครื่องหมาย , คั่นสมาชิกแต่ละตัว (If not the last member in the row, put a comma)
                print(",");
            }
            i = i + 1;
        }
        i = 0;
        j = j + 1;
    if (j < 3){ 
        output.print(",");
        print(",");
    }
    }
    j = 0;
    output.print("," + PlayerTurn);
    println();

    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    drawSaveButton();
}

void loadLastGame(){ // โหลดเกม มาเก็บใน Array board (Load game to array board)
    BufferedReader reader = createReader("save.txt");
    String line = null;
    try {
        while ((line = reader.readLine()) != null) {
            String[] element = split(line, ","); // แยกค่าด้วยเครื่องหมาย , (Split the value with the , symbol)
            board[0][0] = element[0].charAt(0); // เอาค่าในตำแหน่งที่ 0 ของ Array element มาใส่ในตำแหน่งที่ 0 ของ Array board (Put the value in position 0 of the Array element into position 0 of the Array board)
            board[1][0] = element[1].charAt(0);
            board[2][0] = element[2].charAt(0);
            board[0][1] = element[3].charAt(0);
            board[1][1] = element[4].charAt(0);
            board[2][1] = element[5].charAt(0);
            board[0][2] = element[6].charAt(0);
            board[1][2] = element[7].charAt(0);
            board[2][2] = element[8].charAt(0);
            PlayerTurn = element[9].charAt(0);
        }
        reader.close();
        
        cleanUpScreen();
        printFileLoaded();
        drawLoadArrayToGame = true;
    }
    catch (IOException e) {
        e.printStackTrace();
    }
}


// Debug
void printBoard(){
    int i = 0;
    int j = 0;
    println("Board");
    while (j < 3){
        while (i < 3){
            print("[",i,"]","[",j,"]",board[i][j]);
            
            if (i < 2){
                print("   |   ");
            }
            i = i + 1;
        }
        i = 0;
        j = j + 1;

    println();
    }
    j = 0;
    println();
}

void printHintX(){
    int i = 0;
    int j = 0;
    println("Hint X");
    while (j < 3){
        while (i < 3){
            print("[",i,"]","[",j,"]",hintBoardX[i][j]);
            
            if (i < 2){
                print("   |   ");
            }
            i = i + 1;
        }
        i = 0;
        j = j + 1;

    println();
    }
    j = 0;
    println();
}

void printHintO(){
    int i = 0;
    int j = 0;
    println("Hint O");
    while (j < 3){
        while (i < 3){
            print("[",i,"]","[",j,"]",hintBoardO[i][j]);
            
            if (i < 2){
                print("   |   ");
            }
            i = i + 1;
        }
        i = 0;
        j = j + 1;

    println();
    }
    j = 0;
    println();
}

void printFileLoaded(){ 
    int i = 0;
    int j = 0;
    println("File Loaded");
    while (j < 3){
        while (i < 3){
            print(board[i][j]);
            if (i < 2){
                print(",");
            }
            i = i + 1;
        }
        i = 0;
        j = j + 1;
    if (j < 3){
        print(",");
    }
    }
    j = 0;
    println();
}
