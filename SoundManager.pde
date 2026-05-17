import processing.sound.*;

SoundFile helicopterSound;
SoundFile helicopterExplosionSound;
SoundFile parachuteExplodeSound;
SoundFile parachuterExplodeSound;
SoundFile parachuterHittingGroundSound;
SoundFile parachuterLandingSound;
SoundFile shootSound;

void initSounds() {
  helicopterSound = new SoundFile(this, "data/sounds/helicopter.wav");
  helicopterExplosionSound = new SoundFile(this, "data/sounds/helicopter_explosion.wav");
  parachuteExplodeSound = new SoundFile(this, "data/sounds/parachute_explode.wav");
  parachuterExplodeSound = new SoundFile(this, "data/sounds/parachuter_explode.wav");
  parachuterHittingGroundSound = new SoundFile(this, "data/sounds/parachuter_hitting_ground.wav");
  parachuterLandingSound = new SoundFile(this, "data/sounds/parachuter_landing.wav");
  shootSound = new SoundFile(this, "data/sounds/shoot.wav");
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
