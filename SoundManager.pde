import processing.sound.*;

// Gerenciador de efeitos sonoros.
// Centraliza o carregamento e reprodução de todos os arquivos de áudio
// utilizados pelo jogo, mantendo as chamadas em um escopo global isolado.

SoundFile helicopterSound;
SoundFile helicopterExplosionSound;
SoundFile parachuteExplodeSound;
SoundFile parachuterExplodeSound;
SoundFile parachuterHittingGroundSound;
SoundFile parachuterLandingSound;
SoundFile shootSound;

void initSounds() {
  helicopterSound = new SoundFile(this, "sounds/helicopter.wav");
  helicopterExplosionSound = new SoundFile(this, "sounds/helicopter_explosion.wav");
  parachuteExplodeSound = new SoundFile(this, "sounds/parachute_explode.wav");
  parachuterExplodeSound = new SoundFile(this, "sounds/parachuter_explode.wav");
  parachuterHittingGroundSound = new SoundFile(this, "sounds/parachuter_hitting_ground.wav");
  parachuterLandingSound = new SoundFile(this, "sounds/parachuter_landing.wav");
  shootSound = new SoundFile(this, "sounds/shoot.wav");
}

void startHelicopterSound() {
  if (helicopterSound != null && !helicopterSound.isPlaying()) {
    helicopterSound.loop();
  }
}

void stopHelicopterSound() {
  if (helicopterSound != null && helicopterSound.isPlaying()) {
    helicopterSound.stop();
  }
}

void playHelicopterExplosionSound() {
  helicopterExplosionSound.play();
}

void playParachuteExplodeSound() {
  parachuteExplodeSound.play();
}

void playParachuterExplodeSound() {
  parachuterExplodeSound.play();
}

void playParachuterHittingGroundSound() {
  parachuterHittingGroundSound.play();
}

void playParachuterLandingSound() {
  parachuterLandingSound.play();
}

void playShootSound() {
  shootSound.play();
}
