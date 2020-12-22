import ddf.minim.analysis.*;

final static float FREQ = 220;
final static int SR = 22050;
final static int FFT_SCALE = 1000;

float[] audio;
boolean do_hann = true;

void setup() {
  size(1500, 800);
  stroke(255);
  textSize(36);
}

FFT newFFT(int frame_len) {
  FFT fft = new FFT(frame_len, SR);
  fft.window(FFT.HANN);
  return fft;
}

void draw() {
  background(255);
  // int frame_len = round(pow(2, int(mouseY / (float) height * 8 + 4)));
  int frame_len = mouseY * 2048 / height;
  audio = new float[frame_len];
  pushMatrix();
  scale(1, .45);
  fill(0);
  rect(0, 0, width, height);
  drawWave(frame_len);
  translate(0, height * 1.1);
  fill(0);
  rect(0, 0, width, height);
  drawSpec(frame_len);
  popMatrix();
  text("Click to toggle", width * .7, height * .62);
  String msg;
  if (do_hann) {
    msg = "Hann";
  } else {
    msg = "rectangular";
  }
  text("window: " + msg, width * .7, height * .7);
}

void drawWave(int frame_len) {
  // noFill();
  // stroke(255);
  // beginShape();
  float i; int x; float t; int y;
  // for (i = 0; i < 1f; i += .001) {
  //   x = round(width * i);
  //   t = i * frame_len / SR;
  //   y = round(height * (sin(t * 2 * PI * FREQ) * .4 + .5));
  //   vertex(x, y);
  // }
  // endShape();
  fill(255);
  noStroke();
  int j;
  for (j = 0; j < frame_len; j++) {
    x = width * j / frame_len;
    t = j / (float) SR;
    audio[j] = sin(t * 2 * PI * FREQ);
    if (do_hann) {
      audio[j] *= sq(cos(PI * (j - frame_len/2) / frame_len));
    }
    y = round(height * (audio[j] * .4 + .5));
    rect(
      x, 0, 
      2, y
    );
  }
}

void drawSpec(int frame_len) {
  // FFT fft = newFFT(frame_len);
  // fft.forward(audio);
  int max_bin = round(frame_len * .03);
  fill(255, 0, 0);
  stroke(255, 0, 0);
  // for (int i = 0; i < max_bin; i ++) {
  //   rect(
  //     width * i / max_bin, 
  //     0,
  //     2, 
  //     fft.getBand(i) / frame_len * FFT_SCALE
  //   );
  // }

  noFill();
  beginShape();
  int x; float bin; float y;
  float step = max_bin * .001;
  for (bin = max_bin; bin > 0; bin -= step) {
    x = round(width * bin / max_bin);
    y = sft(audio, frame_len, bin) * FFT_SCALE;
    vertex(x, y);
  }
  endShape();
}

float sft(float[] signal, int size, float bin) {
  float acc_c = 0;
  float acc_s = 0;
  float phase;
  float c; float s;
  for (int i = 0; i < size; i ++) {
    phase = i * bin / size * 2 * PI;
    acc_c += cos(phase) * signal[i];
    acc_s += sin(phase) * signal[i];
  }
  return sqrt(sq(acc_c) + sq(acc_s)) / size;
}

void mouseClicked() {
  do_hann = ! do_hann;
}
