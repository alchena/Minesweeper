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
    for(int num = 0; num < 20; num++){
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
    //your code here
    return false;
}
public void displayLosingMessage()
{
    text("You lose", 200, 100);
    fill(230);
}
public void displayWinningMessage()
{
    //your code here
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
        } else {
            if(isValid(r, c-1) == true && buttons[r][c - 1].isMarked() == false && !bombs.contains(buttons[r][c-1])){
                buttons[r][c-1].mousePressed();
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
        if((r - 1 >= 0 && r + 1 < NUM_ROWS) && (c - 1 >= 0 && c + 1 < NUM_COLS)){
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col){
        int numBombs = 0;
        for(int r = row - 1; r < row + 1; r++){
            for(int c = col - 1; c < col + 1; col++){
                if((isValid(r, c) == true) && (bombs.contains(buttons[r][c]))){
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}


    /*for(int i = 0; i < bombs.size(); i ++){
            for(int r = row - 1; r < row + 1; r++){
                for(int c = col - 1; c < col + 1; c++){
                    if(isValid(r, c) == true){
                       if(buttons[r][c].equals(bombs.get(i))){
                        numBombs++;
                       }
                    }
                }
            }
        }
*/
