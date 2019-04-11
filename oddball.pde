import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress scsend;

int backgroundColor = 0;
PFont f, f2;
int now;
int elapsed;
int letter = int(random(6))+65;
int trigSize = 30;
Table table;
int idx = 0;
TableRow row;
TableRow row_next;
int t;
int t_next;
boolean sendStuff = true;
PrintWriter output;


void setup() {
  //size(800, 800);
  fullScreen(2);
  frameRate(60);
  oscP5 = new OscP5(this, 12000);
  scsend = new NetAddress("127.0.0.1", 57120);
  //printArray(PFont.list());
  f = createFont("Arial", pow(2, 10));
  f2 = createFont("Arial", pow(2, 7));
  textFont(f);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(abs(255-backgroundColor));
  table = loadTable("events.csv");
  row = table.getRow(idx);
  row_next = table.getRow(idx+1);
  now = millis();
  t = row.getInt(0);
  t_next = row_next.getInt(0);
  TableRow last_row = table.getRow(table.getRowCount()-1);
  int last_t = last_row.getInt(0);
  println(last_row.getInt(0));
  println(table.getRowCount());
  last_row.setInt(0, last_t+3000);
  last_row.setString(3, "/end");
  table.addRow(last_row);
  println(last_row.getInt(0));
  println(table.getRowCount());
  noCursor();
  noStroke();
  output = createWriter("responses.txt");
} 


void draw() {
  elapsed = millis()-now;
  noCursor();
  background(backgroundColor);
  fill(0);
  ellipse(width-24, 16, trigSize, trigSize);

  if ((elapsed >= t) && (idx < table.getRowCount()-1))
  {  
    if (elapsed <= t_next - 200)
    { 
      if (sendStuff &&  row.getString(3).equals("/sound"))
      {
        OscMessage myMessage = new OscMessage(row.getString(3));
        myMessage.add(row.getString(5));
        myMessage.add(row.getString(6));
        oscP5.send(myMessage, scsend);
        sendStuff= false;
      } else if (row.getString(3).equals("/instruction"))
      {
        if (elapsed-t <= row.getInt(6))
        {
          fill(50, 205, 50);
          textFont(f2);
          text("Respond on letter", width/2, 0.1*height);
          textFont(f);
          text(char(row.getInt(2)+65), width/2, 0.9*height/2);
        }
      } else if (row.getString(3).equals("/oddball"))
      {
        textFont(f);
        fill(abs(255-backgroundColor));
        // draw letter
        if (elapsed-t <= row.getInt(6))
        {
          text(char(row.getInt(2)+65), width/2, 0.9*height/2);
        }

        // draw trigger signal
        if (elapsed-t <= (row.getInt(2)*100+200))
        {
          fill(255);
          ellipse(width-24, 16, trigSize, trigSize);
          fill(0);
        }
      } 
      //else if (row_next.getString(3).equals("/end"))
      //{
      //  output.flush(); // Writes the remaining data to the file
      //  output.close(); // Finishes the file
      //  exit(); // Stops the program
      //}
    } else if (idx < table.getRowCount()-2)// next event
    {
      idx += 1;
      row = table.getRow(idx);
      t = row.getInt(0);
      row_next = table.getRow(idx+1);
      t_next = row_next.getInt(0);
      /* letter = chooseLetter(row.getInt(2)); */
      sendStuff = true;
    }
  }
}


int chooseLetter(int event) {
  int newLetter = letter;
  if (event == 1) {
    newLetter = int(random(5))+65;
    while (newLetter == letter) 
    {
      newLetter = int(random(5))+65;
    };
    //trigPos.set(0, width-trigSize);
    //trigPos.set(1, height-trigSize);
    //trigPos.set(2, width);
    //trigPos.set(3, height);
  } else
  {
    //trigPos.set(0, width-trigSize);
    //trigPos.set(1, trigSize);
    //trigPos.set(2, width);
    //trigPos.set(3, 0);
  }
  return newLetter;
}

void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  //exit(); // Stops the program
}

void mousePressed() {
  output.println(
    idx + ", "
    + elapsed + ", "
    + (elapsed-t) + ", "
    + int(mouseButton == RIGHT) + ", " 
    + int(row.getInt(2)==row.getInt(4))
    );
}
//void keyPressed() {
//  OscMessage myMessage = new OscMessage("/event");
//  myMessage.add(1); /* add an int to the osc message */
//  myMessage.add(100);
//  /* send the message */
//  oscP5.send(myMessage, scsend);
//}


//void mousePressed() {
//  OscMessage myMessage = new OscMessage("/event");
//  myMessage.add(0); /* add an int to the osc message */
//  myMessage.add(100);
//  /* send the message */
//  oscP5.send(myMessage, scsend);
//}


//void oscEvent(OscMessage theOscMessage) {
//  //  oscP5.send(theOscMessage, scsend);
//  if (theOscMessage.checkAddrPattern("/event")==true) {
//    int event = theOscMessage.get(0).intValue();
//    event = 1;
//    //timeToShowLetter = theOscMessage.get(1).intValue();
//    timeToShowLetter = 300;
//    print("### received an osc message.");
//    print(" addrpattern: "+theOscMessage.addrPattern());
//    print(" typetag: "+theOscMessage.typetag());
//    //print(" event: " +event);
//    //println(" timeToShowLetter: " +timeToShowLetter);
//    if (event <= 2) {
//      letter = chooseLetter(event);
//      now = millis();
//    }
//  }
//}
