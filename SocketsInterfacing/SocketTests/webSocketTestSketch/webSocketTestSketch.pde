/* StephaneAG - 2012 */
//simple websocket server test sketch

import muthesius.net.*;
import org.webbitserver.*;

WebSocketP5 socket;

void setup(){
    socket = new WebSocketP5(this, 8080);
}

void draw() { }

void stop(){
    socket.stop();
}

void mousePressed(){
    socket.broadcast("hello wolrd of webspckets from processing!");
}

void websocketOnMessage(WebSocketConnection con, String msg){
    println(msg);
}

void WebsocketOnOpen(WebSocketConnection con){
    println("A client just joined");
}

void WebsocketOnClose(WebSocketConnection con){
    println("A client just left");
}
