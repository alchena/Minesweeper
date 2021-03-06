import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < buttons.length; r ++){
        for(int c = 0; c < buttons[r].length; c ++){
            buttons[r][c] = new MSButton(r, c);
        }
    }
    for(int num = 0; num < 40; num++){
        setBombs();
    }
}
public void setBombs(){
    double randomRow = Math.random() * NUM_ROWS;
    double randomCol = Math.random() * NUM_COLS;
        if(bombs.contains(buttons[(int)randomRow][(int)randomCol])){
            randomRow = Math.random() * NUM_ROWS;
            randomCol = Math.random() * NUM_COLS;
            bombs.add(buttons[(int)randomRow][(int)randomCol]);
        }
    bombs.add(buttons[(int)randomRow][(int)randomCol]);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int counterFlag = 0;
    int counterButtons = 0;
    for(int i = 0; i < bombs.size(); i++){
        if(bombs.get(i).isMarked() == true){
            counterFlag++;
        }
    }
    for(int r = 0; r < buttons.length; r ++){
        for(int c = 0; c < buttons[r].length; c++){
            if(buttons[r][c].isClicked() == true){
                counterButtons++;
            }
        }
    }
    if(counterFlag == bombs.size()){
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("Y");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("O");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("U");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("L");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("O");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("S");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("E");
    fill(230);
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("Y");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("O");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("U");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("W");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("I");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("N");
    fill(230);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
            marked = !marked;
            if(marked == false){
                clicked = false;
            }
        }
        else if(bombs.contains(this)){
            displayLosingMessage();
        }
        else if(countBombs(r, c) > 0){
            label =  "" + countBombs(r, c);
        } else {
            for(int row = r - 1; row <= r + 1; row++){
                for(int col = c - 1; col <= c + 1; col++){
                    if(isValid(row, col) && (buttons[row][col].isClicked() == false)){
                        buttons[row][col].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {   
        if((r >= 0 && r < NUM_ROWS) && (c >= 0 && c < NUM_COLS)){
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col){
        int numBombs = 0;
        for(int r = row - 1; r <= row + 1; r++){
            for(int c = col - 1; c <= col + 1; c++){
                if((isValid(r, c) == true) && (bombs.contains(buttons[r][c]))){
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}
