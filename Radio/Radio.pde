import ddf.minim.*;
import java.io.*;



Minim minim, minim2;
AudioPlayer player, player2;
ArrayList<String> radioUrls;
int currentRadioIndex = 0, ani=0, lastTrigger = 0, lastTrigger2 = 0, lastTrigger3 = 0, numradio=0;
float x=0, pos1 = 180, pos2 = 180, modo=0, pos2ant=0, fr1=-1, bassEnergy = 0, bassThreshold = 0.2;
boolean piscar=false, oant, fant, aant,ligado=false, ruido=false, baixo=false;
//Acima temos as variaveis globais utilizadas, como posição dos botões de tunning e volume, detecção de clique de uma tecla, modo do rádio, on/off, flag para o ruido, numero da radio, nivel de grave, etc...


void setup(){
  //size(1920,1080);
  fullScreen();
  minim = new Minim(this);
  minim2 = new Minim(this);
  radioUrls = loadRadioUrls("radio_urls.txt");
  player2 = minim2.loadFile("ruido.wav");
  //acima crio dois players, um para o ruido e outro para as radios.
}



void draw(){
  scale(1.2);//todo o programa foi desenvolvido numa escala menor por conta do modo janela, agora com o fullscreen podemos reajustar o tamanho
  translate(150,-50);//translate necessário por conta do scale
  if(ligado && modo!=0 && keyPressed && (keyCode == UP || keyCode == DOWN) && ruido==false){
    player2.loop();
    ruido=true;
  }
  //acima é a função que ativa o ruido, quando o radio estiver ligado num modo FM/AM e a pessoa ajustar a faixa de frequencia, o ruido será ativado
  if (millis() - lastTrigger2 >= 5000 && ruido){
    player2.pause();
    lastTrigger2 = millis();
    player.play();
    ruido=false;
  }
  //acima é um controle onde o ruido só ira parar quando passar 5 segundos do ruido aparente, logo após reativamos o radio. 
  if(player2.isPlaying() && player !=null){
    if(player.isPlaying())player.pause();
  }
  //um if de precaução caso o ruido não pare de reproduzir.
  background(230,255,255);
  noStroke();//Criando a caixa de "madeira" do rádio com efeito "3D"
  fill(120,88,60);
  rect(120, 80, 1050, 850, 60);
  fill(200,168,140);
  rect(120, 80, 1020, 820, 45);
  fill(150,118,90);
  rect(140, 100, 1000, 800, 30);
  stroke(100,100,100);
  fill(180,180,180);
  ellipse(400,380,350,350);//Alto falantes
  ellipse(875,380,350,350);
  if (bassEnergy > bassThreshold) {
    fill(140,140,140);
    ellipse(400,380,200+bassEnergy*100,200+bassEnergy*100);
    ellipse(875,380,200+bassEnergy*100,200+bassEnergy*100);
    //Parte do Alto falante que aumenta o raio com o grave
  }
  else{
    fill(130,130,130);
    ellipse(400,380,200,200);
    ellipse(875,380,200,200);
    //Parte do Alto falante padrão
  }
  fill(30,30,30);
  ellipse(400,380,100,100);
  ellipse(875,380,100,100);//Parte do Alto falante
  stroke(255,255,200);
  strokeWeight(10);
  fill(0,0,0,80);
  rect(160, 120, 960, 760, 30);//aplicando sombra
  line(160,652,1120,652);
  strokeWeight(20);
  stroke(180,180,140);
  fill(0,0,0,100);
  rect(170, 662, 940, 203,10);//bordas em bege da parte dos comandos do rádio
  stroke(255,255,200);//abaixo criando um padrão de linha com expessura diferente na parte dos comandos do rádio
  for(int i=0;i<=10;i++){
    if(i%3!=0) strokeWeight(5);
    else strokeWeight(10);
    line(182,685+(i*16),1098,685+(i*16));
  }
  noFill();
  noStroke();
  ellipse(280,760,140,140);
  for(int i = 0; i < 30; i++) {//Criando circulo pontilhado dos botões de tunning e volume
    float arcStart = radians(12*i);
    float arcStop = radians(12*i + 2);
    strokeWeight(8);
    stroke(0,0,0,150);
    arc(280, 760, 140, 140, arcStart, arcStop);
    arc(1000, 760, 140, 140, arcStart, arcStop);
    strokeWeight(5);
    stroke(200,200,200);
    arc(280, 760, 140, 140, arcStart, arcStop);
    arc(1000, 760, 140, 140, arcStart, arcStop);
    
  }
  fill(0,0,0,100);//criando sombra na parte dos comandos do rádio
  noStroke();
  rect(178,670,20,180);
  triangle(198,670,600,670,198,690);
  triangle(198,850,600,850,198,830);
  fill(0,0,0,10);
  for(int i=0;i<=62;i++){//criando linhas da grade dos Alto falantes e aplicando sombra também
    strokeWeight(5);
    stroke(255,255,200);
    bezier(200+(i*15)-i, 120, 175+(i*15), 130, 175+(i*15), 635, 200+(i*15)-i, 645);
    strokeWeight(10);
    stroke(70,70,20,130);
    bezier(210+(i*15)-i, 125, 188+(i*15), 130, 188+(i*15), 635, 210+(i*15)-i, 645);
}
  fill(0,0,0,0);
  stroke(0,0,0,70);
  strokeWeight(5);//Criando sombra para o relevo vermelho nos botões de tunning e volume
  arc(298, 760, 125, 130, (3.14/180)*pos1+1.3, (3.14/180)*pos1+1.8);
  arc(1018, 760, 125, 130,  (3.14/180)*pos2+1.3, (3.14/180)*pos2+1.8);
  fill(0,0,0,70);
  noStroke();
  ellipse(300,760,120,120);//criando sombra para os botões de tunning e volume
  ellipse(1020,760,120,120);
  stroke(150,150,150);
  strokeWeight(0.9);
  fill(0,0,0,255);
  for(int i=120; i>0;i--){//criando efeito de usinagem dos botões de tunning e volume
    ellipse(280,760,i,i);
    ellipse(1000,760,i,i);
  }
  stroke(100,100,100);
  strokeWeight(5);
  noFill();
  ellipse(280,760,50,50);//circuferencia menor dos botões de volume e tunning
  ellipse(1000,760,50,50);
  fill(0,0,0,0);
  stroke(255,0,0);
  strokeWeight(5);
  arc(280, 760, 125, 125, (3.14/180)*pos1+1.3, (3.14/180)*pos1+1.8);//Criando o relevo vermelho nos botões de tunning e volume
  arc(1000, 760, 125, 125, (3.14/180)*pos2+1.3, (3.14/180)*pos2+1.8);
  fill(0,0,0,70);
  noStroke();//criando sombra para os botões de liga, AM e FM
  if(modo==1) ellipse(565,820,40,40);
  else ellipse(570,820,40,40);
  if(ligado) ellipse(645,820,40,40);
  else ellipse(650,820,40,40);
  if(modo==2) ellipse(725,820,40,40);
  else ellipse(730,820,40,40);
  stroke(150,150,150);
  strokeWeight(0.9);
  fill(0,0,0,255);
  for(int i=40; i>0;i--){//criando efeito de usinagem nos botões liga, AM  e FM
    ellipse(560,820,i,i);
    ellipse(640,820,i,i);
    ellipse(720,820,i,i);
  }
  fill(0, 0, 0);//colocando sombra nos nomes
  textSize(16);
  text("AM", 548, 825);
  text("FM", 708, 825);
  text("VOLUME", 248, 850);
  text("TUNING", 971, 850);
  fill(0,0,0,0);
  if(ligado)stroke(0,150,0);
  else stroke(150,0,0);
  strokeWeight(3);//criando simbolo de botão de liga/desliga
  arc(640,820,28,28,-0.77,3.91);
  line(640,805,640,812);
  stroke(0,0,0,70);//criando sombra para o botão de cima
  arc(643,820,28,28,-0.77,3.91);
  line(643,805,643,812);
  //escrevendo funções dos botões, vermelho=desativado verde=ativado
  if(modo==1) fill(0, 150, 0);
  else fill(150, 0, 0);
  text("AM", 547, 825);
  if(modo==2) fill(0, 150, 0);
  else fill(150, 0, 0);
  text("FM", 708, 825);
  fill(200, 200, 200);
  text("VOLUME", 247, 850);
  text("TUNING", 970, 850);
  fill(20,20,20);
  stroke(0,0,0,70);
  rect(365,685,560,100,30);//Black piano da parte das frequencias de AM e FM
  stroke(150,0,0);
  noFill();
  rect(370,690,550,90,30);//Detalhe em vermelho da parte acima
  stroke(200,200,200);
  strokeWeight(5);
  for(int i=0;i<=35;i+=7){//Criando os pontilhados de referencia da parte; FM padrão 4 em 4 e AM padrão 3 em 3
  point(415+i*12,705);
  point(415+(i+1)*12,705);
  point(415+(i+2)*12,705);
  point(415+(i+3)*12,705);
  point(409+(i+1)*12,765);
  point(409+(i+2)*12,765);
  point(409+(i+3)*12,765);
  }
  noStroke();
  fill(230,230,200);//criando ajuste que corre num retangulo para indicar a posição do rádio
  rect(370,725,550,20);
  fill(255,0,0);
  rect(372+pos2*1.5,725,5,20);
  fill(200, 200, 200);//escrevendo frequencias, AM/FM, grandezas MHz/KHz
  textSize(10);
  text("FM", 385, 720);
  text("87", 390, 710);
  text("89", 465, 710);
  text("93", 550, 710);
  text("97", 640, 710);
  text("101", 715, 710);
  text("105", 800, 710);
  text("108", 880, 710);
  text("MHz", 895, 720);
  text("522", 390, 770);
  text("655", 465, 770);
  text("880", 550, 770);
  text("1070", 630, 770);
  text("1280", 715, 770);
  text("1480", 800, 770);
  text("1620", 870, 770);
  text("KHz", 895, 760);
  text("AM", 385, 760);
  
  //Abaixo a parte funcional do código, com a detecção de clique e alteração dos estados AM/FM/LIGA/DESLIGA
  if(keyPressed==false || key!='o' || key!= 'O')oant=true;
  if(keyPressed==false || key!='f' || key!= 'F')fant=true;
  if(keyPressed==false || key!='a' || key!= 'A')aant=true;
  if(keyPressed && keyCode == UP && pos2<360)pos2 +=5;//os botões de tunning e volume aumentam de 5 em 5
  if(keyPressed && keyCode == DOWN && pos2>0)pos2 -=5;
  if(keyPressed && key == '+' && pos1<360)pos1 +=5;
  if(keyPressed && key == '-' && pos1>0)pos1 -=5;
  if(keyPressed && oant && key == 'o' || key == 'O'){
    fr1=-1;//variavel utilizada no controle do liga e desliga
    lastTrigger3=millis();
    if(ligado==false)ligado=true;
    else {
      ligado=false;
      modo=0;//sempre que desligado o FM/AM desativa
      pos2ant=-1;
      pos2=180;
    }
  }
  if(keyPressed && aant && key == 'a' || key == 'A'){
    lastTrigger3=millis();
    pos2ant=-1;
    fr1=-1;
    if(modo==2 || modo==0 && ligado){
      pos2=180;
      modo=1;//alternancia dos modos FM para AM, assim quando AM for ativado FM desliga
    }
    else modo=0;
  }
  if(keyPressed && fant && key == 'f' || key == 'F'){
    lastTrigger3=millis();
    pos2ant=-1;
    fr1=-1;
    if(modo==1 || modo==0 && ligado){
      pos2=180;
      modo=2;//alternancia dos modos AM para FM, assim quando FM for ativado AM desliga
    }
    else modo=0;
  }
  if(ligado && modo!=0 && pos2!=pos2ant && keyPressed ==false && (keyCode !=UP || keyCode !=DOWN)){
    baixo=true;
    fr1=0;
    numradio = int(pos2/360*(getNumberOfRadios()-1));//Calculo do index do rádio
    if (player != null && player.isPlaying()){//se houver mudança de posição do tunning o player é fechado e reaberto no novo index
      player.close();
      playRadio(numradio);
      pos2ant=pos2;
    }
    else{//se não houver nada tocando ja reproduz direto
      playRadio(numradio);
      pos2ant=pos2;
    }
  }
  if(ligado == false || modo==0){
    if (player != null && player.isPlaying()) {//desliga o player se desligar o radio ou o modo AM/FM
      player.close();
    }
  }
  //seta o volume que você escolheu no radio
  if (System.getProperty("os.name").toLowerCase().contains("windows")) {
    setWindowsVolume(pos1); // Defina o volume para 50% no Windows
  } 
  else {
    setLinuxVolume(pos1/360); // Defina o volume para 50% no Linux
  }
  if(modo==0)carinha();// se o radio estiver sem musica a cara fica estática
  else{//se houver musica, a carinha faz um movimento em loop de "V" de forma a curtir a musica
    if(ani==0){
      x+=2;
      translate(x,-2*x);
      carinha();
      if(x>=20){
      ani=1;
      }
    }
    else if(ani==1){
      x-=2;
      translate(x,-2*x);
      carinha();
      if(x<=0){
      ani=2;
      }
    }
    else if(ani==2){
      x-=2;
      translate(x,2*x);
      carinha();
      if(x<=-20){
      ani=3;
      }
    }
    else if(ani==3){
      x+=2;
      translate(x,2*x);
      carinha();
      if(x>=0){
      ani=0;
      }
    }
  }
  //abaixo o controle do piscar da carinha do radio
  if (millis() - lastTrigger >= 3500 && piscar){
    piscar=false;
    lastTrigger = millis();
  }
  else if(millis() - lastTrigger >= 1000 && piscar ==false){
    piscar=true;
    lastTrigger = millis();
  }
  //abaixo o controle do bass/grave que faz mexer o raio do alto falante
  if(player!=null){
    float[] samples = player.left.toArray();
    int start = 0;
    int end = 1000;
    for (int i = start; i < end; i++) {
      bassEnergy += Math.abs(samples[i]);
    }
    bassEnergy /= (end - start);
  }
}








ArrayList<String> loadRadioUrls(String filename) {//Leitura do txt com as URLs de radio, insere numa lista
  ArrayList<String> urls = new ArrayList<String>();
  String[] lines = loadStrings(filename);
  for (String line : lines) {
    urls.add(line);
  }
  return urls;
}




void playRadio(int index) {//função para reproduzir as radios sem erro, só precisa do index da radio
  if (index >= 0 && index < radioUrls.size()) {
    if (player != null && player.isPlaying()) {
      player.close();
    }
    try {
      player = minim.loadFile(radioUrls.get(index));
      player.play();
      currentRadioIndex = index;
    } 
    catch (Exception e) {
      println("Erro ao reproduzir a URL N°: " + e.getMessage() + " " + index + " da lista" );
      if(index < radioUrls.size())
        playRadio(index+1);
      else playRadio(0);
    }
  } 
  else {
    println("Índice de rádio inválido.");
  }
}




int getNumberOfRadios() {//quantidade de radios
  return radioUrls.size();
}



void setWindowsVolume(float volumePercentage){//setar volume no windows
  String command = "cmd /c nircmd setsysvolume " + int(volumePercentage*(65535/360));
  executeCommand(command);
}


void setLinuxVolume(float volume) {//setar o volume no linux
  String command = "amixer sset Speaker Playback " + volume * 100 + "%";
  executeCommand(command);
}

void executeCommand(String command){//executa o comando
  try {
    Process process = Runtime.getRuntime().exec(command);
    process.waitFor();
  } catch (IOException e) {
    e.printStackTrace();
  } catch (InterruptedException e) {
    e.printStackTrace();
  }
}




void carinha(){//parte de analise e escolha de quais combinações de rostos se encaixam no momento
  scale(0.8);
  translate(180,150);
  if(modo!=0){
    if(fr1<70 && baixo){
      fr1+=5;
    }
    else if(fr1>0 && baixo==false){
      fr1-=5;
    }
    else{
      if(baixo) baixo=false; 
    }
    if(fr1!=0){
      scale(0.7);
      translate(250,-100);
      olhopiscado();
      boca2();
      stroke(0,0,0);
      sombrancelha2();
      translate(-250,+100);
    }
    else if(piscar){
      scale(0.7);
      translate(250,-100);
      stroke(0,0,0);
      sombrancelha1();
      olhoaberto();
      translate(420,0);
      olhoaberto();
      translate(-420,0);
      boca1();
      translate(-250,+100);
      }
    else{
      scale(0.7);
      translate(250,-100);
      stroke(0,0,0);
      sombrancelha1();
      olhofechado();
      translate(420,0);
      olhofechado();
      translate(-420,0);
      boca1();
      translate(-250,+100);
    }
  }
  else if(ligado){
    if(fr1<70 && baixo){
      fr1+=5;
    }
    else if(fr1>0 && baixo==false){
      fr1-=5;
      if(fr1==-1)fr1=0;
    }
    else{
      if(baixo) baixo=false;
    }
    if(fr1>0){
      scale(0.7);
      translate(250,-100);
      stroke(0,0,0);
      sombrancelha1();
      olhoaberto();
      translate(420,0);
      olhoaberto();
      translate(-420,0);
      boca5();
      translate(-250,+100);
    }
    else if(fr1==0 && baixo==false){
      scale(0.7);
      translate(250,-100);
      stroke(0,0,0);
      sombrancelha3();
      olhobravo();
      translate(420,0);
      olhobravo();
      translate(-420,0);
      boca4();
      translate(-250,+100);
      fr1=-2;
    }
    else if(fr1==-2){
      delay(2000);
      fr1=-1;
    }
    else if(piscar){
      scale(0.7);
      translate(250,-100);
      stroke(0,0,0);
      sombrancelha4();
      olhotriste();
      boca5();
      translate(-250,+100);
    }
    else{
      scale(0.7);
      translate(250,-100);
      stroke(0,0,0);
      sombrancelha4();
      olhofechado();
      translate(420,0);
      olhofechado();
      translate(-420,0);
      boca5();
      translate(-250,+100);
    }
    if (millis() - lastTrigger3 >= 15000 && baixo==false){
      baixo=true;
      fr1=-1;
      lastTrigger3 = millis();
    }
  }
  else{
    scale(0.7);
    translate(250,-100);
    stroke(0,0,0);
    sombrancelha1();
    olhofechado();
    translate(420,0);
    olhofechado();
    translate(-420,0);
    boca3();
    translate(-250,+100);
  }
}




//ABAIXO desenvolvimento de todas as caras/bocas/sombrancelhas/olhos

void sombrancelha1(){
  strokeWeight(25);
  noFill();
  arc(390,300,320,307,3.5,5.1);
  arc(890,300,320,307,4.3,5.9);
  noStroke();
}




void boca1(){
  strokeWeight(25);
  stroke(0,0,0);
  noFill();
  arc(640,500,800,600,0.97,2.17);
  arc(640,400,500,1000,1.27,1.87);
  arc(360,710,100,100,0,1.57);
  arc(920,710,100,100,1.57,3.14);
  noStroke();
}




void olhoaberto(){
  fill(225);
  ellipse(440,400,300,300);
  strokeWeight(40);
  stroke(0,0,0,30);
  noFill();
  arc(440,400,280,270,-1.5,2.18);
  strokeWeight(1);
  stroke(0,0,0);
  noStroke();
  fill(225);
  ellipse(420,400,300,300);
  translate(0,fr1);
  fill(0,0,150);
  ellipse(430,400,150,150);
  fill(0);
  ellipse(430,400+0.5*fr1,80,80);
  fill(255,255,255,100);
  ellipse(370,360,80-(fr1*(30.0/70.0)),80-(fr1*(30.0/70.0)));
  ellipse(490,450,50-(fr1*(30.0/70.0)),50-(fr1*(30.0/70.0)));
  translate(0,-fr1);
  fill(0,0,0,40);
  ellipse(430,400,320,307);
  fill(255,255,255,20);
  ellipse(430,400,280,267);
}




void olhodireita(){
  noStroke();
  fill(225);
  ellipse(440,400,300,300);
  strokeWeight(40);
  stroke(0,0,0,30);
  noFill();
  arc(440,400,280,270,-1.5,2.18);
  strokeWeight(1);
  stroke(0,0,0);
  noStroke();
  fill(225);
  ellipse(420,400,300,300);
  translate(0,fr1);
  fill(0,0,150);
  ellipse(430+0.5*fr1,400,150,150);
  fill(0);
  ellipse(430+0.6*fr1,400+0.5*fr1,80,80);
  fill(255,255,255,100);
  ellipse(370,360,80-(fr1*(30.0/70.0)),80-(fr1*(30.0/70.0)));
  ellipse(490,450,50-(fr1*(30.0/70.0)),50-(fr1*(30.0/70.0)));
  translate(0,-fr1);
  fill(0,0,0,40);
  ellipse(430,400,320,307);
  fill(255,255,255,20);
  ellipse(430,400,280,267);
  noStroke();
}



void sombrancelha2(){
  strokeWeight(20);
  bezier(280, 200, 280, 150,530, 200, 530, 150);
  bezier(750, 150, 750, 200,1000, 150, 1000, 200);
  noStroke();
}




void olhopiscado(){
  strokeWeight(20);
  stroke(0);
  int pcentralx = 720; 
  int pcentraly = 480;
  noFill();
  if(fr1>35 && fr1<=70){
    bezier(pcentralx, pcentraly, 800, 420,860, 400, 1000, 400);
    bezier(pcentralx, pcentraly, 710, 400,730, 350, 760, 300);
    bezier(pcentralx, pcentraly, 730, 430,830, 350, 900, 320);
  }
  else{
    translate(420,0);
    olhodireita();
    translate(-420,0);
  }
  olhodireita();
  noStroke();
}



void boca2(){
  stroke(0);
  strokeWeight(3);
  fill(150, 0, 0);
  beginShape();
  vertex(400, 750);
  bezierVertex(550, 1000, 950, 1000, 950, 550);
  bezierVertex(800, 750, 600, 750, 400, 750);
  endShape();
  fill(255);
  beginShape();
  vertex(450, 755);
  bezierVertex(550, 850, 800, 800, 900, 610);
  bezierVertex(810, 720, 600, 755, 500, 755);
  endShape();
  noFill();
  noStroke();
}




void olhofechado(){
  fill(220,120,255);
  ellipse(440,400,300,300);
  strokeWeight(40);
  stroke(0,0,0,30);
  noFill();
  arc(440,400,280,270,-1.5,2.18);
  strokeWeight(1);
  stroke(0,0,0);
  noStroke();
  fill(220,120,255);
  ellipse(420,400,300,300);
  fill(0,0,0,40);
  ellipse(430,400,320,307);
  fill(255,255,255,20);
  ellipse(430,400,280,267);
  noFill();
  strokeWeight(10);
  stroke(0);
  arc(430,400,325,315,0.6,2.58);
  noStroke();
}




void boca3(){
  strokeWeight(25);
  stroke(0,0,0);
  noFill();
  line(410,750,870,750);
  arc(640,900,200,100,3.14,6.28);
  arc(360,710,100,100,0,1.57);
  arc(920,710,100,100,1.57,3.14);
  noStroke();
}




void olhobravo(){
  fill(225);
  ellipse(440,400,300,300);
  strokeWeight(40);
  stroke(0,0,0,30);
  noFill();
  arc(440,400,280,270,-1.5,2.18);
  strokeWeight(1);
  stroke(0,0,0);
  noStroke();
  fill(225);
  ellipse(420,400,300,300);
  fill(0,0,150);
  ellipse(430,450,150,150);
  fill(0);
  ellipse(430,450,80,80);
  fill(255,255,255,100);
  ellipse(370,360,80,80);
  ellipse(490,450,50,50);
  fill(0,0,0,40);
  ellipse(430,400,320,307);
  fill(255,255,255,20);
  ellipse(430,400,280,267);
  fill(220,120,255);
  beginShape();
  vertex(270,400);
  bezierVertex(270,190,590,190,590,400);
  bezierVertex(590,350,270,350,270,400);
  noStroke();
  endShape();
}




void sombrancelha3(){
  strokeWeight(25);
  noFill();
  arc(850,300,320,307,3.5,5.1);
  arc(430,300,320,307,4.3,5.9);
  noStroke();
}




void boca4(){
  stroke(70,0,0);
  strokeWeight(10);
  //line(410,750,870,750);
  fill(215,215,200);
  beginShape();
  vertex(310,750);
  bezierVertex(270,950,600,790,600,800);
  bezierVertex(640,790,640,790,680,800);
  bezierVertex(680,790,1010,950,970,750);
  bezierVertex(870,550,700,650,640,680);
  bezierVertex(580,650,410,550,310,750);
  endShape();
  stroke(100,100,100);
  bezier(310,750,640,720,640,720,970,750);
  line(630,787,640,683);
  noFill();
  bezier(410,850,390,750,390,750,410,650);
  bezier(520,820,500,730,500,730,520,640);
  bezier(870,850,890,750,890,750,870,650);
  bezier(760,820,780,730,780,730,760,640);
  noStroke();
}




void olhotriste(){
  fill(225);
  ellipse(440,400,300,300);
  strokeWeight(40);
  stroke(0,0,0,30);
  noFill();
  arc(440,400,280,270,-1.5,2.18);
  strokeWeight(1);
  stroke(0,0,0);
  noStroke();
  fill(225);
  ellipse(420,400,300,300);
  fill(0,0,150);
  ellipse(450,450,150,150);
  fill(0);
  ellipse(450,450,80,80);
  fill(255,255,255,100);
  ellipse(370,360,80,80);
  ellipse(490,450,50,50);
  fill(0,0,0,40);
  ellipse(430,400,320,307);
  fill(255,255,255,20);
  ellipse(430,400,280,267);
  fill(220,120,255);
  beginShape();
  vertex(270,450);
  bezierVertex(250,190,500,190,590,350);
  bezierVertex(590,400,270,450,270,450);
  endShape();
  translate(420,0);
  fill(225);
  ellipse(440,400,300,300);
  strokeWeight(40);
  stroke(0,0,0,30);
  noFill();
  arc(440,400,280,270,-1.5,2.18);
  strokeWeight(1);
  stroke(0,0,0);
  noStroke();
  fill(225);
  ellipse(420,400,300,300);
  fill(0,0,150);
  ellipse(410,450,150,150);
  fill(0);
  ellipse(410,450,80,80);
  fill(255,255,255,100);
  ellipse(370,360,80,80);
  ellipse(490,450,50,50);
  fill(0,0,0,40);
  ellipse(430,400,320,307);
  fill(255,255,255,20);
  ellipse(430,400,280,267);
  fill(220,120,255);
  beginShape();
  vertex(270,350);
  bezierVertex(360,190,610,190,590,450);
  bezierVertex(590,450,270,400,270,350);
  endShape();
  translate(-420,0);
}



void sombrancelha4(){
  strokeWeight(25);
  noFill();
  arc(430,300,320,307,3.44,4.71);
  arc(850,300,320,307,4.71,5.88);
  noStroke();
}



void boca5(){
  strokeWeight(15);
  stroke(0,0,0);
  noFill();
  arc(640,850,150,100,3.14,6.28);
  fill(150,0,0);
  strokeWeight(10);
  beginShape();
  vertex(430,750);
  bezierVertex(580,550,700,550,850,750);
  bezierVertex(850,720,430,720,430,750);
  endShape();
  fill(215,215,200);
  beginShape();
  vertex(520,650);
  bezierVertex(595,580,685,580,760,650);
  bezierVertex(750,680,520,680,520,650);
  endShape();
  
}
